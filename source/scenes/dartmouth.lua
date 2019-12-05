-- @author: Samy Bencherif
-- @description: Dartmouth Conference Scene

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
        engine.addGameObject({x=0; y=0; sprite="dartmouth-conference"; framerate=0}, engine.animatedSprite)
    end
}