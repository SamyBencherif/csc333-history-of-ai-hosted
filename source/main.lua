--      author: Samy Bencherif
-- description: It's a deep exploration of history of AI and a fantastical one at that
--              This file contains game logic

local engine = require("engine");
local assets = require("assets");

-- Loads game files into memory, only call it once
assets.init();

local scenes = {
    intro = require("scenes/intro")
}

function love.load()
    engine.loadScene(scenes.intro)
end

love.update = engine.update
love.draw = engine.draw