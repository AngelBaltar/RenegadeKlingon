-- /* RenegadeKlingon - LÖVE2D GAME
--  * PlayerShip.lua
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
require 'GameFrameWork/Explosions/AnimatedExplosion'
require 'GameFrameWork/Weapons/DoubleBasicWeapon'
require 'GameFrameWork/Weapons/MachineGunWeapon'
require 'GameFrameWork/PilotPatterns/PlayerAutoPlayPilotPattern'
require 'Utils/Debugging'
require 'Utils/GameConfig'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

PlayerShip.static.SHIP = love.graphics.newImage("Resources/gfx/destructor_klingon.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize(space,posx,posy)
  --100 health for the player
  SpaceObject.initialize(self,space, PlayerShip.static.SHIP,posx,posy,100)
  self._basic_weapon=BasicWeapon:new(self)
  --self._basic_weapon=DoubleBasicWeapon:new(self)
  self._autopilot=false
  self._autoPattern=PlayerAutoPlayPilotPattern:new(self)
end

--return the width of this ship
function PlayerShip:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function PlayerShip:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

function PlayerShip:setWeapon(weapon)
  self._basic_weapon=weapon
  weapon:setAttachedShip(self)
end

function PlayerShip:getWeapon()
  return self._basic_weapon
end

function PlayerShip:setAutoPilot(autopilot)
  self._autopilot=autopilot
end

function PlayerShip:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  AnimatedExplosion:new(my_space,x,y)
  love.graphics.setColor(255,200,200,255)
  SpaceObject.die(self)
end

function PlayerShip:collision(object,damage)
  --my bullets do not hit me
  if not ( object:isBullet() and object:getEmmiter():isPlayerShip()) then
    SpaceObject.collision(self,object,damage)
  end
end

function PlayerShip:autoPilot(dt)

end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
  if not self:isEnabled() then
    return nil
  end
  if self._autopilot then
    return self._autoPattern:pilot(dt)
  end
  local step=200*dt
  local position_x=SpaceObject.getPositionX(self)
  local position_y=SpaceObject.getPositionY(self)
  local my_space=SpaceObject.getSpace(self)

  local inf_y=my_space:getYinit()+4
  local inf_x=my_space:getXinit()+4

  local sup_y=my_space:getYend()-self:getHeight()-4
  local sup_x=my_space:getXend()-self:getWidth()-4

  local config=GameConfig.getInstance()

  if config:isDown(GameConfig.static.UP) then
    if(position_y-step>inf_y)then
      position_y=position_y-step
    end
   end
  if config:isDown(GameConfig.static.DOWN) then
    if(position_y+step<sup_y)then
      position_y=position_y+step
    end
   end

   if config:isDown(GameConfig.static.LEFT) then
    if(position_x-step>inf_x)then
      position_x=position_x-step
    end
   end
  if config:isDown(GameConfig.static.RIGHT) then
    if(position_x+step<sup_x)then
      position_x=position_x+step
    end
   end
  if config:isDown(GameConfig.static.FIRE) then
    self._basic_weapon:fire(dt)
   end
   self:setPosition(position_x,position_y)
end

function PlayerShip:toString()
  return "player"
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
