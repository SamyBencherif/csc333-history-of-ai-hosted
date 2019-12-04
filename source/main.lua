--      author: Samy Bencherif
-- description: It's a science fiction type game (?)
--              This file contains game logic

local engine = require("engine");

local mortimer

function love.load()

    -- Purple background
    love.graphics.setBackgroundColor(0.4196, 0.2078, 0.6314);

    engine.reset()
 
    engine.importSpritesheet("coin-gold", 32, 32);
    engine.importSpritesheet("minsky.obitx299", 84, 101);
    engine.importSpritesheet("book", 64, 64);
    engine.importSpritesheet("book-grounded", 64, 64);
    engine.importSpritesheet("shelf", 120, 150);

    -- Create an object that looks like a coin at location < 140, 150 >
    engine.addGameObject(engine.setRenderer({x=340; y=150}, engine.animRenderer, {name="minsky.obitx299"; framerate=5}));
    engine.addGameObject(engine.setRenderer({x=80; y=180}, engine.animRenderer, {name="shelf"; framerate=0}));

    local book = engine.setRenderer({x=140; y=355}, engine.animRenderer, {name="book"; framerate=12});
    
    book.update = function()
        if math.floor(12*engine.time) % 
        #engine.resources["book"].frames + 1 == 9 then
            engine.setRenderer(book, engine.animRenderer, {name="book-grounded"; framerate=0});
        end
    end

    engine.addGameObject(book);
end

function love.keypressed( key, scancode, isrepeat )
    if scancode == "right" then
        -- mortimer.x = mortimer.x + 10;
    end
end

love.update = engine.update
love.draw = engine.draw
