-- @author: Samy Bencherif
-- @description: A black screen and some curious sounds

local engine = require('engine');
local assets = require("assets");

return {
    load = function()
        -- This is a 12 second audio clip
        local title = engine.addGameObject(
            {
                text = "The History of AI";
                color = {1,1,1};
                font = assets.silkscreenPixelFontLarge;
                x = 100;
                y = 200;
            }, engine.staticText
        )

        engine.addGameObject(
            {
                activationTime = 3;
                action = function()
                    title = nil
                end
            },
            nil, engine.deferredAgent
        )

        -- This is a 12 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "footsteps-gravel";
                timeStart = 0;
            }, nil, engine.timedAudioSource
        )

        -- This is a 4 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "window-break";
                timeStart = 12;
            }, nil, engine.timedAudioSource
        )

        -- This is a 5 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "footsteps-indoors";
                timeStart = 12 + 4;
            }, nil, engine.timedAudioSource
        )

        -- This is a 4 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "machine-whirring";
                timeStart = 12 + 4 + 5;
            }, nil, engine.timedAudioSource
        )

         -- This is a 4 second audio clip
         engine.addGameObject(
            {
                playing = false;
                audio = "ai-bootup";
                timeStart = 12 + 4 + 5 + 4;
            }, nil, engine.timedAudioSource
        )

        
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    local welcomeRoom = require("scenes/welcomeRoom")
                    engine.loadScene(welcomeRoom)
                end;
                activationTime = 12 + 4 + 5 + 4 + 4;
            }, nil, engine.deferredAgent
        )

    end
}