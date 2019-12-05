-- @author: Samy Bencherif
-- @description: Dartmouth Conference Scene

local engine = require('engine');
local assets = require("assets");

return {
    load = function ()
         -- Purple background
         engine.addGameObject({color={0.4196, 0.2078, 0.6314, 1}}, engine.backdrop)

         -- mccarthy
         engine.addGameObject({x=310; y=10; sprite="cybernetic-picture-frame"; framerate=12}, engine.animatedSprite)
         engine.addGameObject({x=340; y=40; w=240, h=180, color={0,0,0,1}}, engine.block)
         tv = engine.addGameObject({x=340; y=40; w=240, h=180, color={.1, .3, .8, .1}}, engine.block)
         mccarthy = engine.addGameObject({x=340; y=40; sprite="mccarthy"; framerate=0}, engine.animatedSprite)
 
         -- Bookshelf
         engine.addGameObject({x=80; y=71; sprite="shelf"; framerate=0}, engine.animatedSprite);
 
         -- Falling Book
         local book = {x=140; y=245; sprite="book"; framerate=0};
         engine.addGameObject(book, engine.animatedSprite, function()
             if math.floor(12*engine.time) % 
             #engine.resources["book"].frames + 1 == 9 then
                 book.sprite = "book-grounded";
                 book.framerate = 0;
             end
         end)

        --engine.addGameObject({x=0; y=0; sprite=""; framerate=0}, engine.animatedSprite)
        engine.quickDialog("source/text/scene6.txt", "scenes/credits")
    end
}