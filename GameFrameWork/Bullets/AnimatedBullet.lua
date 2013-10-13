require 'GameFrameWork/Bullets/Bullet'
require 'GameFrameWork/Explosions/ParticleExplosion'
require 'Utils/Animation'

AnimatedBullet = class('GameFrameWork.AnimatedBullet',Bullet)

AnimatedBullet.static.BLUE_ANIMATED = love.graphics.newImage("Resources/gfx/bullet_double_blue.png")
AnimatedBullet.static.GREEN_ANIMATED = love.graphics.newImage("Resources/gfx/bullet_double_green.png")
AnimatedBullet.static.PINK_ANIMATED = love.graphics.newImage("Resources/gfx/bullet_machinegun.png")

local animation_tab={}
animation_tab[AnimatedBullet.static.BLUE_ANIMATED]={size_x=32,
                                                    size_y=32,
                                                    n_steps=8,
                                                    mode="loop",
                                                    zoom=1,
                                                    health=6,
                                                    source=love.audio.newSource( 'Resources/sfx/double_weapon.wav',"static")}

animation_tab[AnimatedBullet.static.GREEN_ANIMATED]={size_x=32,
                                                    size_y=32,
                                                    n_steps=8,
                                                    mode="loop",
                                                    zoom=1,
                                                    health=12,
                                                    source=love.audio.newSource( 'Resources/sfx/double_weapon.wav',"static")}
animation_tab[AnimatedBullet.static.PINK_ANIMATED]={size_x=32,
                                                    size_y=32,
                                                    n_steps=4,
                                                    mode="bounce",
                                                    zoom=2,
                                                    health=20,
                                                    source=love.audio.newSource( 'Resources/sfx/machine_gun.wav',"static")
                                                  }

--constructor
function AnimatedBullet:initialize(space,emmiter,x,y,stepx,stepy,AnimatedBullet_type)
  --3 health for the AnimatedBullet
  self._AnimatedBullet_type=AnimatedBullet_type

  self._animation = newAnimation(AnimatedBullet_type,
  					animation_tab[AnimatedBullet_type].size_x,
  					animation_tab[AnimatedBullet_type].size_y, 0.2, animation_tab[AnimatedBullet_type].n_steps)
  self._animation:setMode(animation_tab[AnimatedBullet_type].mode)
  Bullet.initialize(self,space,emmiter,x,y,stepx,stepy,animation_tab[AnimatedBullet_type].health,AnimatedBullet_type)
  
  animation_tab[AnimatedBullet_type].source:stop()
  animation_tab[AnimatedBullet_type].source:play()
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

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,
                      animation_tab[self._AnimatedBullet_type].zoom) 
end