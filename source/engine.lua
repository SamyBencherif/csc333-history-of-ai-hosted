-- @author: Samy Bencherif
-- @description: This file contains helper code for object management and such
-- @technical: Love2d framework contains code for window management, rendering, filesystem access
--            etc. It does not provide spritesheet slicing, animation, scene management, etc.
--            This file contains our extension of the framework.

local gameio = require("gameio")
local assets = require("assets")

local engine = {};
local db

-- Safe way to clear a scene. All asset pools and scenes are preserved in memory.
-- GameObjects are destroyed.
engine.reset = function ()
    engine.time = 0;
    engine.tint = {1,1,1,1};
    engine.gameobjects = {};
end

engine.removeGameObject = function(obj)

    for i=1,#engine.gameobjects do
        if engine.gameobjects[i] == obj then
            engine.gameobjects[i] = nil
        end
    end

end

-- Adds a gameObject to the world
engine.addGameObject = function (obj, renderer, behavior)

    -- Apply renderer if specified
    -- Remember in Love, all drawing must occur in the draw loop
    if renderer ~= nil then
        obj.draw = function()
            renderer(obj);
        end
    end

    -- Apply behavior if specified
    if behavior ~= nil then
        obj.update = function()
            behavior(obj);
        end
    end

    table.insert(engine.gameobjects, obj);

    return obj; -- for chaining
end

engine.quickDialog = function(stageDirections, targetScene)
    db = engine.addGameObject(
        {
            narrative=gameio.readLines(stageDirections);
            narrativeIndex=1;
            charsVisible=0;
            font=assets.joystixPixelFont;
            textRate=2.4;
        }, engine.dialogBox
    )

    db.mousepressed = function(x, y, button, istouch)
        if engine.makeThatOneDecision then return end

        if db and db.narrativeIndex < #db.narrative then
            db.narrativeIndex = db.narrativeIndex + 1;
            db.charsVisible = 0;
        elseif db then
            -- user has clicked past all the dialog in this scene
            local dartmouth = require(targetScene);
            engine.loadScene(dartmouth, true);
        end
    end
    return db
end

-- Imports a scene to the world
engine.loadScene = function(scene, performReset)

    -- clear gameobjects from previous scene
    if performReset then
        engine.reset()
    end

    -- generate and add new gameobjects
    scene.load()
end

-- Pulls an audio file from the sounds directory into memory
-- @param dbkey: Name without extension of audio file, files should be MP3
-- @param srcType: Optional source type, should be "stream" for larger files
--                 (See https://love2d.org/wiki/SourceType)
engine.importAudio = function (dbKey, srcType)

    local localResource = {};

    if srcType == nil then
        srcType = "static"
    end

    localResource.type = "sound";
    localResource.audioSource = love.audio.newSource( "sounds/"..dbKey..".mp3", srcType )

    -- store this resource in an accessible location
    engine.resources[dbKey] = localResource;

end

-- Pulls a spritesheet from the spritesheet directory into memory
-- @param dbkey: Name without extension of the spritesheet, files should be PNG
-- @param fwidth: The width of a single frame
-- @param fheight: The height of a single frame
-- @param count: If the spritesheet is a perfect packing, we can compute this value (leave it out).
--               If the packing is imperfect, specify the number of frames here.
engine.importSpritesheet = function (dbKey, fwidth, fheight, count)

    local texPath = "spritesheets/"..dbKey..".png";
    local localResource = {};

    localResource.type = "animation";
    localResource.spritesheet = love.graphics.newImage(texPath);
    localResource.frames = {};
   
    -- small w represents the width of a single frame
    local w = fwidth;
    local h = fheight;

    -- big W reprsents the width of the whole spritesheet
    local W = localResource.spritesheet:getWidth();
    local H = localResource.spritesheet:getHeight();
 
    for y=0,math.floor(H/h)-1 do
        for x=0,math.floor(W/w)-1 do

            -- If count is defined, we may need to break out of the loop early
            if count ~= nil then

                -- if count was initially 0, do not insert quads (maybe useful for helper objects)
                if count == 0 then
                    break
                end

                count = count - 1
            end

            -- We populate the array 'frames' with Love2D quad objects pointing to the correct
            -- regions of the spritesheet
            table.insert(localResource.frames, 
                love.graphics.newQuad(w*x, h*y, w, h, W, H)
            );

            -- if count is set to 0, break after inserting the last quad
            if count == 0 then
                break
            end
        end
    end

    -- store this resource in an accessible location
    engine.resources[dbKey] = localResource;
end

-- audio source that starts playing after amount of seconds
engine.timedAudioSource = function (obj)
    if engine.time >= obj.timeStart and not obj.playing then
        love.audio.play(engine.resources[obj.audio].audioSource)
        obj.playing = true;
    end
end


-- renders an animated sprite
engine.animatedSprite = function (obj)

    local sprite = obj.sprite;
    local framerate = obj.framerate;

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    -- disable any tinting (tint white)
    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )

    if obj.scale == nil then
        obj.scale = 2
    end

    -- We select the spritesheet as the image to draw and the sprite quad as the drawing region.
    -- The sprite quad is collected by indexing the array with an expression of time.
    love.graphics.draw(engine.resources[sprite].spritesheet, 
        engine.resources[sprite].frames[math.floor(framerate*engine.time) % 
        #engine.resources[sprite].frames + 1], obj.x, obj.y, 0, obj.scale, obj.scale
    );
end

-- an object that will come into existence, wait an amount of time
-- complete a task
-- @property activiationTime: time in seconds when the action should occur
-- @property action: function that should be called when activationTime passes
-- @property finished: should be initialized to false
engine.deferredAgent = function (obj)

    if engine.time >= obj.activationTime and not obj.finished then
        obj.action()
        obj.finished = true
    end

end

-- sprite with animated text
-- @property font: font to render text in
-- @property color: color render text in
-- @property text: text to appear on screen
engine.staticText = function (obj)

    -- Setting the font so that it is used when drawning the string.
    love.graphics.setFont(obj.font)

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    -- Filter by object tint and world tint
    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )

    -- Draw text
    love.graphics.print(
        obj.text, 
        obj.x, obj.y
    )
end

engine.block = function (obj)

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )
    love.graphics.rectangle("fill", obj.x, obj.y, obj.w, obj.h )
end

engine.backdrop = function (obj)

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )
    love.graphics.rectangle("fill", 0, 0, 640, 480 )
end

-- sprite with animated text
engine.animatedText = function (obj)

    local sprite = obj.sprite
    local framerate = obj.framerate

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )

    love.graphics.draw(engine.resources[sprite].spritesheet, 
        engine.resources[sprite].frames[math.floor(framerate*engine.time) % 
        #engine.resources[sprite].frames + 1], obj.x, obj.y, 0, 2, 2
    );

    -- Setting the font so that it is used when drawning the string.
    love.graphics.setFont(obj.font)

    -- Present one additional string character each frame
    obj.charsVisible = obj.charsVisible + obj.textRate

    -- Text color is black
    love.graphics.setColor(0,0,0)

    -- Renders the correct substring of text
    -- The offset is hardcoded
    love.graphics.print(
        string.sub(obj.text, 0, obj.charsVisible), 
        obj.x+20, obj.y+20
    )
end

-- sprite with animated text
engine.dialogBox = function (obj)

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )

    love.graphics.draw(engine.resources["paragraph-block"].spritesheet, 
        engine.resources["paragraph-block"].frames[1], 10, 370, 0, 2, 2
    );

    -- Setting the font so that it is used when drawning the string.
    love.graphics.setFont(obj.font)

    -- Present one additional string character each frame
    obj.charsVisible = obj.charsVisible + obj.textRate

    -- Text color is black
    love.graphics.setColor(0,0,0)

    local namedText = engine.textParser(obj.narrative[obj.narrativeIndex])

    if string.sub(namedText, 0, 9) == "McCarthy:" then
        namedText = string.sub(namedText, 10)
        if not engine.pipHidden then
            -- make any existing pip invisible
            if engine.pip and engine.pip.sprite ~= "mccarthy" then
                engine.removeGameObject(engine.pip)
            end

            -- add new pip
            if engine.pip == nil or engine.pip.sprite ~= "mccarthy" then
                engine.pip = engine.addGameObject({x=25; y=290; sprite="mccarthy"; framerate=12, scale=1}, engine.animatedSprite)
            end
        end
    elseif string.sub(namedText, 0, 7) == "Newell:" then
        namedText = string.sub(namedText, 8)
        if not engine.pipHidden then
            -- make any existing pip invisible
            if engine.pip and engine.pip.sprite ~= "newell" then
                engine.removeGameObject(engine.pip)
            end

            -- add new pip
            if engine.pip == nil or engine.pip.sprite ~= "newell" then
                engine.pip = engine.addGameObject({x=25; y=265; sprite="newell"; framerate=12, scale=1}, engine.animatedSprite)
            end
        end
    elseif string.sub(namedText, 0, 11) == "Rosenblatt:" then
        namedText = string.sub(namedText, 12)
        if not engine.pipHidden then
            -- make any existing pip invisible
            if engine.pip and engine.pip.sprite ~= "rosenblatt" then
                engine.removeGameObject(engine.pip)
            end

            -- add new pip
            if engine.pip == nil or engine.pip.sprite ~= "rosenblatt" then
                engine.pip = engine.addGameObject({x=25-6; y=290-37; sprite="rosenblatt"; framerate=12, scale=1}, engine.animatedSprite)
            end
        end
    elseif string.sub(namedText, 0, 7) == "Minsky:" then
        namedText = string.sub(namedText, 8)
        if not engine.pipHidden then
            -- make any existing pip invisible
            if engine.pip and engine.pip.sprite ~= "minsky" then
                engine.removeGameObject(engine.pip)
            end

            -- add new pip
            if engine.pip == nil or engine.pip.sprite ~= "minsky" then
                engine.pip = engine.addGameObject({x=25; y=290; sprite="minsky"; framerate=12, scale=1}, engine.animatedSprite)
            end
        end
    end

    if (namedText == "So what do you say, hooligan, \ncare to hear my story? " and not engine.makeThatOneDecision) then
        engine.makeThatOneDecision = true
        local btnYes = engine.addGameObject({text="Yes"; x=100; y=100; w=100; h=20; font=assets.joystixPixelFont} , engine.button)
        local btnNo = engine.addGameObject({text="No"; x=200; y=100;  w=100; h=20; font=assets.joystixPixelFont}, engine.button)
        btnYes.mousemoved = function(x, y, button, istouch)
            if btnYes.x < x and x < btnYes.x + btnYes.w and
                btnYes.y < y and y < btnYes.y + btnYes.h then
                    btnYes.color = {1,0,0,1};
                else
                    btnYes.color = {1,1,1,1};
            end
        end

        btnNo.mousemoved = function(x, y, button, istouch)
            if btnNo.x < x and x < btnNo.x + btnNo.w and
                btnNo.y < y and y < btnNo.y + btnNo.h then
                    btnNo.color = {1,0,0,1};
                else
                    btnNo.color = {1,1,1,1};
            end
        end

        btnYes.mousepressed = function(x, y, button, istouch)
            if btnYes.x < x and x < btnYes.x + btnYes.w and
                btnYes.y < y and y < btnYes.y + btnYes.h then
                    -- player pressed yes
                    engine.makeThatOneDecision = false
                    engine.removeGameObject(btnYes)
                    engine.removeGameObject(btnNo)
                    db.narrativeIndex = db.narrativeIndex + 1
            end
        end

        btnNo.mousepressed = function(x, y, button, istouch)
            if btnNo.x < x and x < btnNo.x + btnNo.w and
                btnNo.y < y and y < btnNo.y + btnNo.h then
                    engine.loadScene(require("scenes/death"), true)
            end
        end
    end

    if (string.sub(namedText, 0, 27) == " And don't think of escapin" and not engine.makeThatOneDecision) then
        engine.makeThatOneDecision = true
        local btnYes = engine.addGameObject({text="Escape"; x=100; y=100; w=100; h=20; font=assets.joystixPixelFont} , engine.button)
        btnYes.mousemoved = function(x, y, button, istouch)
            if btnYes.x < x and x < btnYes.x + btnYes.w and
                btnYes.y < y and y < btnYes.y + btnYes.h then
                    btnYes.color = {1,0,0,1};
                else
                    btnYes.color = {1,1,1,1};
            end
        end

        btnYes.mousepressed = function(x, y, button, istouch)
            if btnYes.x < x and x < btnYes.x + btnYes.w and
                btnYes.y < y and y < btnYes.y + btnYes.h then
                    -- player pressed yes
                    engine.loadScene(require("scenes/credits"), true)

            end
        end
    end



    -- Renders the correct substring of text
    -- The offset is hardcoded
    love.graphics.print(
        string.sub(namedText, 0, obj.charsVisible), 
        30, 390
    )
end

engine.button = function(obj)


    -- Setting the font so that it is used when drawning the string.
    love.graphics.setFont(obj.font)

    if obj.color == nil then
        obj.color = {1,1,1,1}
    end

    -- Filter by object tint and world tint
    love.graphics.setColor(
        engine.tint[1]*obj.color[1], 
        engine.tint[2]*obj.color[2], 
        engine.tint[3]*obj.color[3], 
        engine.tint[4]*obj.color[4]
    )

    -- Draw text
    love.graphics.print(
        obj.text, 
        obj.x, obj.y
    )

end

engine.textParser = function (str)
  if str == nil then return "" end
  local charCount = 0
  local lineLength = 0
  local maxLineLength = 39
  local output = ""
  while charCount < string.len(str) do
    local word = string.match(str, '[%g]*', charCount)
    if lineLength + string.len(word) > maxLineLength then
      output = output.."\n"
      lineLength = 0
    end
    if charCount == 0 then
      output = output..word
    else
      output = output..word.." "
    end
    charCount = charCount + string.len(word) + 1
    lineLength = lineLength + string.len(word) + 1
  end
  return output
end

-- Keep track of time and run any gameObject-specific update routines
engine.update = function (dt)
    engine.time = engine.time + dt;
    engine.deltaTime = dt;

    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i] == nil) then return end

        if (engine.gameobjects[i].update) then

            -- calls the gameObject's update function
            -- current time is available as `engine.time`
            -- delta time is available as `engine.deltaTime`
            engine.gameobjects[i].update()
        end
    end
end

-- Draw each gameObject.
engine.draw = function ()
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i] == nil) then return end
        if (engine.gameobjects[i].draw) then
            engine.gameobjects[i].draw()
        end
    end
end

-- Propagate clicks to gameObjects
engine.mousepressed = function(x, y, button, istouch)
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i] == nil) then return end
        if (engine.gameobjects[i].mousepressed) then
            engine.gameobjects[i].mousepressed(x, y, button, istouch)
        end
    end
end

-- Propagate clicks to gameObjects
engine.mousemoved = function(x, y, button, istouch)
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i] == nil) then return end
        if (engine.gameobjects[i].mousemoved) then
            engine.gameobjects[i].mousemoved(x, y, button, istouch)
        end
    end
end


-- Give a reference to this engine to the calling program
return engine;