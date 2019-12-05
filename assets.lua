-- @author: Samy Bencherif
-- @description: Contains listing of game files

local engine = require("engine");

function init()
    -- Initialized here to preserve resources over reloads
    engine.resources = {};

    engine.importSpritesheet("coin-gold", 32, 32);

    engine.importSpritesheet("minsky", 84, 101);
    engine.importSpritesheet("mccarthy", 120, 90);

    engine.importSpritesheet("book", 64, 64);
    engine.importSpritesheet("book-grounded", 64, 64);
    engine.importSpritesheet("shelf", 120, 150);
    engine.importSpritesheet("paragraph-block", 310, 50);

    engine.importAudio("footsteps-gravel")
    engine.importAudio("window-break")
    engine.importAudio("footsteps-indoors")
    engine.importAudio("light-on")
    engine.importAudio("machine-whirring")
    engine.importAudio("ai-bootup")
end

return {
    joystixPixelFont = love.graphics.newFont("fonts/joystix-mono.ttf", 18);
    joystixPixelFontLarge = love.graphics.newFont("fonts/joystix-mono.ttf", 40);

    silkscreenPixelFont = love.graphics.newFont("fonts/slkscr.ttf", 20);
    silkscreenPixelFontLarge = love.graphics.newFont("fonts/slkscr.ttf", 40);
    init = init;
};