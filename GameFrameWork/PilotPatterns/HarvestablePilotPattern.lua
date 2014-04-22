-- /* RenegadeKlingon - LÖVE2D GAME
--  * HarvestablePilotPattern.lua
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
require 'GameFrameWork/PilotPatterns/PilotPattern'
require 'GameFrameWork/PilotPatterns/AvoidCollisionPilotPattern'

HarvestablePilotPattern = class('GameFrameWork.PilotPatterns.HarvestablePilotPattern',PilotPattern)

--constructor
function HarvestablePilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
    self._timer=0
    self._directionX=-1
    self._directionY=1
    self._avoid_collision=AvoidCollisionPilotPattern:new(ship)
end

function HarvestablePilotPattern:setShip(ship)
  PilotPattern.setShip(self,ship)
  self._avoidCollision:setShip(ship)
end

function HarvestablePilotPattern:pilot(dt)
  
  local ship=self:getShip()


  SpaceObject.pilot(ship,dt)
  
  if not ship:isEnabled() then
    return nil
  end
  
  local my_space=ship:getSpace()
  local x_i=my_space:getXinit()
  local x_e=my_space:getXend()-ship:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-ship:getHeight()

  local pos_x=ship:getPositionX()
  local pos_y=ship:getPositionY()

  self._timer=self._timer+dt
  math.randomseed(ship:getHeight()*ship:getWidth())
  math.randomseed(math.random())
  if(math.random()>0.5) then

    if(self._timer>1) then
      self._directionY=self._directionY*-1
      self._timer=0
    end
  else
     if(self._timer>0.7) then
      self._directionY=self._directionY*-1
    end
  end

  if (math.abs(pos_x-x_i)<5) then
    self._directionX=1
  end

  if (math.abs(pos_x-x_e)<5) then
    self._directionX=-1
  end

  if (math.abs(pos_y-y_i)<5) then
    self._directionY=1
  end

  if (math.abs(pos_y-y_e)<5) then
    self._directionY=-1
  end

  ship:setPosition(pos_x+self._directionX,pos_y+self._directionY)
  local collides=self._avoid_collision:pilot(dt)
  if(collides) then
    self._directionY=self._directionY*(-1)
    self._directionX=self._directionX*(-1)
  end
end