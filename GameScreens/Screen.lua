-- /* RenegadeKlingon - LÖVE2D GAME
--  * Screen.lua
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
require 'Utils/middleclass/middleclass'
require 'Utils/GameConfig'

Screen = class('Screen')


function Screen:initialize()
	self._status=0
	self._read_cadence=0.08
  	self._last_read=0
end

function Screen:draw()
end

function Screen:update(dt)
	--monitorice joystick axis, must be in update call
	local pad=GameConfig.getInstance():getActiveJoyPad()
	local direction1 = love.joystick.getAxis(pad, 2 )
	local direction2 = love.joystick.getAxis(pad, 1 )
	self._last_read=self._last_read+dt
	if(self._last_read>self._read_cadence) then
		self._last_read=0
		if(direction1~=0 or direction2~=0) and self._status==0 then
			self._status=1
			self:readPressed()
		else
			self._status=0
		end
	end
end

function Screen:readPressed()
end

function Screen.static:getExitMark()
	return -10
end