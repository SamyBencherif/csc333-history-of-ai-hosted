-- @author: Samy Bencherif
-- @technical: Love2D configuration file

function love.conf(t)
    
    -- Window size
    t.window.width = 640;
    t.window.height = 480;

    -- Game title
    t.window.title = "Superbulous Adventures in Historical AI";

    t.window.fullscreen = false;   

    -- Allows printing to console (https://love2d.org/forums/viewtopic.php?t=79579)
    t.console = true;
end
