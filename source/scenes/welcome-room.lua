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
local narrativeIndex = 1;
local dialogBox;

return {

    load = function()
        -- Purple background
        love.graphics.setBackgroundColor(0.4196, 0.2078, 0.6314);
    
        -- Minsky
        engine.addGameObject(engine.setRenderer({x=340; y=40}, engine.animRenderer, {sprite="minsky.obitx299"; framerate=5}));
        --engine.addGameObject(engine.animatedSprite({x=340; y=40; sprite="minsky.obitx299"; framerate=5}))


        -- Bookshelf
        engine.addGameObject(engine.setRenderer({x=80; y=71}, engine.animRenderer, {sprite="shelf"; framerate=0}));

        -- Falling Book
        local book = engine.setRenderer({x=140; y=245}, engine.animRenderer, {sprite="book"; framerate=12});
        book.update = function()
            if math.floor(12*engine.time) % 
            #engine.resources["book"].frames + 1 == 9 then
                engine.setRenderer(book, engine.animRenderer, {sprite="book-grounded"; framerate=0});
            end
        end
        engine.addGameObject(book);

        -- Dialog Box
        dialogBox = engine.setRenderer(
            {
                x=10; y=370; 
                text=narrative[narrativeIndex];
                charsVisible=0
            }, 
            engine.textRenderer, 
            {
                sprite="paragraph-block"; 
                framerate=0; 
                font=assets.silkscreenPixelFont;
                textRate=1/2;
            }
        )

        engine.addGameObject(dialogBox);
    end;

    mousepressed = function(x, y, button, istouch)
        if narrativeIndex < #narrative then
            narrativeIndex = narrativeIndex + 1
            dialogBox.text = narrative[narrativeIndex]
            dialogBox.charsVisible = 0
        end
    end

}