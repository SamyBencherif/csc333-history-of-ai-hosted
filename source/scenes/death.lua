-- @author: Samy Bencherif
-- @description: DEATH

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
        engine.addGameObject({color={1,0,0, 1}}, engine.backdrop)

        engine.addGameObject({}).mousepressed = function()
            engine.loadScene(require('scenes/intro'), true)   
        end

        local title = engine.addGameObject(
            {
                text = "YOU HAVE SMIGHTED\nBY McCARTHY\n\nGAME OVER";
                color = {1,.8,.8,1};
                font = assets.silkscreenPixelFontLarge;
                x = 100;
                y = 200;
            }, engine.staticText
        )
    end
}