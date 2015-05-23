-- /* RenegadeKlingon - LÖVE2D GAME
--  * WeaponObject.lua
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
require 'GameFrameWork/Harvestables/HarvestableObject'
require 'GameFrameWork/Weapons/MachineGunWeapon'
require 'GameFrameWork/Weapons/DoubleWeapon'
require 'GameFrameWork/PlayerTeam/PlayerDummy'
require 'Utils/Animation'

WeaponObject = class('GameFrameWork.Harverstables.WeaponObject',HarvestableObject)

WeaponObject.static.MACHINE_GUN =1 
WeaponObject.static.DOUBLE_BLUE = 2
WeaponObject.static.DOUBLE_GREEN = 3
WeaponObject.static.DOUBLE_BASIC = 4
WeaponObject.static.PLAYER_DUMMY = 5

local weapon_sprite=love.graphics.newImage("Resources/gfx/crystal.png")


local weapons_animation={
												size_x=17,
												size_y=18,
												n_steps=4,
												mode="loop",
                        delay=0.3,
                        zoom=3}

--constructor
function WeaponObject:initialize(space,weapon_type,posx,posy)

  self._animation = newAnimation(weapon_sprite,
  					                   weapons_animation.size_x,
  					                   weapons_animation.size_y,
                               weapons_animation.delay,
                               weapons_animation.n_steps)

  self._animation:setMode(weapons_animation.mode)
  self._weaponType=weapon_type

  if(self._weaponType==WeaponObject.static.MACHINE_GUN) then
  	self._weapon=MachineGunWeapon:new(nil)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_BLUE) then
    self._weapon=DoubleWeapon:new(nil,AnimatedBullet.static.BLUE_ANIMATED)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_GREEN) then
    self._weapon=DoubleWeapon:new(nil,AnimatedBullet.static.GREEN_ANIMATED)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_BASIC) then
    self._weapon=DoubleBasicWeapon:new(nil)
  end
  if(self._weaponType==WeaponObject.static.PLAYER_DUMMY) then
    self._weapon=PlayerDummy:new()
  end
  self._zoom=weapons_animation.zoom
  HarvestableObject.initialize(self,space,weapon_type,posx,posy,0)

end

function WeaponObject:pilot(dt)
	HarvestableObject.pilot(self,dt)
	self._animation:update(dt)
end

function WeaponObject:collision(object,damage)
    HarvestableObject.collision(self,object,damage)
    if(object:isPlayerShip()) then
    	object:setWeapon(self._weapon)
    end
    if(object:isPlayerDummy()) then
      object:getAttachedShip():setWeapon(self._weapon)
    end
end

--return the width of this ship
function WeaponObject:getWidth()
  return self._animation:getWidth()*self._zoom
end

function WeaponObject:getHeight()
  return self._animation:getHeight()*self._zoom
end

function WeaponObject:draw()
  if(self._weaponType==WeaponObject.static.MACHINE_GUN) then
    love.graphics.setColor(0,255,255,255)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_BLUE) then
     love.graphics.setColor(0,0,255,255)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_GREEN) then
     love.graphics.setColor(0,255,0,255)
  end

  if(self._weaponType==WeaponObject.static.DOUBLE_BASIC) then
     love.graphics.setColor(255,0,0,255)
  end
  if(self._weaponType==WeaponObject.static.PLAYER_DUMMY) then
     love.graphics.setColor(128,0,0,128)
  end
  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom)
  love.graphics.setColor(255,255,255,255)
end

function WeaponObject:toString()
  return "weaponHarvestable"
end