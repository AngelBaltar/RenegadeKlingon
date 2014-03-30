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
require 'Utils/Animation'

WeaponObject = class('GameFrameWork.Harverstables.WeaponObject',HarvestableObject)

WeaponObject.static.MACHINE_GUN = love.graphics.newImage("Resources/gfx/crystal_pink.png")
WeaponObject.static.DOUBLE_BLUE = love.graphics.newImage("Resources/gfx/crystal_blue.png")
WeaponObject.static.DOUBLE_GREEN = love.graphics.newImage("Resources/gfx/crystal_green.png")
WeaponObject.static.DOUBLE_BASIC = love.graphics.newImage("Resources/gfx/crystal_red.png")

local WP_MACHINEGUN=1
local WP_DOUBLE_BLUE=2
local WP_DOUBLE_GREEN=3
local WP_DOUBLE_BASIC=4


local weapons_tab={}
weapons_tab[WeaponObject.static.MACHINE_GUN]={
												size_x=17,
												size_y=18,
												n_steps=4,
												mode="loop",
                        delay=0.3,
                        zoom=3,
												weapon=WP_MACHINEGUN}

weapons_tab[WeaponObject.static.DOUBLE_BLUE]={
                        size_x=17,
                        size_y=18,
                        n_steps=4,
                        mode="loop",
                        delay=0.3,
                        zoom=3,
                        weapon=WP_DOUBLE_BLUE}

weapons_tab[WeaponObject.static.DOUBLE_GREEN]={
                        size_x=17,
                        size_y=18,
                        n_steps=4,
                        mode="loop",
                        delay=0.3,
                        zoom=3,
                        weapon=WP_DOUBLE_GREEN}

weapons_tab[WeaponObject.static.DOUBLE_BASIC]={
                        size_x=17,
                        size_y=18,
                        n_steps=4,
                        mode="loop",
                        delay=0.3,
                        zoom=3,
                        weapon=WP_DOUBLE_BASIC}

--constructor
function WeaponObject:initialize(space,weapon_type,posx,posy)

 self._animation = newAnimation(weapon_type,
  					                   weapons_tab[weapon_type].size_x,
  					                   weapons_tab[weapon_type].size_y,
                               weapons_tab[weapon_type].delay,
                               weapons_tab[weapon_type].n_steps)
  self._animation:setMode(weapons_tab[weapon_type].mode)

  if(weapons_tab[weapon_type].weapon==WP_MACHINEGUN) then
  	self._weapon=MachineGunWeapon:new(nil)
  end

  if(weapons_tab[weapon_type].weapon==WP_DOUBLE_BLUE) then
    self._weapon=DoubleWeapon:new(nil,AnimatedBullet.static.BLUE_ANIMATED)
  end

  if(weapons_tab[weapon_type].weapon==WP_DOUBLE_GREEN) then
    self._weapon=DoubleWeapon:new(nil,AnimatedBullet.static.GREEN_ANIMATED)
  end

  if(weapons_tab[weapon_type].weapon==WP_DOUBLE_BASIC) then
    self._weapon=DoubleBasicWeapon:new(nil)
  end

  self._zoom=weapons_tab[weapon_type].zoom
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
end

--return the width of this ship
function WeaponObject:getWidth()
  return self._animation:getWidth()*self._zoom
end

function WeaponObject:getHeight()
  return self._animation:getHeight()*self._zoom
end

function WeaponObject:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom) 
end

function WeaponObject:toString()
  return "weapon"
end