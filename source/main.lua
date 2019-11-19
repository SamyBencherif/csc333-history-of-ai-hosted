--      author: Samy Bencherif
-- description: It's a science fiction type game (?)

-- Initialized here to preserve resources over reloads
local resources = {};

local gameobjects;

function addGameObject(obj)
    table.insert(gameobjects, obj);
end

function importResourceAnim(dbKey, fwidth, fheight)
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
            table.insert(localResource.frames, 
                love.graphics.newQuad(w*x, h*y, w, h, W, H)
            );
        end
    end

    resources[dbKey] = localResource;
end

function animRenderer(obj, options)
    local name = options.name;
    local framerate = options.framerate;
    return function()
        love.graphics.draw(resources[name].spritesheet, 
            resources[name].frames[math.floor(framerate*time) % 
            #resources[name].frames + 1], obj.x, obj.y
        );
    end
end

function setRenderer(obj, renderer, opt)
    obj.draw = renderer(obj, opt);
    return obj; -- for chaining
end

function Coin(x, y)
    local coin = {};
    coin.x = x;
    coin.y = y;

    coin.draw = animRenderer(coin, "coin", 12);

    coin.update = function()
    end

    return coin;
end

function love.load()

    -- Purple background
    love.graphics.setBackgroundColor(0.4196, 0.2078, 0.6314);

    time = 0;
    gameobjects = {};
 
    importResourceAnim("coin", 32, 32);

    addGameObject(setRenderer({x=140; y=150}, animRenderer, {name="coin"; framerate=12}));
    
    importResourceAnim("Mortimer-IDLE-BIG", 128, 128);
    importResourceAnim("Mortimer-WALK-BIG", 128, 128);

    mortimer = {x=20; y=100};
    mortimer.update = function (dt, time)
    end
    setRenderer(mortimer, animRenderer, {name="Mortimer-IDLE-BIG"; framerate=12});
    addGameObject(mortimer);

end

function love.update(dt)
    time = time + dt;
    for i=1,#gameobjects do
        if (gameobjects[i].update) then
            gameobjects[i].update(dt, time)
        end
    end
end

function love.draw()
    for i=1,#gameobjects do
        if (gameobjects[i].draw) then
            gameobjects[i].draw()
        end
    end
end
