-- /* RenegadeKlingon - LÖVE2D GAME
--  * GameConfig.lua
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

require 'Utils/Debugging'
require 'Utils/ButtonRead'
require 'Utils/ConfigPropertie'

GameConfig = class('GameFrameWork.GameConfig')

GameConfig.static.NONE = 0
GameConfig.static.UP = 1
GameConfig.static.DOWN = 2
GameConfig.static.LEFT = 3
GameConfig.static.RIGHT = 4
GameConfig.static.FIRE = 5
GameConfig.static.POWER = 6
GameConfig.static.PAUSE = 7
GameConfig.static.ENTER = 8
GameConfig.static.ESCAPE = 9

GameConfig.static.VERSION_NUMBER="0.0.1 beta"

GameConfig.static.PC="PC"
GameConfig.static.ANDROID="ANDROID"

local JOY_FIRE = 10
local JOY_POWER = 11
local JOY_PAUSE = 12
local JOY_ENTER = 13
local JOY_ESCAPE = 14

local MAX_DIRECTION=GameConfig.static.RIGHT
local KEY_JOY_CONVERSION=5

local _instance=nil
local button_read=ButtonRead.getInstance()


local _readConfigFile=function(self)

	local props=ConfigPropertie:new("RenegadeKlingon.conf")
	if props:getPropTab()==nil then
		props=ConfigPropertie:new("RenegadeKlingon.conf")
	end
	for key,value in props:getIterator() do
		self[key]=value
	end

end

local __initializeBasics=function(self)
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyRight="right"
	self._keyFire="a"
	self._keyPower="s"
	self._keyPause="p"
	self._keyEnter="return"
	self._keyEscape="escape"

	self._joyFire_button=-1
	self._joyPower_button=-1
	self._joyPause_button=-1
	self._joyEnter_button=-1
	self._joyEscape_button=-1

	self._version_number=GameConfig.static.VERSION_NUMBER
	self._target_machine=GameConfig.static.PC
end

--constructor
local __initialize = function(self)

	

	--NOTE THIS PROPERTIES NEED TO BE ALIGNED WITH GameConfig.static. constants
	self._properties_ordered={
								"_keyUp",
								"_keyDown",
								"_keyLeft",
								"_keyRight",
								"_keyFire",
								"_keyPower",
								"_keyPause",
								"_keyEnter",
								"_keyEscape",
								
								"_joyFire_button",
								"_joyPower_button",
								"_joyPause_button",
								"_joyEnter_button",
								"_joyEscape_button",

								"_version_number",
								"_target_machine"
								nil
							}

	_readConfigFile(self)
	--different version so remove the file
	if self._version_number~=GameConfig.static.VERSION_NUMBER then
		__initializeBasics(self)
		love.filesystem.remove("RenegadeKlingon.conf")
	end
	name =nil
	self._activepad=nil
	local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        self._activepad=joystick
        name=joystick:getName()
        break
    end

end

local _writeConfigFile=function(self)
	local props=ConfigPropertie:new()
	for key,value in pairs(self._properties_ordered) do
		props:setProp(value,self[value])
	end
	props:setPath("RenegadeKlingon.conf")
	props:save()
end

--return the width of this ship
function GameConfig.getInstance()
  if _instance==nil then
  	_instance=GameConfig:new()
  	__initialize(_instance)
  end
  return _instance
end

--sets the key or joy button for the action
function GameConfig:setKey(action,key,button)
	if(action<=MAX_DIRECTION) then
		self[self._properties_ordered[action]]=key
	else
		if(button==nil) then
			self[self._properties_ordered[action]]=key
		else
			self[self._properties_ordered[action+KEY_JOY_CONVERSION]]=button
		end
	end
	_writeConfigFile(self)
end

--gets the description of the key to perform the action passed
function GameConfig:getKey(action)
	local key=self[self._properties_ordered[action]]
	local joy=self[self._properties_ordered[action+KEY_JOY_CONVERSION]]
	
	if(action<=MAX_DIRECTION) then
		return key
	else
		ret=key

		if(self._activepad~=nil and joy~=-1) then
			name = self._activepad:getName(joy)
			if(name~=nil) then
				ret=ret.." OR "..name.." B"..joy
			end
		end

		return ret
	end
end

--gets the active joypad
function GameConfig:getActiveJoyPad()
	return self._activepad
end

--true if the action passed by argument is down right now
function GameConfig:isDown(action)
	local key=self[self._properties_ordered[action]]
	local joy=self[self._properties_ordered[action+KEY_JOY_CONVERSION]]
	local direction=0
	local to_check_dir=math.pow(-1,action)
	
	if(action<=MAX_DIRECTION) then
		if(action<=GameConfig.static.DOWN) then
			axe=2 --up and down axis
		else
			axe=1 --left and right axis
		end
		if(self._activepad~=nil) then
			direction=self._activepad:getAxis(axe)
		end
		return direction==to_check_dir or love.keyboard.isDown(key)
	else
		return love.keyboard.isDown(key)
				or (self._activepad~=nil
					and self._activepad:isDown(joy))
	end
end

--true if something is pressed at the moment
function GameConfig:isDownAnyThing()
	return self:isDown(GameConfig.static.UP) 	 or
         	self:isDown(GameConfig.static.DOWN)  or
         	self:isDown(GameConfig.static.LEFT) or
         	self:isDown(GameConfig.static.RIGHT)  or
         	self:isDown(GameConfig.static.FIRE)  or
         	self:isDown(GameConfig.static.POWER)  or
         	self:isDown(GameConfig.static.PAUSE) or
         	self:isDown(GameConfig.static.ENTER) or
         	self:isDown(GameConfig.static.ESCAPE)
end

--reads one input at a time
function GameConfig:readInput()
	local direction = 0
	local key=button_read:getKey()
	local joy,button=button_read:getJoys()

	if(button==nil and joy==nil) then
		DEBUG_PRINT("nilllllllllllll")
	end
	if(self._activepad~=nil) then
		directiony=self._activepad:getAxis( 1 )
		directionx=self._activepad:getAxis( 2 )

		--joy directions first
		if (directionx==-1) then
			return GameConfig.static.UP
		elseif (directionx==1) then
			return GameConfig.static.DOWN
		elseif (directiony==-1) then
			return GameConfig.static.LEFT
		elseif (directiony==1) then
				return GameConfig.static.RIGHT
		end
	end

	if(joy==self._activepad and joy~=nil) then
		DEBUG_PRINT("joy enter="..self._joyEnter_button.."button"..button)
		if(button==self._joyEscape_button) then
			return GameConfig.static.ESCAPE
		elseif (button==self._joyEnter_button) then
			return GameConfig.static.ENTER
		elseif (button==self._joyFire_button) then
			return GameConfig.static.FIRE
		elseif (button==self._joyPower_button) then
			return GameConfig.static.POWER
		elseif (button==self._joyPause_button) then
			return GameConfig.static.PAUSE
		end
	end

	if(key==self._keyUp) then
		return GameConfig.static.UP
	elseif (key==self._keyDown) then
		return GameConfig.static.DOWN
	elseif (key==self._keyLeft) then
		return GameConfig.static.LEFT
	elseif (key==self._keyRight) then
		return GameConfig.static.RIGHT
	elseif (key==self._keyFire) then
		return GameConfig.static.FIRE
	elseif (key==self._keyPower) then
		return GameConfig.static.POWER
	elseif (key==self._keyPause) then
		return GameConfig.static.PAUSE
	elseif (key==self._keyEnter) then
		return GameConfig.static.ENTER
	elseif (key==self._keyEscape) then
		return GameConfig.static.ESCAPE
	end
	return GameConfig.static.NONE
end

--gets controls description in string
function GameConfig:getControlsDescription()
	local desc=""
	desc=desc.."up-> "..self._keyUp.."\n"
	desc=desc.."down-> "..self._keyDown.."\n"
	desc=desc.."left-> "..self._keyLeft.."\n"
	desc=desc.."right-> "..self._keyRight.."\n"
	desc=desc.."fire-> "..self._keyFire.."\n"
	desc=desc.."power-> "..self._keyPower.."\n"
	desc=desc.."pause-> "..self._keyPause.."\n"
	desc=desc.."enter-> "..self._keyEnter.."\n"
	desc=desc.."exit-> "..self._keyEscape.."\n"
	return desc
end