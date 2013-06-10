require 'GameFrameWork/Bullets/Bullet'
require 'GameFrameWork/Explosions/ParticleExplosion'
require 'Utils/Animation'

AnimatedBullet = class('GameFrameWork.AnimatedBullet',Bullet)

AnimatedBullet.static.BLUE_ANIMATED = love.graphics.newImage("Resources/gfx/animated_bullet1.png")

local animation_tab={}
animation_tab[AnimatedBullet.static.BLUE_ANIMATED]={size_x=45,size_y=41,n_steps=7}

--constructor
function AnimatedBullet:initialize(space,emmiter,x,y,stepx,stepy,AnimatedBullet_type)
  --3 health for the AnimatedBullet
  Bullet.initialize(self,space,emmiter,x,y,stepx,stepy,6,AnimatedBullet_type)
  self._animation = newAnimation(AnimatedBullet_type,
  					animation_tab[AnimatedBullet_type].size_x,
  					animation_tab[AnimatedBullet_type].size_x, 0.2, animation_tab[AnimatedBullet_type].n_steps)
  self._animation:setMode("loop")
  
end


function AnimatedBullet:pilot(dt)
	Bullet.pilot(self,dt)
	self._animation:update(dt)
end

--return the width of this ship
function AnimatedBullet:getWidth()
  return self._animation:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_AnimatedBullet.png")
function AnimatedBullet:getHeight()
  return self._animation:getHeight()
end

function AnimatedBullet:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,2) 
end