-- @author: Samy Bencherif
-- @description: RAND Santa Monica Scene

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
        engine.pip = nil
        engine.addGameObject({x=0; y=0; sprite="rand-comp"; framerate=0}, engine.animatedSprite)
        engine.quickDialog("source/text/scene3.txt", "scenes/dartmouth2")
    end
}