-- @author: Samy Bencherif
-- @description: Perceptrons Scene

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
        engine.addGameObject({x=0; y=0; sprite="perceptrons"; framerate=0}, engine.animatedSprite)
        engine.quickDialog("source/text/scene5.txt", "scenes/goodbyeRoom")
    end
}