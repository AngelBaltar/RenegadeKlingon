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


SimpleBullet = class('GameFrameWork.SimpleBullet',Bullet)

SimpleBullet.static.BLUE_BULLET = love.graphics.newImage("Resources/gfx/blue_bullet.png")
SimpleBullet.static.RED_BULLET =love.graphics.newImage("Resources/gfx/red_bullet.png")
local source=love.audio.newSource( 'Resources/sfx/basic_weapon.mp3',"static")
--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function SimpleBullet:initialize(space,emmiter,x,y,stepx,stepy,SimpleBullet_type)
  --3 health for the SimpleBullet
  Bullet.initialize(self,space,emmiter,x,y,stepx,stepy,3,SimpleBullet_type)
  source:stop()
  source:play()
end

--return the width of this ship
function SimpleBullet:getWidth()
  local bll=Bullet.getDrawableObject(self)
	return bll:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_SimpleBullet.png")
function SimpleBullet:getHeight()
  local bll=Bullet.getDrawableObject(self)
	return bll:getHeight()
end