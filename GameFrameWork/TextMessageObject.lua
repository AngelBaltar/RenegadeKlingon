-- /* RenegadeKlingon - LÖVE2D GAME
--  * TextMessageObject.lua
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
require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'
require 'Utils/GameConfig'

TextMessageObject = class('GameFrameWork.TextMessageObject',SpaceObject)

local frame_exit_char='#'

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function TextMessageObject:initialize(space,tile,posx,posy,messageFile,messageText)
  --100 health for the player
 
  self._msgTxt=""
  self._msgDraw=""
  self._ch_act=0
  self._last_frame=0
  self._frame_rate=8
  self._skip_frame=false
  self._height=0
  self._width=0
  self._msgDraw={}
  self._transparency=0
  --DEBUG_PRINT("Opening "..messageFile)
  if (messageFile==nil or 
    not love.filesystem.exists(messageFile))
    and messageText==nil then
    return nil
  end
  
  local iterator=nil
  if(messageFile~=nil) then
    iterator=love.filesystem.lines(messageFile)
  else
    iterator=messageText:gmatch("[^\r\n]+")
  end
  for line in iterator do
        self._msgTxt=self._msgTxt..line.."\n"
  end
  DEBUG_PRINT(self._msgTxt)
 local sx,sy=GameConfig.getInstance():getScale()
 self._font = love.graphics.newFont("Resources/fonts/klingon_blade.ttf",20*sx*sy)
 local ch_act=0
 local count=0
 while (ch_act<string.len(self._msgTxt)) do

   self._msgDraw[count]=""
   n_lines=0
   local line=""

   for i = ch_act, string.len(self._msgTxt) do
        ch=string.sub(self._msgTxt, i, i)
        ch_act=i
        if(ch==frame_exit_char) then
          ch_act=i+2 --SKIP \n after #
          break
        end
        if(ch=='\n') then
          n_lines=n_lines+1
          line=line..ch
          if(self._width<font:getWidth(line)+font:getWidth("A")*2) then
              self._width=font:getWidth(line)+font:getWidth("A")*2
          end
          line=""
        else
          line=line..ch
        end
        self._msgDraw[count]=self._msgDraw[count]..ch
    end
    n_lines=n_lines+1
    if(self._height<font:getHeight()*n_lines) then
      self._height=font:getHeight()*n_lines
    end

    count=count+1
 end
 self._NumMsgs=count
 self._msgNum=0
 SpaceObject.initialize(self,space, tile,posx,posy,2000)
end

--return the width of this ship
function TextMessageObject:getWidth()
	return self._width
end

--return the height of this ship
function TextMessageObject:getHeight()
	return self._height
end


function TextMessageObject:die()

DEBUG_PRINT("Text dies")
self:getSpace():unfreeze()
SpaceObject.die(self)
  
  ---
end

local function _is_active(self)
    local is_active=nil
    if( not SpaceObject.isEnabled(self)) then
      is_active=false
    else
      is_active=((SpaceObject.getPositionX(self)+(self._width/2))
                  <(SpaceObject.getSpace(self).getXend()/2))
    end
    return is_active
end

function TextMessageObject:readPressed()

  if(not _is_active(self)) then
    return 
  end
  local config=GameConfig.getInstance()
  if config:isDownAnyThing() then
    self._skip_frame=true --skip message frame on intro
  end
end



--updates de message
function TextMessageObject:pilot(dt)
    
   
    local pilot=_is_active(self)
    if(not pilot) then
      SpaceObject.pilot(self,dt)
      return
    end
   
    self._last_frame=self._last_frame+dt
    
    if(self._msgNum==0) then
      self:getSpace():freeze(self)
    end

    if(self._msgNum>=self._NumMsgs) then
      self:die()
      --all message was done
    end

    if(self._transparency<220) then
      self._transparency=self._transparency+dt*40
    end
    

    if ((not self._skip_frame) and (self._last_frame<=self._frame_rate)) then
      return nil
    end
    
    self._skip_frame=false

    self._last_frame=dt
    self._msgNum=self._msgNum+1
    self._transparency=0
   
end

--Draws the object in the screen
function TextMessageObject:draw()

    local draw=_is_active(self)
    if(not draw) then
      return
    end

    local x=self:getPositionX()
    local y=self:getPositionY()

    
    if self._msgDraw[self._msgNum]==nil then
      return nil
    end
    local sx,sy=GameConfig.getInstance():getScale()
    local fnt=love.graphics.getFont()
    love.graphics.setFont(self._font)
    local r, g, b, a = love.graphics.getColor( )
    love.graphics.setColor(10,10,150,140)
    love.graphics.rectangle("fill",x,y,self._width,self._height)
    love.graphics.setColor(255,0,0,140)
    love.graphics.rectangle( "line", x,y,self._width,self._height)
    love.graphics.setColor(255,0,0,self._transparency)
    love.graphics.print(self._msgDraw[self._msgNum],x+self._font:getWidth("A"), y)
    love.graphics.setColor(255,0,0,self._transparency)
    love.graphics.setColor(r,g,b,a)
    love.graphics.setFont(fnt)

end

function TextMessageObject:isTextMessage()
  return true
end
