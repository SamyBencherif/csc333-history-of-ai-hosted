-- @author: Samy Bencherif
-- @description: This file contains helper code for object management and such
-- @technical: Love2d framework contains code for window management, rendering, filesystem access
--            etc. It does not provide spritesheet slicing, animation, scene management, etc.
--            This file contains our extension of the framework.

local engine = {};

-- Safe way to clear a scene. All asset pools and scenes are preserved in memory.
-- GameObjects are destroyed.
engine.resDet = function ()
    engine.time = 0;
    engine.gameobjects = {};
end

-- Adds a gameObject to the world
engine.addGameObject = function (obj)
    table.insert(engine.gameobjects, obj);
end

-- Imports a scene to the world
engine.loadScene = function(scene)

    -- clear gameobjects from previous scene
    engine.reset()

    -- generate and add new gameobjects
    scene.load()

    -- register interaction events
    love.mousepressed = scene.mousepressed
    love.mousemoved = scene.mousemoved
    love.mousereleased = scene.mousereleased
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

-- Renderers are functions that return functions, they serve the purpose of being
-- easily exchangeable while maintaining the immutable properties of an object.

-- renders an animated sprite
engine.animRenderer = function (obj, options)

    local sprite = options.sprite;
    local framerate = options.framerate;

    return function()

        -- disable any tinting (tint white)
        love.graphics.setColor(1,1,1)

        -- We select the spritesheet as the image to draw and the sprite quad as the drawing region.
        -- The sprite quad is collected by indexing the array with an expression of time.
        love.graphics.draw(engine.resources[sprite].spritesheet, 
            engine.resources[sprite].frames[math.floor(framerate*engine.time) % 
            #engine.resources[sprite].frames + 1], obj.x, obj.y, 0, 2, 2
        );
    end

end

-- renders a sprite with animated text
engine.textRenderer = function (obj, options)
    local sprite = options.sprite;
    local framerate = options.framerate;
    return function()
        love.graphics.setColor(1,1,1)

        love.graphics.draw(engine.resources[sprite].spritesheet, 
            engine.resources[sprite].frames[math.floor(framerate*engine.time) % 
            #engine.resources[sprite].frames + 1], obj.x, obj.y, 0, 2, 2
        );

        -- Setting the font so that it is used when drawning the string.
        love.graphics.setFont(options.font)

        -- Present one additional string character each frame
        obj.charsVisible = obj.charsVisible + options.textRate

        -- Text color is black
        love.graphics.setColor(0,0,0)

        -- Renders the correct substring of text
        -- The offset is hardcoded
        love.graphics.print(
            string.sub(obj.text, 0, obj.charsVisible), 
            obj.x+20, obj.y+20
        )
    end
end

-- Shorthand to apply renders to objects
engine.setRenderer = function (obj, renderer, opt)
    obj.draw = renderer(obj, opt);
    return obj; -- for chaining
end

-- Keep track of time and run any gameObject-specific update routines
engine.update = function (dt)
    engine.time = engine.time + dt;
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i].update) then
            engine.gameobjects[i].update(dt, time)
        end
    end
end

-- Draw each gameObject.
engine.draw = function ()
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i].draw) then
            engine.gameobjects[i].draw()
        end
    end
end

-- Give a reference to this engine to the calling program
return engine;