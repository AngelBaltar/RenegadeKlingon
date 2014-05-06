-- /* RenegadeKlingon - LÖVE2D GAME
--  * ControlsScreen.lua
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
require 'GameScreens/Screen'
require 'Utils/GameConfig'
require 'Utils/ButtonRead'

ControlsScreen = class('ControlsScreen', Screen)

local NONE_OPTION=0
local UP_OPTION=1
local DOWN_OPTION=2
local LEFT_OPTION=3
local RIGHT_OPTION=4
local FIRE_OPTION=5
local PAUSE_OPTION=6
local ENTER_OPTION=7
local ESCAPE_OPTION=8

local config=GameConfig.getInstance()

local _loadMenus=function(self)
  self._controlsMenu=Menu:new(love.graphics.getWidth()/4,love.graphics.getHeight()/4)
  self._controlsMenu:addItem("Up----->"..config:getKey(GameConfig.static.UP))
  self._controlsMenu:addItem("Down--->"..config:getKey(GameConfig.static.DOWN))
  self._controlsMenu:addItem("Left--->"..config:getKey(GameConfig.static.LEFT))
  self._controlsMenu:addItem("Right-->"..config:getKey(GameConfig.static.RIGHT))
  self._controlsMenu:addItem("Fire--->"..config:getKey(GameConfig.static.FIRE))
  self._controlsMenu:addItem("Pause-->"..config:getKey(GameConfig.static.PAUSE))
  self._controlsMenu:addItem("Enter-->"..config:getKey(GameConfig.static.ENTER))
  self._controlsMenu:addItem("Escape->"..config:getKey(GameConfig.static.ESCAPE))
  self._selectedOption=NONE_OPTION
end

function ControlsScreen:initialize()
  _loadMenus(self)
end 


function ControlsScreen:draw()

	if(self._selectedOption==NONE_OPTION) then
		self._controlsMenu:print()
	else
		love.graphics.print("Press the key...", love.graphics.getWidth()/4,love.graphics.getHeight()/4)
	end
end

function ControlsScreen:update(dt)
  if(self._selectedOption~=NONE_OPTION and ButtonRead.getInstance():isSomethingToRead()) then
    self:readPressed()
  end
  return
end

function ControlsScreen:readPressed()

  if(self._selectedOption==NONE_OPTION) then
      self._selectedOption=self._controlsMenu:readPressed()
      if self._selectedOption==Screen:getExitMark() then
        _loadMenus(self)
        return Screen:getExitMark()
      end

      return
  end
  local joypad,joypadbutton=ButtonRead.getInstance():getJoys()
  local key=ButtonRead.getInstance():getKey()
  local readed=false

  if (self._selectedOption==UP_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.UP,key)
        readed=true
      end
  elseif (self._selectedOption==DOWN_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.DOWN,key)
        readed=true
      end
  elseif (self._selectedOption==LEFT_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.LEFT,key)
        readed=true
      end
  elseif (self._selectedOption==RIGHT_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.RIGHT,key)
        readed=true
      end
  elseif (self._selectedOption==FIRE_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.FIRE,key)
        readed=true
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKey(GameConfig.static.FIRE,joypad, joypadbutton )
        readed=true
      end
  elseif (self._selectedOption==PAUSE_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.PAUSE,key)
        readed=true
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKey(GameConfig.static.PAUSE,joypad, joypadbutton )
        readed=true
      end
  elseif (self._selectedOption==ENTER_OPTION) then
      if(key~=nil) then
        config:setKey(GameConfig.static.ENTER,key)
        readed=true
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKey(GameConfig.static.ENTER,joypad, joypadbutton )
        readed=true
      end
  elseif (self._selectedOption==ESCAPE_OPTION) then
    if(key~=nil) then
        config:setKey(GameConfig.static.ESCAPE,key)
        readed=true
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKey(GameConfig.static.ESCAPE,joypad, joypadbutton )
        readed=true
      end
  end
   if(readed) then
      _loadMenus(self)
   end
   return 1

end