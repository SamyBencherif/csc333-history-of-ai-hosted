-- @author: Samy Bencherif
-- @description: Dartmouth Scene Part 2

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
        engine.addGameObject({x=0; y=0; sprite="dartmouth-conference"; framerate=0}, engine.animatedSprite)
        engine.quickDialog("source/text/scene4.txt", "scenes/perceptrons")
    end
}