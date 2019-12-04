-- author: Samy Bencherif
-- description: This file contains helper code for object management and such

local engine = {};

-- Initialized here to preserve resources over reloads
engine.resources = {};

engine.reset = function ()
    engine.time = 0;
    engine.gameobjects = {};
end

engine.addGameObject = function (obj)
    table.insert(engine.gameobjects, obj);
end

engine.importSpritesheet = function (dbKey, fwidth, fheight, count)
    local texPath = "spritesheets/"..dbKey..".png";
    local localResource = {};
    localResource.type = "animation";
    localResource.spritesheet = love.graphics.newImage(texPath);
    localResource.frames = {};
   
    local w = fwidth;
    local h = fheight;
    local W = localResource.spritesheet:getWidth();
    local H = localResource.spritesheet:getHeight();
 
    for y=0,math.floor(H/h)-1 do
        for x=0,math.floor(W/w)-1 do
            if count ~= nil then
                if count == 0 then
                    break
                end
                count = count - 1

            end
            table.insert(localResource.frames, 
                love.graphics.newQuad(w*x, h*y, w, h, W, H)
            );
        end
        if count == 0 then
            break
        end
    end

    engine.resources[dbKey] = localResource;
end

engine.animRenderer = function (obj, options)
    local name = options.name;
    local framerate = options.framerate;
    return function()
        love.graphics.draw(engine.resources[name].spritesheet, 
            engine.resources[name].frames[math.floor(framerate*engine.time) % 
            #engine.resources[name].frames + 1], obj.x, obj.y, 0, 2, 2
        );
    end
end

engine.setRenderer = function (obj, renderer, opt)
    obj.draw = renderer(obj, opt);
    return obj; -- for chaining
end

engine.update = function (dt)
    engine.time = engine.time + dt;
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i].update) then
            engine.gameobjects[i].update(dt, time)
        end
    end
end

engine.draw = function ()
    for i=1,#engine.gameobjects do
        if (engine.gameobjects[i].draw) then
            engine.gameobjects[i].draw()
        end
    end
end

return engine;