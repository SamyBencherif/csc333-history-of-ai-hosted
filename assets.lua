-- @author: Samy Bencherif
-- @description: Contains listing of game files

local engine = require("engine");

function init()
    -- Initialized here to preserve resources over reloads
    engine.resources = {};

    engine.importSpritesheet("coin-gold", 32, 32);
    engine.importSpritesheet("minsky.obitx299", 84, 101);
    engine.importSpritesheet("book", 64, 64);
    engine.importSpritesheet("book-grounded", 64, 64);
    engine.importSpritesheet("shelf", 120, 150);
    engine.importSpritesheet("paragraph-block", 310, 50);
end

return {
    silkscreenPixelFont = love.graphics.newFont("fonts/slkscr.ttf", 20);
    init = init
};