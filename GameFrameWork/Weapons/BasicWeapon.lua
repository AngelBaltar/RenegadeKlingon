-- /* RenegadeKlingon - LÖVE2D GAME
--  * BasicWeapon.lua
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
require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/SimpleBullet'

BasicWeapon = class('GameFrameWork.Weapons.BasicWeapon',Weapon)


--constructor
function BasicWeapon:initialize(ship)
  Weapon.initialize(self,ship)
end

function BasicWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()
   local shot_emit_x,shot_emit_y,delta_x,delta_y=self:calculateFire()
   SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y,delta_x,delta_y)
end

function BasicWeapon:clone()
   x=BasicWeapon:new(nil)
   self:copy(x)
   return x
end