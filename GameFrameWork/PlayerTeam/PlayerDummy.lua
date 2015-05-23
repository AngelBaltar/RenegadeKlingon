-- /* RenegadeKlingon - LÖVE2D GAME
--  * PlayerDummy.lua
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

PlayerDummy = class('GameFrameWork.PlayerDummy',SpaceObject)

PlayerDummy.static.SHIP = love.graphics.newImage("Resources/gfx/PlayerDummy.png")
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerDummy:initialize()
  self._player=nil
end

function PlayerDummy:getAttachedShip()
  return self._player
end

function PlayerDummy:setAttachedShip(player)
  self._player=player
  if player:getDummiesSize()==1 then
    self._offsetx=0
    self._offsety=-(player:getHeight()/2)-20
  else
    self._offsetx=0
    self._offsety=(player:getHeight())+20
  end
  SpaceObject.initialize(self,player:getSpace(), 
                            PlayerDummy.static.SHIP,
                            player:getPositionX()+self._offsetx,player:getPositionY()+self._offsety,50)
  self:setWeapon(BasicWeapon:new(self))
end

function PlayerDummy:fire(dt)
    self._basic_weapon:fire(dt)
    --DEBUG_PRINT(self._basic_weapon:getAttachedShip():toString())
end

function PlayerDummy:setWeapon(weapon)
  self._basic_weapon=weapon
  weapon:setAttachedShip(self)
end

function PlayerDummy:getWeapon()
  return self._basic_weapon
end

function PlayerDummy:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  AnimatedExplosion:new(my_space,x,y)
  --love.graphics.setColor(255,200,200,255)
  SpaceObject.die(self)
end

function PlayerDummy:collision(object,damage)
  --my bullets do not hit me
  if not ( object:isBullet() and object:getEmmiter():isPlayerDummy()) then
    SpaceObject.collision(self,object,damage)
  end
end

--Performs movements changing the position of the object, firing bullets...
function PlayerDummy:pilot(dt)
  local player=self:getAttachedShip()
  self:setPosition(player:getPositionX()+self._offsetx,player:getPositionY()+self._offsety)
end

--gets the player red color
function PlayerDummy:getShipColor()
  return 255,0,0
end

--gets the object power on weapons
function PlayerDummy:getWeaponPower()
  return self._player:getWeaponPower()
end

--gets the object power on shields
function PlayerDummy:getShieldPower()
  return self._player:getShieldPower()
end

function PlayerDummy:toString()
  return "playerDummy"
end

--im the playerdummy, ovewritting from SpaceObject
function PlayerDummy:isPlayerDummy()
  return true
end