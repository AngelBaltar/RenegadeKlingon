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

GameConfig = class('GameFrameWork.GameConfig')

local _instance=nil
local button_read=ButtonRead.getInstance()


local _readConfigFile=function(self)

	if not love.filesystem.exists( "RenegadeKlingon.conf") then
		return nil
	end
	local i=1
	local iterator=love.filesystem.lines("RenegadeKlingon.conf")
	local sub_ini=0
	for line in iterator do
		if self._properties_ordered[i] ~= nil then
     		self[self._properties_ordered[i].value]=string.sub(line, sub_ini, -1)
     		if(self._properties_ordered[i].type=="number") then
     			self[self._properties_ordered[i].value]=tonumber(self[self._properties_ordered[i].value])
     		end
    		i=i+1
    		sub_ini=2
    		DEBUG_PRINT(string.sub(line,sub_ini, -1))
    	end
   	end

end

--constructor
local __initialize = function(self)
	
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyRight="right"
	self._keyFire="a"
	self._keyPause="p"
	self._keyEnter="return"
	self._keyEscape="escape"

	self._joyFire_num=-1
	self._joyFire_button=-1
	self._joyPause_num=-1
	self._joyPause_button=-1
	self._joyEnter_num=-1
	self._joyEnter_button=-1
	self._joyEscape_num=-1
	self._joyEscape_button=-1

	self._properties_ordered={
								{value="_keyUp",type="string"},
								{value="_keyDown",type="string"},
								{value="_keyLeft",type="string"},
								{value="_keyRight",type="string"},
								{value="_keyFire",type="string"},
								{value="_keyPause",type="string"},
								{value="_keyEnter",type="string"},
								{value="_keyEscape",type="string"},
								
								{value="_joyFire_num",type="number"},
								{value="_joyFire_button",type="number"},

								{value="_joyPause_num",type="number"},
								{value="_joyPause_button",type="number"},

								{value="_joyEnter_num",type="number"},
								{value="_joyEnter_button",type="number"},

								{value="_joyEscape_num",type="number"},
								{value="_joyEscape_button",type="number"},
								nil}

	_readConfigFile(self)

	-- 	self._joyFire_num=-1
	-- self._joyFire_button=-1
	-- self._joyPause_num=-1
	-- self._joyPause_button=-1
	-- self._joyEnter_num=-1
	-- self._joyEnter_button=-1
	-- self._joyEscape_num=-1
	-- self._joyEscape_button=-1
	-- self._keyEnter="return"

	name =nil
	joypad_found=false
	i=0
	self._activepad=0
	n_joys=love.joystick.getNumJoysticks()
	while (i<=n_joys and not joypad_found) do
		name = love.joystick.getName(i)
		if name ~= nil then
			joypad_found=true
			self._activepad=i
		end
		i=i+1
	end
	DEBUG_PRINT("ACTIVE PAD IS: "..self["_activepad"])
	

end

local _writeConfigFile=function(self)
	local File conf_file=love.filesystem.newFile("RenegadeKlingon.conf")
	conf_file:open('w')

	local i=1

	 while (self._properties_ordered[i]~=nil) do
	 	conf_file:write(self[self._properties_ordered[i].value].."\n\r")
	 	i=i+1
	 end

	conf_file:close()

end



--return the width of this ship
function GameConfig.getInstance()
  if _instance==nil then
  	_instance=GameConfig:new()
  	__initialize(_instance)
  end
  return _instance
end

function GameConfig:setKeyUp(keyUp)
	self._keyUp=keyUp
	_writeConfigFile(self)
end

function GameConfig:setKeyDown(keyDown)
	self._keyDown=keyDown
	_writeConfigFile(self)
end


function GameConfig:setKeyRight(keyRight)
	self._keyRight=keyRight
	_writeConfigFile(self)
end


function GameConfig:setKeyLeft(keyLeft)
	self._keyLeft=keyLeft
	_writeConfigFile(self)
end

function GameConfig:setKeyFire(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyFire=joystick_key
	else
		self._joyFire_num=joystick_key
		self._joyFire_button=button_nil
	end
	_writeConfigFile(self)
	
end

function GameConfig:setKeyPause(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyPause=joystick_key
	else
		self._joyPause_num=joystick_key
		self._joyPause_button=button_nil
	end
	_writeConfigFile(self)
	
end

function GameConfig:setKeyEnter(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyEnter=joystick_key
	else
		self._joyEnter_num=joystick_key
		self._joyEnter_button=button_nil
	end
	_writeConfigFile(self)
	
end

function GameConfig:setKeyEscape(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyEscape=joystick_key
	else
		self._joyEscape_num=joystick_key
		self._joyEscape_button=button_nil
	end
	_writeConfigFile(self)
	
end

function GameConfig:getKeyUp()
	return self._keyUp
end


function GameConfig:getKeyDown()
	return self._keyDown
end


function GameConfig:getKeyRight()
	return self._keyRight
end


function GameConfig:getKeyLeft()
	return self._keyLeft
end


function GameConfig:getKeyFire()
	ret=self._keyFire

	if(self._joyFire_num~=-1 and self._joyFire_button~=-1) then
		name = love.joystick.getName(self._joyFire_num)
		if(name~=nil) then
			ret=ret.." OR "..name.." B"..self._joyFire_button
		end
	end

	return ret
end

function GameConfig:getKeyPause()
	ret=self._keyPause

	if(self._joyPause_num~=-1 and self._joyPause_button~=-1) then
		name = love.joystick.getName(self._joyPause_num)
		if(name~=nil) then
			ret=ret.." OR "..name.." B"..self._joyPause_button
		end
	end

	return ret
end

function GameConfig:getKeyEnter()
	ret=self._keyEnter

	if(self._joyEnter_num~=-1 and self._joyEnter_button~=-1) then
		name = love.joystick.getName(self._joyEnter_num)
		if(name~=nil) then
			ret=ret.." OR "..name.." B"..self._joyEnter_button
		end
	end

	return ret
end

function GameConfig:getKeyEscape()
	ret=self._keyEscape

	if(self._joyEscape_num~=-1 and self._joyEscape_button~=-1) then
		name = love.joystick.getName(self._joyEscape_num)
		if(name~=nil) then
			ret=ret.." OR "..name.." B"..self._joyEscape_button
		end
	end

	return ret
end

function GameConfig:getActiveJoyPad()
	return self._activepad
end

function GameConfig:isDownUp()
	direction = love.joystick.getAxis(self._activepad, 2 )
--	DEBUG_PRINT("activepad: "..self._activepad.." direction:"..direction)
	return love.keyboard.isDown(self._keyUp) or direction==-1 
end

function GameConfig:isDownDown()
	direction = love.joystick.getAxis(self._activepad, 2 )
	return love.keyboard.isDown(self._keyDown) or direction==1
end

function GameConfig:isDownRight()
	direction = love.joystick.getAxis(self._activepad, 1 )
	return love.keyboard.isDown(self._keyRight) or direction==1
end

function GameConfig:isDownLeft()
	direction = love.joystick.getAxis(self._activepad, 1 )
	return love.keyboard.isDown(self._keyLeft) or direction==-1
end

function GameConfig:isDownFire()
	return love.keyboard.isDown(self._keyFire)	
			or love.joystick.isDown( self._joyFire_num,self._joyFire_button)
end

function GameConfig:isDownPause()
	return love.keyboard.isDown(self._keyPause)
		or love.joystick.isDown( self._joyPause_num,self._joyPause_button)
end

function GameConfig:isDownEnter()
	return button_read:getKey()==self._keyEnter
		or love.joystick.isDown( self._joyEnter_num,self._joyEnter_button)
end

function GameConfig:isDownEscape()
	return love.keyboard.isDown(self._keyEscape)
		or love.joystick.isDown( self._joyEscape_num,self._joyEscape_button)
end

function GameConfig:isDownAnyThing()
	return self:isDownUp() 	 or
         	self:isDownDown()  or
         	self:isDownRight() or
         	self:isDownLeft()  or
         	self:isDownFire()  or
         	self:isDownPause() or
         	self:isDownEnter() or
         	self:isDownEscape()
end

function GameConfig:getControlsDescription()
	local desc=""
	desc=desc.."up-> "..self._keyUp.."\n"
	desc=desc.."down-> "..self._keyDown.."\n"
	desc=desc.."left-> "..self._keyLeft.."\n"
	desc=desc.."right-> "..self._keyRight.."\n"
	desc=desc.."fire-> "..self._keyFire.."\n"
	desc=desc.."pause-> "..self._keyPause.."\n"
	desc=desc.."enter-> "..self._keyEnter.."\n"
	desc=desc.."exit-> "..self._keyEscape.."\n"
	return desc
end