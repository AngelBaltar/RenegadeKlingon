require("Utils/Menu")
require("GameScreens/OptionsScreen")
require("GameScreens/Screen")
require("GameScreens/GameScreen")


local selected_option=0

local NONE_OPTION=0
local PLAY_OPTION=1
local OPTIONS_OPTION=2

function love.load()

   mainMenu=Menu:new(love.graphics.getWidth()/2-50,love.graphics.getHeight()/2-50)
   mainMenu:addItem("Play")
   mainMenu:addItem("Options")

   optionsMenu=OptionsScreen:new()
   
   play=GameScreen:new()

   local f = love.graphics.newFont("Resources/klingon_blade.ttf",35)
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
         if play:keypressed(key,unicode)==Screen:getExitMark() then
            selected_option=NONE_OPTION
         end
    end
end