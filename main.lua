require("Menu")
require("OptionsScreen")
require("Screen")
require("GameScreen")


function love.load()

   selected_option=0

   NONE_OPTION=0
   PLAY_OPTION=1
   OPTIONS_OPTION=2

   mainMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
   mainMenu:addItem("Play")
   mainMenu:addItem("Options")

   optionsMenu=OptionsScreen:new()
   
   play=GameScreen:new()

   local f = love.graphics.newFont("Resources/klingon_font.ttf",35)
   love.graphics.setFont(f)
   love.graphics.setColor(255,0,0,255)
   love.graphics.setBackgroundColor(0,0,0)

   love.keyboard.setKeyRepeat(0.03, 0.07)
end


function love.update(dt)
   
   if(selected_option==NONE_OPTION) then
    selected_option=mainMenu:read()
   end
    if(selected_option==PLAY_OPTION) then
       if play:update(dt)==Screen:getExitMark() then
            selected_option=NONE_OPTION
        end
    end
     if(selected_option==OPTIONS_OPTION) then
        if optionsMenu:update()==Screen:getExitMark() then
            selected_option=NONE_OPTION
        end
    end
end

function love.draw()
  
    if(selected_option==NONE_OPTION) then
        mainMenu:print()
    end
    if(selected_option==PLAY_OPTION) then
        play:draw()
    end
    if(selected_option==OPTIONS_OPTION) then
        optionsMenu:draw()
    end
end

function love.keypressed(key, unicode)
    if(selected_option==PLAY_OPTION) then
        play:keypressed(key,unicode)
    end
end