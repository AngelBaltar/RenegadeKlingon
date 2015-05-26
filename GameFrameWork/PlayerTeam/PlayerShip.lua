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
  self._shieldpw=5
  self._weaponpw=5
  self._powertimer=0
  self._player_dummies={}
  self._player_dummies_size=0
end


function PlayerShip:setWeapon(weapon)
  if weapon:toString()=="playerDummy" then
    if self._player_dummies_size<2 then --at least 2 player dummies
      weapon:setWeapon(self._basic_weapon:clone())
      self._player_dummies[self._player_dummies_size]=weapon
      self._player_dummies_size=self._player_dummies_size+1
      weapon:setAttachedShip(self)
    end
  else
    self._basic_weapon=weapon
    for k,dummie in pairs(self._player_dummies) do
      dummie:setWeapon(weapon:clone())
    end
    weapon:setAttachedShip(self)
  end
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
  for k,dummy in pairs(self._player_dummies) do
      dummy:die()
  end
  SpaceObject.die(self)
end

function PlayerShip:collision(object,damage)
  --my bullets do not hit me
  if not ( object:isBullet() and object:getEmmiter():isPlayerShip()) then
    SpaceObject.collision(self,object,damage)
  end
end

function PlayerShip:updateDummies(dt)
  local alive_dummies={}
  local count=0
  for k,dummy in pairs(self._player_dummies) do
    if not dummy:isDead() then
      alive_dummies[count]=dummy
      --alive_dummies[count]:pilot(dt)
      count=count+1
    end
  end
  self._player_dummies_size=count
  self._player_dummies=alive_dummies
end

function PlayerShip:getDummiesSize()
  return self._player_dummies_size
end

function PlayerShip:getDummies()
  return self._player_dummies
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot(dt)
  if not self:isEnabled() then
    return nil
  end
  self:updateDummies(dt)
  if self._autopilot then
    --autpilot here
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

  if (self._player_dummies_size>0)then
      sup_y=sup_y-self:getHeight()
      inf_y=inf_y+self:getHeight()
  end

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
    for k,dummy in pairs(self._player_dummies) do
      dummy:fire(dt)
    end
  end
  if config:isDown(GameConfig.static.POWER) and self._powertimer>=0.2 then
    --one step at a time updating power
    self._shieldpw=self._shieldpw+1
    self._shieldpw=self._shieldpw%11
    self._weaponpw=10-self._shieldpw
    self._powertimer=0
  end
  self._powertimer=self._powertimer+dt
  self:setPosition(position_x,position_y)
end

--gets the player red color
function PlayerShip:getShipColor()
  return 255,0,0
end

--gets the object power on weapons
function PlayerShip:getWeaponPower()
  return self._weaponpw
end

--gets the object power on shields
function PlayerShip:getShieldPower()
  return self._shieldpw
end

function PlayerShip:toString()
  return "player"
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
