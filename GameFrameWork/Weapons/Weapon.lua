-- /* RenegadeKlingon - LÖVE2D GAME
--  * Weapon.lua
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


Weapon = class('GameFrameWork.Weapons.Weapon')

--constructor
function Weapon:initialize(ship_to_attach)	
  self._shot_cadence=self:EnemieCadence() --enemie cadence by default
  self._last_shot=0
  self:setAttachedShip(ship_to_attach)
end

function Weapon:PlayerCadence()
	return 0.2
end

function Weapon:EnemieCadence()
	return 1.5
end

function Weapon:calculateFire()

	 --CALCULATE THE FIRE FOR THE PLAYER
	 local my_ship=self:getAttachedShip()
   	 local my_space=my_ship:getSpace()
     local position_x=my_ship:getPositionX()
     local position_y=my_ship:getPositionY()
	 local shot_emit_x=position_x
	 local shot_emit_y=position_y+my_ship:getHeight()/2
	 local x_relative_step=6
	 local y_relative_step=0

	 if(my_ship:isEnemyShip()) then
	 	--CALCULATE THE FIRE FOR THE ENEMIES
   		shot_emit_x=shot_emit_x-my_ship:getWidth()
   		player=my_space:getPlayerShip()

   		local player_x=0
   		local player_y=0
   
   		local delta_x=-3
   
   		local delta_y=0
   
		if(player~=nil) then
		     player_x=player:getPositionX()
		     player_y=player:getPositionY()
		   
		     delta_x=-3
		     delta_y=3*((player_y-position_y)/(math.abs(player_x-position_x)))
		end
		return shot_emit_x,shot_emit_y,delta_x,delta_y
	 else
	 	shot_emit_x=shot_emit_x+my_ship:getWidth()
	 end

	 return shot_emit_x,shot_emit_y,x_relative_step,y_relative_step
end

function Weapon:doFire()

end

function Weapon:fire(dt)
	self._last_shot=self._last_shot+dt
	if(self._last_shot>self._shot_cadence) then
		self:doFire()
		self._last_shot=0
	end
end

function Weapon:getAttachedShip()
  return self._ship
end

function Weapon:setAttachedShip(ship)

  self._ship=ship
  if (self._ship~=nil) and  (self._ship:isEnemyShip()) then
  	self._shot_cadence=self:EnemieCadence()
  end
  
  if (self._ship~=nil) and  (self._ship:isPlayerShip()) then
  	self._shot_cadence=self:PlayerCadence()
  end
	
end