require 'GameFrameWork/Explosions/Explosion'
require 'Utils/Animation'

AnimatedExplosion = class('GameFrameWork.Explosions.AnimatedExplosion',Explosion)


local EXPLOSION1=love.graphics.newImage('Resources/gfx/explosion1.png')
local EXPLOSION2=love.graphics.newImage('Resources/gfx/explosion2.png')

local explosions_tab={}
explosions_tab[0]={     sprite=EXPLOSION1,
                        size_x=48,
                        size_y=48,
                        n_steps=8,
                        delay=0.1,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion1.wav',"static")}

explosions_tab[1]={     sprite=EXPLOSION2,
                        size_x=64,
                        size_y=64,
                        n_steps=16,
                        delay=0.1,
                        mode="once",
                        zoom=1,
                        source = love.audio.newSource( 'Resources/sfx/explosion2.wav',"static")}

local N_EXPLOSIONS=2
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
  self._zoom=zoom
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