-- @author: Samy Bencherif
-- @description: CREDITS

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()

        engine.addGameObject(
            {
                playing = false;
                audio = "window-break";
                timeStart = 0;
            }, nil, engine.timedAudioSource
        )

        engine.addGameObject({color={0.6, 0.078, 0.314, 1}}, engine.backdrop)

        engine.addGameObject({}).mousepressed = function()
            engine.loadScene(require('scenes/intro'), true)   
        end

        local title = engine.addGameObject(
            {
                text = "Thanks for Playing!";
                color = {1,1,1,1};
                font = assets.silkscreenPixelFontLarge;
                x = 100;
                y = 200;
            }, engine.staticText
        )
    end
}