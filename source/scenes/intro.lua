-- @author: Samy Bencherif
-- @description: A black screen and some curious sounds

local engine = require('engine');
local assets = require("assets");

return {
    load = function()

        love.graphics.setBackgroundColor(0,0,0);

        engine.addGameObject(
            engine.setRenderer(
                {
                  playing = false;
                }, 
                engine.timedAudioRenderer, 
                {   
                    -- This is a 12 second audio clip
                    audio = "footsteps-gravel";
                    timeStart = 0;
                }
            )
        )

        engine.addGameObject(
            engine.setRenderer(
                {
                  playing = false;
                }, 
                engine.timedAudioRenderer, 
                {   
                    -- 4 second audio clip
                    audio = "window-break";
                    timeStart = 12;
                }
            )
        )

        engine.addGameObject(
            engine.setRenderer(
                {
                  playing = false;
                }, 
                engine.timedAudioRenderer, 
                {   
                    -- 5 second audio clip
                    audio = "footsteps-indoors";
                    timeStart = 12 + 4;
                }
            )
        );

        engine.addGameObject(
            engine.setRenderer(
                {
                  playing = false;
                }, 
                engine.timedAudioRenderer, 
                {   
                    -- 4 second audio clip
                    audio = "machine-whirring";
                    timeStart = 12 + 4 + 5;
                }
            )
        );

        engine.addGameObject(
            engine.setRenderer(
                {
                  playing = false;
                }, 
                engine.timedAudioRenderer, 
                {   
                    -- 4 second audio clip
                    audio = "ai-bootup";
                    timeStart = 12 + 4 + 5 + 4;
                }
            )
        );

    end
}