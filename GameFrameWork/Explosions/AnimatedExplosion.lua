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
                        zoom=1}

explosions_tab[1]={     sprite=EXPLOSION2,
                        size_x=64,
                        size_y=64,
                        n_steps=16,
                        delay=0.1,
                        mode="once",
                        zoom=1}

local N_EXPLOSIONS=2
--constructor
function AnimatedExplosion:initialize(space,x,y)
  
  local random_explosion=math.random(N_EXPLOSIONS)-1
  self._animation = newAnimation(explosions_tab[random_explosion].sprite,
                                explosions_tab[random_explosion].size_x,
                                explosions_tab[random_explosion].size_y,
                                explosions_tab[random_explosion].delay,
                                explosions_tab[random_explosion].n_steps)

  self._animation:setMode(explosions_tab[random_explosion].mode)
  Explosion.initialize(self,space,x,y,explosions_tab[random_explosion].sprite)
  self._zoom=explosions_tab[random_explosion].zoom
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