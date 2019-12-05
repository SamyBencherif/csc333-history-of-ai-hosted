-- @author: Samy Bencherif
-- @description: It's a deep exploration of history of AI and a fantastical one at that
-- @technical: main.lua is the love2d entry point

-- this "engine" is not part of the love2d framework, it contains high level architectural features
local engine = require("engine");

-- import listing of game files
local assets = require("assets");

-- Loads game files into memory, only call it once
assets.init();

-- called at game start
function love.load()

    -- bring intro scene from filesystem to memory
    local intro = require("scenes/intro")

    -- set it as the active scene
    engine.loadScene(intro)
end

-- delegate love2d's mainloops to the engine
love.update = engine.update
love.draw = engine.draw