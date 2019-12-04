--      author: Samy Bencherif
-- description: It's a science fiction type game (?)
--              This file contains game logic

local engine = require("engine");

local silkscreenPixelFont = love.graphics.newFont("fonts/slkscr.ttf", 20)

local dialogBox
local narrative = {
    "I hate my life...",
    "I hate you too...",
    "One time I killed a squirel, just to see how it\nwould feel."
}
local narrativeIndex = 1;

function love.load()

    -- Purple background
    love.graphics.setBackgroundColor(0.4196, 0.2078, 0.6314);

    engine.reset()
 
    engine.importSpritesheet("coin-gold", 32, 32);
    engine.importSpritesheet("minsky.obitx299", 84, 101);
    engine.importSpritesheet("book", 64, 64);
    engine.importSpritesheet("book-grounded", 64, 64);
    engine.importSpritesheet("shelf", 120, 150);
    engine.importSpritesheet("paragraph-block", 310, 50);

    -- Minsky
    engine.addGameObject(engine.setRenderer({x=340; y=40}, engine.animRenderer, {sprite="minsky.obitx299"; framerate=5}));
    
    -- Bookshelf
    engine.addGameObject(engine.setRenderer({x=80; y=71}, engine.animRenderer, {sprite="shelf"; framerate=0}));

    -- Falling Book
    local book = engine.setRenderer({x=140; y=245}, engine.animRenderer, {sprite="book"; framerate=12});
    book.update = function()
        if math.floor(12*engine.time) % 
        #engine.resources["book"].frames + 1 == 9 then
            engine.setRenderer(book, engine.animRenderer, {sprite="book-grounded"; framerate=0});
        end
    end
    engine.addGameObject(book);

    -- Dialog Box
    dialogBox = engine.setRenderer(
        {
            x=10; y=370; 
            text=narrative[narrativeIndex];
            charsVisible=0
        }, 
        engine.textRenderer, 
        {
            sprite="paragraph-block"; 
            framerate=0; 
            font=silkscreenPixelFont;
            textRate=1/2;
        }
    )

    engine.addGameObject(dialogBox);

end

function love.keypressed( key, scancode, isrepeat )
end

function love.mousepressed(x, y, button, istouch)
    narrativeIndex = narrativeIndex + 1
    dialogBox.text = narrative[narrativeIndex]
    dialogBox.charsVisible = 0
 end

love.update = engine.update
love.draw = engine.draw
