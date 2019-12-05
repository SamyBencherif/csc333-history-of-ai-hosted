-- @author: Samy Bencherif
-- @description: Good Ole Minsky Painting and Library

-- Notes:
-- This "intro" scene will be replaced with the black screen with sounds
-- The room with minksy will be made the 2nd or 3rd scene.

local engine = require('engine');
local assets = require("assets");

local narrative = {
    "This is the first line of text.",
    "This is the second line of text.",
    "This is the third line of text.",
    "Go fuck yourself ;)",
    "Eat ass",
    "Fin.",
};

local tv;
local mccarthy;
local narrativeIndex = 1;
local dialogBox;


return {

    load = function()
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

        -- Dialog Box
        -- 

        -- when light switch goes on, keep mccarthy dark
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    mccarthy.color = {1,1,1,0}
                end;
                activationTime = 12 + 4;
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
                activationTime = 12 + 4 + 5 + 8 + 4;
            }, nil, engine.deferredAgent
        )

        -- when ai-bootup plays, show dialogBox
        engine.addGameObject(
            {
                finished = false;
                action = function()
                    dialogBox = engine.addGameObject(
                        {
                            x=10; y=370; 
                            text=narrative[narrativeIndex];
                            charsVisible=0;
                            sprite="paragraph-block"; 
                            framerate=0; 
                            font=assets.silkscreenPixelFont;
                            textRate=1/2;
                        }, engine.animatedText
                    )
                end;
                activationTime = 12 + 4 + 5 + 8 + 4;
            }, nil, engine.deferredAgent
        )
    end;

    mousepressed = function(x, y, button, istouch)
        if narrativeIndex < #narrative and dialogBox then
            narrativeIndex = narrativeIndex + 1;
            dialogBox.text = narrative[narrativeIndex];
            dialogBox.charsVisible = 0;
        end
    end

}