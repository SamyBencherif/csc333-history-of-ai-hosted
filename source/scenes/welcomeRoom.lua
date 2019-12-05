-- @author: Samy Bencherif
-- @description: Good Ole Minsky Painting and Library

-- Notes:
-- This "intro" scene will be replaced with the black screen with sounds
-- The room with minksy will be made the 2nd or 3rd scene.

local engine = require('engine');
local assets = require("assets");
local gameio = require("gameio");

local tv;
local mccarthy;
local dialogBox;


return {

    load = function()

        -- Skip all welcome room intro
        engine.time = 5 + 8 + 4;

        -- Purple background
        engine.addGameObject({color={0.4196, 0.2078, 0.6314, 1}}, engine.backdrop)

        -- mccarthy
        engine.addGameObject({x=340; y=40; w=240, h=180, color={0,0,0,1}}, engine.block)
        tv = engine.addGameObject({x=340; y=40; w=240, h=180, color={.1, .3, .8, .1}}, engine.block)
        mccarthy = engine.addGameObject({x=340; y=40; sprite="mccarthy"; framerate=0}, engine.animatedSprite)

        -- Bookshelf
        engine.addGameObject({x=80; y=71; sprite="shelf"; framerate=0}, engine.animatedSprite);

        -- Falling Book
        local book = {x=140; y=245; sprite="book"; framerate=0};
        -- engine.addGameObject(book, engine.animatedSprite, function()
        --     if math.floor(12*engine.time) % 
        --     #engine.resources["book"].frames + 1 == 9 then
        --         book.sprite = "book-grounded";
        --         book.framerate = 0;
        --     end
        -- end)

        -- VISUAL CHOREGRAPHY

        -- scene start: room dark, mccarthy hidden
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    engine.tint = {1,1,1,.1}
                    mccarthy.color = {1,1,1,0}
                end;
                activationTime = 0;
            }, nil, engine.deferredAgent
        )

        -- when ai-bootup plays, light up mccarthy
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    mccarthy.color = {1,1,1,1}
                    tv.color = {.1, .3, .8, 1};
                end;
                activationTime = 5 + 8 + 4;
            }, nil, engine.deferredAgent
        )

        -- when light switch goes on, turn on lights
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    engine.tint = {1,1,1,1};
                end;
                activationTime = 5 + .6;
            }, nil, engine.deferredAgent
        )

        -- when ai-bootup plays, show dialogBox
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    engine.quickDialog("source/text/scene1.txt", "scenes/dartmouth")
                end;
                activationTime = 5 + 8 + 4;
            }, nil, engine.deferredAgent
        )

        -- SOUND CHOREGRAPHY

        -- This is a 5 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "footsteps-indoors";
                timeStart = 0;
            }, nil, engine.timedAudioSource
        )

        -- This is a 8 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "light-on";
                timeStart = 5;
            }, nil, engine.timedAudioSource
        )

        -- This is a 4 second audio clip
        engine.addGameObject(
            {
                playing = false;
                audio = "machine-whirring";
                timeStart = 5 + 8;
            }, nil, engine.timedAudioSource
        )

        --  This is a 4 second audio clip
         engine.addGameObject(
            {
                playing = false;
                audio = "ai-bootup";
                timeStart = 5 + 8 + 4;
            }, nil, engine.timedAudioSource
        )

    end;
}