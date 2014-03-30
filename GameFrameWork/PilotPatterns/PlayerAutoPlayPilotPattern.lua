-- /* RenegadeKlingon - LÖVE2D GAME
--  * PlayerAutoPlayPilotPattern.lua
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

PlayerAutoPlayPilotPattern = class('GameFrameWork.PilotPatterns.PlayerAutoPlayPilotPattern',PilotPattern)

--constructor
function PlayerAutoPlayPilotPattern:initialize(ship)
    PilotPattern.initialize(self,ship)
end

function PlayerAutoPlayPilotPattern:pilot(dt)
  
  local ship=self:getShip()

    local step=200*dt
  local position_x=SpaceObject.getPositionX(ship)
  local position_y=SpaceObject.getPositionY(ship)
  local my_space=SpaceObject.getSpace(ship)
  local enemies=my_space:getEnabledEnemies()
  local nenemies=0
  local fired=false

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-ship:getHeight()-4
  local sup_x=my_space:getPlayerBackGroundScroll()+4
  local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=ship:getWeapon():calculateFire()
  
  local enemy=nil
  for obj,_ in pairs(enemies) do
    DEBUG_PRINT("diff with "..obj:toString()..":"..math.abs((obj:getPositionY()-obj:getHeight()/2)-shot_emit_y))
    nenemies=nenemies+1
    if math.abs((obj:getPositionY()+obj:getHeight()/2)-shot_emit_y)<obj:getHeight()/2 then
      ship:getWeapon():fire(dt)
      fired=true
      break
    end
    enemy=obj
  end

  if not fired and enemy~=nil then
      if enemy:getPositionY()>shot_emit_y then
          
           if(position_y+step<sup_y)then
              position_y=position_y+step
           end
      else
           if(position_y-step>inf_y)then
            position_y=position_y-step
          end
      end
  end


  if nenemies==0 then
    if(position_x+step<sup_x)then
      position_x=position_x+step
    end
  else
      if(position_x-step>inf_x)then
        position_x=position_x-step
      end
  end

  ship:setPosition(position_x,position_y)
  return nil
 
end