-- /* RenegadeKlingon - LÖVE2D GAME
--  * Enemy.lua
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

Enemy = class('GameFrameWork.Enemies.Enemy',SpaceObject)

Enemy.static.FEDERATION = 1
Enemy.static.ROMULAN = 2


--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Enemy:initialize(space,drawable,posx,posy,health,speed,movementPattern,weapon,race)
  --100 health for the enemy
  SpaceObject.initialize(self,space, drawable,posx,posy,health)
  self._speed=speed
  self._movementPattern=movementPattern
  self._weapon=weapon
  self._race=race
end

--gets the player red color
function Enemy:getShipColor()
  if(self._race==Enemy.static.FEDERATION) then
    return 64,128,255
  elseif(self._race==Enemy.static.ROMULAN) then
    return 0,255,0
  else
    return SpaceObject.getShipColor(self)
  end

end

function Enemy:getSpeed()
  return self._speed
end

--return the width of this ship
function Enemy:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function Enemy:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

function Enemy:collision(object,damage)
  --other enemies bullets do not hit me
  if not (object:isBullet() and object:getEmmiter():isEnemyShip())
  and not object:isEnemyShip() and
  not object:isHarvestableObject() then
    SpaceObject.collision(self,object,damage)
    --DEBUG_PRINT("COLLIDING WITH DAMAGE "..damage.."\n")
  end
end

function Enemy:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  SpaceObject.die(self)
  local explo=nil
  if my_space:isInBounds(self) then
    explo=AnimatedExplosion:new(my_space,x,y)
    explo:setZoom(self:getStimatedSize()/explo:getStimatedSize())
  end
end

--Performs movements changing the position of the object, firing bullets...
function Enemy:pilot(dt)
  SpaceObject.pilot(self,dt)
  if not self:isEnabled() then
    return nil
  end
  self._movementPattern:pilot(dt)
end

--gets the object power on weapons
function Enemy:getWeaponPower()
  return SpaceObject.getTotalPower()/2;
end

--gets the object power on shields
function Enemy:getShieldPower()
  return SpaceObject.getTotalPower()/2;
end

--im the enemy, ovewritting from SpaceObject
function Enemy:isEnemyShip()
	return true
end

function Enemy:toString()
  return "Enemy"
end