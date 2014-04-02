-- /* RenegadeKlingon - LÖVE2D GAME
--  * MineBlock.lua
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
require 'GameFrameWork/TileBlocks/TileBlock'
require 'Utils/Animation'
require 'Utils/Debugging'


MineBlock = class('GameFrameWork.TileBlocks.MineBlock',TileBlock)
local MINE1 = love.graphics.newImage("Resources/gfx/mine.png")

local mines_tab={}
mines_tab[0]={     sprite=MINE1,
                        size_x=48,
                        size_y=48,
                        n_steps=3,
                        delay=0.1,
                        mode="loop",
                        zoom=0.7}

--constructor
function MineBlock:initialize(space,tile,weapon,x,y)
  local random_mine=0
  self._mine=newAnimation(mines_tab[random_mine].sprite,
                                mines_tab[random_mine].size_x,
                                mines_tab[random_mine].size_y,
                                mines_tab[random_mine].delay,
                                mines_tab[random_mine].n_steps)

  self._mine:setMode(mines_tab[random_mine].mode)
  self._zoom=mines_tab[random_mine].zoom
  TileBlock.initialize(self,space,tile,x,y,50)
  self._mine:play()
  self._weapon=weapon
end

function MineBlock:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  SpaceObject.die(self)
  if my_space:isInBounds(self) then
    local explo=AnimatedExplosion:new(my_space,x,y)
    explo:setZoom(self:getStimatedSize()/explo:getStimatedSize())
  end
end

function MineBlock:getWidth()
  return self._mine:getWidth()*self._zoom
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_MineBlock.png")
function MineBlock:getHeight()
  return self._mine:getHeight()*self._zoom
end

function MineBlock:pilot(dt)
  self._mine:update(dt)
  TileBlock.pilot(self,dt)
  if(self._weapon~=nil) and (SpaceObject.isEnabled(self)) then
    self._weapon:fire(dt)
  end   
end

--Draws the object in the screen
function MineBlock:draw()
  self._mine:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom) 
end

function MineBlock:isEnemyShip()
  return true
end

function MineBlock:toString()
  return "MINE"
end