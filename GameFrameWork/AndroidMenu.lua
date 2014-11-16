-- /* RenegadeKlingon - LÖVE2D GAME
--  * AndroidMenu.lua
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
require 'Utils/GameConfig'

AndroidMenu = class('GameFrameWork.AndroidMenu')

local _instance=nil
local config=GameConfig.getInstance()

--constructor
local __initialize = function(self)
	sx,sy=config:getScale()
	if config:getTargetMachine()==GameConfig.static.ANDROID then
		self._width=love.graphics.getWidth()
		self._heigh=67*sy
	else
		self._width=0
		self._heigh=0
	end
end

--return the width of this ship
function AndroidMenu.getInstance()
  if _instance==nil then
  	_instance=AndroidMenu:new()
  	__initialize(_instance)
  end
  return _instance
end

function AndroidMenu:gethigh()
	return self._heigh
end

function AndroidMenu:getwidth()
	return self._heigh
end

function AndroidMenu:draw()
	if config:getTargetMachine()==GameConfig.static.ANDROID then
		sx,sy=config:getScale()
		menu_y_begin=love.graphics.getHeight()-self._heigh
		love.graphics.setColor(10,10,150,140)
    	love.graphics.rectangle("fill",0,menu_y_begin,self._width,self._heigh)
    	local key_width=10*sy
    	local margin=1.5*key_width
    	local center_up_x=margin+key_width*2
    	local center_up_y=menu_y_begin+margin
    	local center_down_x=margin+key_width*2
    	local center_down_y=menu_y_begin+margin+key_width*4
    	local center_left_x=margin
    	local center_left_y=menu_y_begin+margin+key_width*2
    	local center_right_x=margin+key_width*4
    	local center_right_y=menu_y_begin+margin+key_width*2
    	love.graphics.setColor(255,0,0,255)
    	love.graphics.circle( "fill",center_up_x ,center_up_y , key_width, 700 )
    	love.graphics.circle( "fill",center_down_x ,center_down_y , key_width, 700 )
    	love.graphics.circle( "fill",center_left_x ,center_left_y , key_width, 700 )
    	love.graphics.circle( "fill",center_right_x ,center_right_y , key_width, 700 )
    	love.graphics.setColor(0,255,0,255)
    	local backup_font=love.graphics.getFont()
    	local font=love.graphics.newFont("Resources/fonts/Arrows.ttf",key_width*2)
    	love.graphics.setFont(font)
    	love.graphics.print('b', center_left_x-font:getWidth('b')/2, center_left_y-font:getHeight('b')/2)
    	love.graphics.print('a', center_right_x-font:getWidth('a')/2, center_right_y-font:getHeight('a')/2)
    	love.graphics.print('c', center_up_x-font:getWidth('c')/2, center_up_y-font:getHeight('c')/2)
    	love.graphics.print('d', center_down_x-font:getWidth('d')/2, center_down_y-font:getHeight('d')/2)
    	love.graphics.setFont(backup_font)
	end
end




