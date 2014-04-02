-- /* RenegadeKlingon - LÖVE2D GAME
--  * AnomatedExplosion.lua
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
require 'GameFrameWork/Explosions/Explosion'
require 'Utils/Animation'

AnimatedExplosion = class('GameFrameWork.Explosions.AnimatedExplosion',Explosion)


local EXPLOSION1=love.graphics.newImage('Resources/gfx/explosion1.png')
local EXPLOSION2=love.graphics.newImage('Resources/gfx/explosion2.png')
local EXPLOSION3=love.graphics.newImage('Resources/gfx/particlefx_07.png')
local EXPLOSION4=love.graphics.newImage('Resources/gfx/particlefx_08.png')

local explosions_tab={}
explosions_tab[0]={     sprite=EXPLOSION1,
                        size_x=96,
                        size_y=96,
                        n_steps=8,
                        delay=0.1,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion1.mp3',"static")}

explosions_tab[1]={     sprite=EXPLOSION2,
                        size_x=128,
                        size_y=128,
                        n_steps=16,
                        delay=0.1,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion2.mp3',"static")}

explosions_tab[2]={     sprite=EXPLOSION3,
                        size_x=128,
                        size_y=128,
                        n_steps=64,
                        delay=0.01,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion2.mp3',"static")}
explosions_tab[3]={     sprite=EXPLOSION4,
                        size_x=128,
                        size_y=128,
                        n_steps=64,
                        delay=0.01,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion2.mp3',"static")}

local N_EXPLOSIONS=4
--constructor
function AnimatedExplosion:initialize(space,x,y)
  
  self._random_explosion=math.random(N_EXPLOSIONS)-1
  self._animation = newAnimation(explosions_tab[self._random_explosion].sprite,
                                explosions_tab[self._random_explosion].size_x,
                                explosions_tab[self._random_explosion].size_y,
                                explosions_tab[self._random_explosion].delay,
                                explosions_tab[self._random_explosion].n_steps)

  self._animation:setMode(explosions_tab[self._random_explosion].mode)
  self._zoom=explosions_tab[self._random_explosion].zoom
  Explosion.initialize(self,space,x,y,explosions_tab[self._random_explosion].sprite)
  explosions_tab[self._random_explosion].source:stop( )
  explosions_tab[self._random_explosion].source:play()
end

--return the width of this explosion
function AnimatedExplosion:getWidth()
  return explosions_tab[self._random_explosion].size_x*self._zoom
end

--return the height of this explosion
function AnimatedExplosion:getHeight()
  return explosions_tab[self._random_explosion].size_y*self._zoom
end

function AnimatedExplosion:setZoom(zoom)
  self._zoom=self._zoom*zoom
end

--Performs movements changing the position of the object, firing AnimatedExplosions...
function AnimatedExplosion:pilot(dt)
      self._animation:update(dt)
      if not self._animation:isPlaying() then
        self:die()
      end
end

function AnimatedExplosion:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom) 
  --draw the animation object at (16, 16), upright (0 degree), and scale it up 4 times
end