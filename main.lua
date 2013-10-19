require('Utils/Debugging')
require("Utils/Menu")
require("GameScreens/OptionsScreen")
require("GameScreens/Screen")
require("GameScreens/GameScreen")
require("Utils/GameConfig")
require("Utils/ButtonRead")

local selected_option=0
local config=GameConfig.getInstance()
local button_read=ButtonRead.getInstance()if player~=nil and pos_x<player:getPositionX() then
    self._directionX=self._directionX*-2
end
local main_self=nil


local NONE_OPTION=0
local PLAY_OPTION=1
local OPTIONS_OPTION=2

MainScreen = class('MainScreen',Screen)

function MainScreen:initialize()
  Screen.initialize(self)
  main_self=self
end 

function love.load()
   DEBUG_PRINT("LOADING GAME...")

   mainMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2-50)
   mainMenu:addItem("Play")
   mainMenu:addItem("Options")  
   image=love.graphics.newImage("Resources/gfx/kelogo.jpg")
   optionsMenu=OptionsScreen:new()
   
   local scr_main=MainScreen:new()

   play=GameScreen:new()

   local f = love.graphics.newFont("Resources/fonts/klingon_blade.ttf",35)
   love.graphics.setFont(f)
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.setBackgroundColor(0,0,0)

   love.keyboard.setKeyRepeat(0.2, 0.1)
end

function MainScreen:update(dt)
  Screen.update(self,dt)
  -- make it work with joypad too using update to get joypad axis buttons
end

function love.update(dt)
   
    if(selected_option==PLAY_OPTION) then
       if play:update(dt)==Screen:getExitMark() then
            selected_option=NONE_OPTION
        end
    end
    if(selected_option==OPTIONS_OPTION) then
          optionsMenu:update(dt)
    end
    MainScreen.update(main_self,dt)
end

function love.draw()
  
    if(selected_option==NONE_OPTION) then
        mainMenu:print()
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(image, 0, 0)
    end
    if(selected_option==PLAY_OPTION) then
        play:draw()
    end
    if(selected_option==OPTIONS_OPTION) then
        optionsMenu:draw()
    end
end

function MainScreen:readPressed()

     if(selected_option==NONE_OPTION) then
        if(config:isDownEscape()) then
          love.event.push("quit")   -- actually causes the app to quit
        end
        selected_option=mainMenu:readPressed()
        if(selected_option==PLAY_OPTION) then
            --create new instance of the game
            play=GameScreen:new()
        end
    else
        if(selected_option==PLAY_OPTION) then
             if play:readPressed()==Screen:getExitMark() then
                selected_option=NONE_OPTION
             end
        else
           if(selected_option==OPTIONS_OPTION) then
              if optionsMenu:readPressed()==Screen:getExitMark() then
                  selected_option=NONE_OPTION
              end
          end
        end
    end
end

function love.joystickpressed( joystick, button )
   button_read:setJoyButton(joystick, button)
   main_self:readPressed()
end

function love.keypressed(key, unicode)

    if(key=='o') then
      if getDebug() then
        disableDebug()
      else
        enableDebug()
      end
    end
    button_read:setKey(key,unicode)
    main_self:readPressed()
end