-- @author: Samy Bencherif
-- @description: A black screen and some curious sounds

local engine = require('engine');
local assets = require("assets");

return {
    load = function()

        -- INTRO TEXT CHOREOGRAPHY

        local title = engine.addGameObject(
            {
                text = "The History of AI";
                color = {1,1,1,1};
                font = assets.silkscreenPixelFontLarge;
                x = 100;
                y = 200;
            }, engine.staticText
        )

        engine.addGameObject(
            {
                activationTime = 2;
                action = function()
                    -- Make title invisible
                    title.color[4] = 0;
                end
            },
            nil, engine.deferredAgent
        )

        local subtitle = engine.addGameObject(
            {
                text = "~ An Interactive Adventure ~";
                color = {1,1,1,0};
                font = assets.silkscreenPixelFont;
                x = 100;
                y = 200;
            }, engine.staticText
        )

        engine.addGameObject(
            {
                activationTime = 4;
                action = function()
                    -- Make subtitle visible
                    subtitle.color[4] = 1;
                end
            },
            nil, engine.deferredAgent
        )

        local subtitle2 = engine.addGameObject(
            {
                text = "Presented to you by";
                color = {1,1,1,0};
                font = assets.silkscreenPixelFont;
                x = 100;
                y = 200;
            }, engine.staticText
        )

        engine.addGameObject(
            {
                activationTime = 6;
                action = function()
                    -- Make subtitle invisible
                    subtitle.color[4] = 0;
                end
            },
            nil, engine.deferredAgent
        )

        engine.addGameObject(
            {
                activationTime = 8;
                action = function()
                    -- Make subtitle2 visible
                    subtitle2.color[4] = 1;
                end
            },
            nil, engine.deferredAgent
        )

        local samy = engine.addGameObject(
            {
                text = "Samy Bencherif,";
                color = {1,1,1,0};
                font = assets.silkscreenPixelFont;
                x = 100;
                y = 240;
            }, engine.staticText
        )

        local gage = engine.addGameObject(
            {
                text = "Gage Miller,";
                color = {1,1,1,0};
                font = assets.silkscreenPixelFont;
                x = 100;
                y = 260;
            }, engine.staticText
        )

        local casey = engine.addGameObject(
            {
                text = "& Casey Belcher";
                color = {1,1,1,0};
                font = assets.silkscreenPixelFont;
                x = 100;
                y = 280;
            }, engine.staticText
        )

        engine.addGameObject(
            {
                activationTime = 9;
                action = function()
                    -- Make my name visible
                    samy.color[4] = 1;
                end
            },
            nil, engine.deferredAgent
        )

        engine.addGameObject(
            {
                activationTime = 10;
                action = function()
                    -- Make Gage's name visible
                    gage.color[4] = 1;
                end
            },
            nil, engine.deferredAgent
        )

        engine.addGameObject(
            {
                activationTime = 11;
                action = function()
                    -- Make Casey's name visible
                    casey.color[4] = 1;
                end
            },
            nil, engine.deferredAgent
        )

        engine.addGameObject(
            {
                activationTime = 12;
                action = function()
                    -- Hide all names & subtitle2
                    subtitle2.color[4] = 0;
                    samy.color[4] = 0;
                    gage.color[4] = 0;
                    casey.color[4] = 0;
                end
            },
            nil, engine.deferredAgent
        )

        -- SOUND CHOREOGRAPHY

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

        -- This is a 8 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "light-on";
                timeStart = 12 + 4 + 5;
            }, nil, engine.timedAudioSource
        )

        -- This is a 4 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "machine-whirring";
                timeStart = 12 + 4 + 5 + 8;
            }, nil, engine.timedAudioSource
        )

        --  This is a 4 second audio clip
         engine.addGameObject(
            {
                playing = false;
                audio = "ai-bootup";
                timeStart = 12 + 4 + 5 + 8 + 4;
            }, nil, engine.timedAudioSource
        )

        -- when glass breaks, present dark room
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    local welcomeRoom = require("scenes/welcomeRoom");
                    engine.loadScene(welcomeRoom);
                    engine.tint = {1,1,1,.1};
                end;
                activationTime = 12 + 4;
            }, nil, engine.deferredAgent
        )

        -- when light switch goes on, turn on lights
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    engine.tint = {1,1,1,1};
                end;
                activationTime = 12 + 4 + 5 + .6;
            }, nil, engine.deferredAgent
        )

    end
}