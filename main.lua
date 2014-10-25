-- /* RenegadeKlingon - LÖVE2D GAME
--  * main.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */
require('Utils/Debugging')
require("Utils/Menu")
require("GameScreens/OptionsScreen")
require("GameScreens/Screen")
require("GameScreens/GameScreen")
require("Utils/GameConfig")
require("Utils/ButtonRead")

local selected_option=0
local time_inactive=0
local inactivity_to_autoplay=10
local config=GameConfig.getInstance()
local button_read=ButtonRead.getInstance()
local main_self=nil


local NONE_OPTION=0
local PLAY_OPTION=1
local OPTIONS_OPTION=2

MainScreen = class('MainScreen',Screen)

function MainScreen:initialize(timeout)
  Screen.initialize(self)
  main_self=self
  self._timeout=timeout
  self._apply_timeout=(timeout~=nil)
  --DEBUG_PRINT("eeee "..timeout)
end 

function love.errhand(msg)
  print(msg)
  love.event.push("quit")   -- actually causes the app to quit
end

function love.load(args)
   DEBUG_PRINT("LOADING GAME...")
   disableDebug()
   local settimeout=false
   local timeout=0
   for a,e in pairs(args) do
     if settimeout then
        timeout=tonumber(e)
        settimeout=false
     end
     if e=="--debug" then
        enableDebug()
     end
     if e=="--timeout" then
        settimeout=true
     end
   end
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.setBackgroundColor(0,0,0)

   love.keyboard.setKeyRepeat(0.0002, 0.0001)
   love.mouse.setVisible(false)
   modes = love.window.getFullscreenModes()
   table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end) 
   -- sort from largest to smallest
   love.window.setMode(modes[1].width, modes[1].height,
         {resizable=false, vsync=true, minwidth=800, minheight=600,fullscreen = true})
   

   config:setScale(love.graphics.getWidth()/800,love.graphics.getHeight()/600)
   local sx,sy=config:getScale()
   local f = love.graphics.newFont("Resources/fonts/klingon_blade.ttf",30*sx)
   love.graphics.setFont(f)
   --print(modes[1].width.."x"..modes[1].height)
   sx,sy=config:getScale()
   image=love.graphics.newImage("Resources/gfx/kelogo.jpg")
   mainMenu=Menu:new(image:getWidth()*sx+4*sx,image:getHeight()/2-50*sy)
   mainMenu:addItem("Play")
   mainMenu:addItem("Options")  
   optionsMenu=OptionsScreen:new()
   local scr_main=nil

   if timeout>0 then
      scr_main=MainScreen:new(timeout)
   else
      scr_main=MainScreen:new()
   end
   play=nil
   --kk=pp+1
  
end

function MainScreen:update(dt)
  Screen.update(self,dt)
  -- make it work with joypad too using update to get joypad axis buttons
   if self._apply_timeout then
      self._timeout=self._timeout-dt
      if(self._timeout<=0) then
        love.event.push("quit")
      end
   end
   if(selected_option==PLAY_OPTION) then
       if play:update(dt)==Screen:getExitMark() then
            selected_option=NONE_OPTION
        end
        return
    end
    if(selected_option==OPTIONS_OPTION) then
          optionsMenu:update(dt)
          return
    end
    time_inactive=time_inactive+dt
    if play==nil and time_inactive>inactivity_to_autoplay then
      selected_option=PLAY_OPTION
      play=GameScreen:new(true)
    end

end

function love.update(dt)
   
    MainScreen.update(main_self,dt)

end

function love.draw()
  
    if(selected_option==NONE_OPTION) then
        mainMenu:print()
        love.graphics.setColor(255,255,255,255)
        sx,sy=config:getScale()
        love.graphics.draw(image, 0, 0,0,sx,sy)
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
        if(config:isDown(GameConfig.static.ESCAPE)) then
          love.event.push("quit")   -- actually causes the app to quit
        end
        selected_option=mainMenu:readPressed()
        if(selected_option==PLAY_OPTION) then
            --create new instance of the game
            play=GameScreen:new(false)
        end
    else
        if(selected_option==PLAY_OPTION) then
             if play:readPressed()==Screen:getExitMark() then
                selected_option=NONE_OPTION
                play=nil
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
   time_inactive=0
   button_read:setJoyButton(joystick, button)
   --DEBUG_PRINT("joy pressed")
end

function love.keypressed(key, unicode)
    time_inactive=0
    if(key=='o') then
      if getDebug() then
        disableDebug()
      else
        enableDebug()
      end
    end
    button_read:setKey(key,unicode)
    --DEBUG_PRINT("key pressed "..key)
end