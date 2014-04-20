-- /* RenegadeKlingon - LÖVE2D GAME
--  * Menu.lua
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
require	'Utils/GameConfig'
Menu = class('Menu') 

local config=GameConfig.getInstance()

function Menu:initialize(X,Y)
	self._itemsList={}
	self._insertAt=0
	self._focus=0
	self._posX=X
	self._posY=Y
end

function Menu:addItem(item)
	self._itemsList[self._insertAt]=item
	self._insertAt=self._insertAt+1
end

function Menu:print()
	i=0
	tittle="a"
	x=self._posX
	y=self._posY
	while (i<self._insertAt) do
		   if(self._focus==i) then
		   	love.graphics.setColor(0,255,0,255)
		   else
		   	love.graphics.setColor(255,0,0,255)
		   end
           love.graphics.print(self._itemsList[i], x, y)
           y=y+love.graphics.getFont():getHeight()+3
           i=i+1
    end
end

function Menu:readPressed()
	
	local read=config:readInput()
	DEBUG_PRINT(self._itemsList[0].." readed "..read)
	if(read==GameConfig.static.UP) then
		self._focus=self._focus-1
	end
	if(read==GameConfig.static.DOWN) then
		self._focus=self._focus+1
	end
	if(read==GameConfig.static.ENTER) then
		return self._focus+1
	end
	if(read==GameConfig.static.ESCAPE) then
		return Screen:getExitMark()
	end
	self._focus=self._focus%self._insertAt
    return 0
end
