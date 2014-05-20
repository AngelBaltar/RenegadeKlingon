-- /* RenegadeKlingon - LÖVE2D GAME
--  * FlowDownTextScreen.lua
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

FlowDownTextScreen = class('FlowDownTextScreen', Screen)

local config=GameConfig.getInstance()


function FlowDownTextScreen:initialize(message)
 	self:setMessage(message)
end 

function  FlowDownTextScreen:setMessage(message)
	  self._xPos=400
	  self._yPos=nil
	  self._message=message
	  self._numLines=0
	  for i in self._message:gmatch("\n") do self._numLines=self._numLines+1 end
	  font=love.graphics.getFont()
	  self._yPos=(2-self._numLines)*font:getHeight()
end

function FlowDownTextScreen:draw()
	if(self._yPos~=nil) then
	 love.graphics.setColor(255,0,0,255)
	 love.graphics.print(self._message
	 					, self._xPos, self._yPos)
	end

end

function FlowDownTextScreen:update(dt)
	font=love.graphics.getFont()
	if(self._yPos==nil) then
	 	self._yPos=(2-self._numLines)*font:getHeight()
	end
	self._yPos=self._yPos+0.5
	if(self._yPos>600) then
		self._yPos=(2-self._numLines)*font:getHeight()
	end
end

function FlowDownTextScreen:readPressed()
	local read=config:readInput()
	if read==GameConfig.static.ESCAPE then
		self._xPos=400
		self._yPos=nil
    	return Screen:getExitMark()
   end
   return 1
end