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
  self._controlsMenu:addItem("Up----->"..config:getKeyUp())
  self._controlsMenu:addItem("Down--->"..config:getKeyDown())
  self._controlsMenu:addItem("Left--->"..config:getKeyLeft())
  self._controlsMenu:addItem("Right-->"..config:getKeyRight())
  self._controlsMenu:addItem("Fire--->"..config:getKeyFire())
  self._controlsMenu:addItem("Pause-->"..config:getKeyPause())
  self._controlsMenu:addItem("Enter-->"..config:getKeyEnter())
  self._controlsMenu:addItem("Escape->"..config:getKeyEscape())
  self._selectedOption=NONE_OPTION
end

function ControlsScreen:initialize()
  self._selectedOption=NONE_OPTION
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
  return 1
end

function ControlsScreen:readPressed()

  if(self._selectedOption==NONE_OPTION) then
      if config:isDownEscape() then
        return Screen:getExitMark()
      end
      self._selectedOption=self._controlsMenu:readPressed()
      return 1
  end
  
  local key=ButtonRead.getInstance():getKey()
  local joypad,joypadbutton=ButtonRead.getInstance():getJoys()

  if (self._selectedOption==UP_OPTION) then
      if(key~=nil) then
        config:setKeyUp(key)
      end
  elseif (self._selectedOption==DOWN_OPTION) then
      if(key~=nil) then
        config:setKeyDown(key)
      end
  elseif (self._selectedOption==LEFT_OPTION) then
      if(key~=nil) then
        config:setKeyLeft(key)
      end
  elseif (self._selectedOption==RIGHT_OPTION) then
      if(key~=nil) then
        config:setKeyRight(key)
      end
  elseif (self._selectedOption==FIRE_OPTION) then
      if(key~=nil) then
        config:setKeyFire(key)
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKeyFire(joypad, joypadbutton )
      end
  elseif (self._selectedOption==PAUSE_OPTION) then
      if(key~=nil) then
        config:setKeyPause(key)
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKeyPause(joypad, joypadbutton )
      end
  elseif (self._selectedOption==ENTER_OPTION) then
      if(key~=nil) then
        config:setKeyEnter(key)
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKeyEnter(joypad, joypadbutton )
      end
  elseif (self._selectedOption==ESCAPE_OPTION) then
    if(key~=nil) then
        config:setKeyEscape(key)
      end
      if(joypad~=nil and joypadbutton~=nil) then
        config:setKeyEscape(joypad, joypadbutton )
      end
  end
   _loadMenus(self)
   return 1

end