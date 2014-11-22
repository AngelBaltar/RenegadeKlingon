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

AndroidMenu = class('GameFrameWork.AndroidMenu')


AndroidMenu.static.NONE = 0
AndroidMenu.static.UP = 1
AndroidMenu.static.DOWN = 2
AndroidMenu.static.LEFT = 3
AndroidMenu.static.RIGHT = 4
AndroidMenu.static.FIRE = 5
AndroidMenu.static.POWER = 6
AndroidMenu.static.PAUSE = 7
AndroidMenu.static.ENTER = 8
AndroidMenu.static.ESCAPE = 9

local _instance=nil
local button_read=ButtonRead.getInstance()
local sx,sy=0,0
--constructor
local __initialize = function(self)
    sx,sy=love.graphics.getWidth()/800,love.graphics.getHeight()/600
	
    self._width=love.graphics.getWidth()
	self._heigh=67*sy
    self._key_width=9*sy*sx
    self._margin=1.5*self._key_width
    self._menu_y_begin=love.graphics.getHeight()-self._heigh
    
    self._center_up_x=self._margin+self._key_width*2
    self._center_up_y=self._menu_y_begin+self._margin
    self._center_down_x=self._margin+self._key_width*2
    self._center_down_y=self._menu_y_begin+self._margin+self._key_width*2
    self._center_left_x=self._margin
    self._center_left_y=self._menu_y_begin+self._margin+self._key_width*2
    self._center_right_x=self._margin+self._key_width*4
    self._center_right_y=self._menu_y_begin+self._margin+self._key_width*2
    
    self._center_a_x=self._width-self._margin*2-self._key_width*6
    self._center_a_y=self._menu_y_begin+self._heigh/2
    self._center_b_x=self._width-self._margin-self._key_width*2
    self._center_b_y=self._menu_y_begin+self._heigh/2
    
    self._exit_x=love.graphics.getWidth()/2-self._key_width*8
    self._exit_y=self._menu_y_begin+self._key_width

    self._enter_x=love.graphics.getWidth()/2-self._key_width*4+self._margin
    self._enter_y=self._menu_y_begin+self._key_width   

    self._arrows_font=love.graphics.newFont("Resources/fonts/Arrows.ttf",self._key_width*2)
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
    local r,g,b,t=love.graphics.getColor()
	love.graphics.setColor(10,10,150,140)
	love.graphics.rectangle("fill",0,self._menu_y_begin,self._width,self._heigh)
	love.graphics.setColor(255,0,0,255)
	love.graphics.circle( "fill",self._center_up_x ,self._center_up_y , self._key_width, 700 )
	love.graphics.circle( "fill",self._center_down_x ,self._center_down_y , self._key_width, 700 )
	love.graphics.circle( "fill",self._center_left_x ,self._center_left_y , self._key_width, 700 )
	love.graphics.circle( "fill",self._center_right_x ,self._center_right_y , self._key_width, 700 )
    love.graphics.circle( "fill",self._center_a_x ,self._center_a_y , self._key_width*2, 700 )
    love.graphics.circle( "fill",self._center_b_x ,self._center_b_y , self._key_width*2, 700 )
	
    love.graphics.setColor(0,255,0,255)
	local backup_font=love.graphics.getFont()
    love.graphics.print('A', self._center_a_x-backup_font:getWidth('A')/2, self._center_a_y-backup_font:getHeight('A')/2)
    love.graphics.print('B', self._center_b_x-backup_font:getWidth('B')/2, self._center_b_y-backup_font:getHeight('B')/2)

    
	love.graphics.setFont(self._arrows_font)
	love.graphics.print('b', self._center_left_x-self._arrows_font:getWidth('b')/2, self._center_left_y-self._arrows_font:getHeight('b')/2)
	love.graphics.print('a', self._center_right_x-self._arrows_font:getWidth('a')/2, self._center_right_y-self._arrows_font:getHeight('a')/2)
	love.graphics.print('c', self._center_up_x-self._arrows_font:getWidth('c')/2, self._center_up_y-self._arrows_font:getHeight('c')/2)
	love.graphics.print('d', self._center_down_x-self._arrows_font:getWidth('d')/2, self._center_down_y-font:getHeight('d')/2.5)
	

    love.graphics.setColor(128,128,128,255)
    love.graphics.rectangle("fill",self._enter_x,self._enter_y,self._key_width*3,self._key_width*1.5)
    love.graphics.rectangle("fill",self._exit_x,self._exit_y,self._key_width*3,self._key_width*1.5)

    love.graphics.setColor(255,0,0,255)
    love.graphics.print('Q',self._enter_x+self._key_width*1.5,self._enter_y)
    love.graphics.print('R',self._exit_x+self._key_width*1.5,self._exit_y)

    love.graphics.setFont(backup_font)
    
    
   
    love.graphics.setColor(r,g,b,t)

end

function AndroidMenu:isDown(key)
    local x,y=nil,nil
    local wdt=self._key_width*self._key_width
    local wdt2=self._key_width*2*self._key_width*2
    if love.mouse.isDown("l") then
        x, y = love.mouse.getPosition( )
    end
    if x==nil or y==nil then
        return false
    end
    if key==AndroidMenu.static.DOWN then
        return ((x-self._center_down_x)*(x-self._center_down_x)+(y-self._center_down_y)*(y-self._center_down_y)<wdt)
    end
    if key==AndroidMenu.static.UP then
        return ((x-self._center_up_x)*(x-self._center_up_x)+(y-self._center_up_y)*(y-self._center_up_y)<wdt)
    end
    if key==AndroidMenu.static.LEFT then
        return ((x-self._center_left_x)*(x-self._center_left_x)+(y-self._center_left_y)*(y-self._center_left_y)<wdt)
    end
    if key==AndroidMenu.static.RIGHT then
        return ((x-self._center_right_x)*(x-self._center_right_x)+(y-self._center_right_y)*(y-self._center_right_y)<wdt)
    end
    if key==AndroidMenu.static.FIRE then
        return ((x-self._center_a_x)*(x-self._center_a_x)+(y-self._center_a_y)*(y-self._center_a_y)<wdt)
    end
    if key==AndroidMenu.static.POWER then
        return ((x-self._center_b_x)*(x-self._center_b_x)+(y-self._center_b_y)*(y-self._center_b_y)<wdt)
    end
    if key==AndroidMenu.static.ENTER then
        return (x>self._enter_x and x<self._enter_x+self._key_width*3
                and y>self._enter_y and y<self._enter_y+self._key_width*1.5)
    end
    if key==AndroidMenu.ESCAPE then
        return (x>self._exit_x and x<self._exit_x+self._key_width*3
                and y>self._exit_y and y<self._exit_y+self._key_width*1.5)
    end
    return false
end

function AndroidMenu:isDownAnyThing()

    return self:isDown(AndroidMenu.static.UP)     or
            self:isDown(AndroidMenu.static.DOWN)  or
            self:isDown(AndroidMenu.static.LEFT)  or
            self:isDown(AndroidMenu.static.RIGHT)  or
            self:isDown(AndroidMenu.static.FIRE)  or
            self:isDown(AndroidMenu.static.POWER)  or
            self:isDown(AndroidMenu.static.PAUSE) or
            self:isDown(AndroidMenu.static.ENTER) or
            self:isDown(AndroidMenu.static.ESCAPE)
end

function AndroidMenu:readInput()
    local x,y=button_read:getMouse()
    local wdt=self._key_width*self._key_width
    local wdt2=self._key_width*2*self._key_width*2
    if x==nil and y==nil then
        return AndroidMenu.static.NONE
    end

    if (x-self._center_down_x)*(x-self._center_down_x)+(y-self._center_down_y)*(y-self._center_down_y)<wdt then
        return AndroidMenu.static.DOWN
    end
    if (x-self._center_up_x)*(x-self._center_up_x)+(y-self._center_up_y)*(y-self._center_up_y)<wdt then
        return AndroidMenu.static.UP
    end
    if (x-self._center_left_x)*(x-self._center_left_x)+(y-self._center_left_y)*(y-self._center_left_y)<wdt then
        return AndroidMenu.static.LEFT
    end
    if (x-self._center_right_x)*(x-self._center_right_x)+(y-self._center_right_y)*(y-self._center_right_y)<wdt then
        return AndroidMenu.static.RIGHT
    end
    if (x-self._center_a_x)*(x-self._center_a_x)+(y-self._center_a_y)*(y-self._center_a_y)<wdt2 then
        return AndroidMenu.static.FIRE
    end
    if (x-self._center_b_x)*(x-self._center_b_x)+(y-self._center_b_y)*(y-self._center_b_y)<wdt2 then
        return AndroidMenu.static.POWER
    end
    if x>self._enter_x and x<self._enter_x+self._key_width*3
        and y>self._enter_y and y<self._enter_y+self._key_width*1.5 then
        return AndroidMenu.static.ENTER
    end
    if x>self._exit_x and x<self._exit_x+self._key_width*3
        and y>self._exit_y and y<self._exit_y+self._key_width*1.5 then
        return AndroidMenu.static.ESCAPE
    end
    return AndroidMenu.static.NONE
end


function AndroidMenu:getControlsDescription()
    local desc=""
    desc=desc.."up-> up arrow\n"
    desc=desc.."down-> down arrow\n"
    desc=desc.."left-> ..left arrow\n"
    desc=desc.."right-> right arrow\n"
    desc=desc.."fire-> A\n"
    desc=desc.."power-> B\n"
    desc=desc.."pause-> >(Enter)\n"
    desc=desc.."enter-> >(Enter)\n"
    desc=desc.."exit-> <(exit)\n"
    return desc
end
