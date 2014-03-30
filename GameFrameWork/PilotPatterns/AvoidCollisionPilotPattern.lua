-- /* RenegadeKlingon - LÖVE2D GAME
--  * AvoidCollisionPilotPattern.lua
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

AvoidCollisionPilotPattern = class('GameFrameWork.PilotPatterns.AvoidCollisionPilotPattern',PilotPattern)

--constructor
function AvoidCollisionPilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
    self._timer=0
    self._directionX=-1
    self._directionY=1
end

function AvoidCollisionPilotPattern:pilot(dt)
  
  local ship=self:getShip()

  local speed=ship:getSpeed()
  local my_space=ship:getSpace()

  local pos_x=ship:getPositionX()
  local pos_y=ship:getPositionY()
  local objects=my_space:getAllNotBulletsEnabledObjects()
  local collision=false
  local rnd1=0
  local rnd2=0
  local rnd3=0
  local dir1=1
  local dir2=1
  local iter=0
  local iter_max=10
  
 
  collision=false
  for obj,_ in pairs(objects) do
    collision=collision or my_space:naturalCollisionCheck(obj,ship)
    if collision then
      break
    end
  end

iter=0
while collision and iter<iter_max do
  iter=iter+1
  rnd1=math.random(5)
  rnd2=math.random()
  rnd3=math.random()
  self._timer=0
  
 
  if(rnd3>0.5) then
    dir1=1
    self._directionX=self._directionX*-1
  else
    dir1=-1
  end

  if(rnd2>0.5) then
    dir2=1
     self._directionY=self._directionY*-1
  else
    dir2=-1
  end

  ship:setPosition(pos_x+rnd1*dir1*speed,pos_y+rnd1*dir2*speed)
  collision=false
  for obj,_ in pairs(objects) do
    collision=collision or my_space:naturalCollisionCheck(obj,ship)
    if collision then
      break
    end
  end
end
return (iter~=0)
end