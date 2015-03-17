-- /* RenegadeKlingon - LÖVE2D GAME
--  * SimpleBullet.lua
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
require 'GameFrameWork/Bullets/Bullet'
require 'GameFrameWork/Explosions/ParticleExplosion'
require 'Utils/GameConfig'


SimpleBullet = class('GameFrameWork.SimpleBullet',Bullet)

local source=love.audio.newSource( 'Resources/sfx/basic_weapon.mp3',"static")
--constructor
--posx and posy define the initial positions for the object
function SimpleBullet:initialize(space,emmiter,x,y,stepx,stepy)
  --3 health for the SimpleBullet
  Bullet.initialize(self,space,emmiter,x,y,stepx,stepy,3,nil)
  source:setVolume(0.1)
  source:stop()
  source:play()
end

function SimpleBullet:draw()
	local r,g,b=self:getEmmiter():getShipColor()
  local sx,sy=GameConfig.getInstance():getScale()
	love.graphics.setColor(r,g,b,255)
	love.graphics.circle( "fill", self:getPositionX(), self:getPositionY(),2*sy*sx, 700 )
	love.graphics.setColor(255,255,255,255)
end

--return the width of this ship
function SimpleBullet:getWidth()
  local sx,sy=GameConfig.getInstance():getScale()
  return 2*sy*sx
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_SimpleBullet.png")
function SimpleBullet:getHeight()
  local sx,sy=GameConfig.getInstance():getScale()
  return 2*sy*sx
end