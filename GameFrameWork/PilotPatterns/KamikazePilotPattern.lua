-- /* RenegadeKlingon - LÖVE2D GAME
--  * KamikazePilotPattern.lua
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

KamikazePilotPattern = class('GameFrameWork.PilotPatterns.KamikazePilotPattern',PilotPattern)

--constructor
function KamikazePilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
end

function KamikazePilotPattern:pilot(dt)
  
  local ship=self:getShip()

  SpaceObject.pilot(ship,dt)
  
  if not ship:isEnabled() then
    return nil
  end

  local my_space=ship:getSpace()
  local player=my_space:getPlayerShip()
  local x_i=my_space:getXend()/4
  local x_e=my_space:getXend()-ship:getWidth()

  local y_i=my_space:getYinit()
  local y_e=my_space:getYend()-ship:getHeight()

  local pos_x=ship:getPositionX()
  local pos_y=ship:getPositionY()

  local delta_x=-3
   
  local delta_y=0
  local player_x=0
  local player_y=0
   
 if(player~=nil) then
   player_x=player:getPositionX()
   player_y=player:getPositionY()
 
   delta_x=-3
   delta_y=3*((player_y-pos_y)/(math.abs(player_x-pos_x)))
 end

  ship:setPosition(pos_x+delta_x*5,pos_y+delta_y*5)
 
end