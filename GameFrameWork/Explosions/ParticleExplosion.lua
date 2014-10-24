require 'GameFrameWork/Explosions/Explosion'
require 'Utils/GameConfig'

ParticleExplosion = class('GameFrameWork.Explosions.ParticleExplosion',Explosion)
local source=love.audio.newSource( 'Resources/sfx/particle_explosion.mp3',"static")


--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function ParticleExplosion:initialize(space,x,y,intensity,particle_path)
  
  local particle = love.graphics.newImage(particle_path)
  particle:setFilter("nearest","nearest")

  local ps = love.graphics.newParticleSystem(particle, 5000)
  ps:stop()
  ps:setEmissionRate(500)
  ps:setEmitterLifetime(intensity)
  ps:setParticleLifetime(1)
  ps:setSpread(2*3.1415)
  ps:setRadialAcceleration(-25)
  ps:setSpeed(10, 150)
  ps:setPosition(x, y)
  ps:setDirection(1)
  ps:setLinearAcceleration(20,20,20,20)
  ps:setSpin(0, 3.1415, 0.5)
  SpaceObject.initialize(self,space,ps,x,y,0)
  Explosion.initialize(self,space,0,0,ps)
  ps:start()
  source:stop()
  source:play()

end

--Performs movements changing the position of the object, firing ParticleExplosions...
function ParticleExplosion:pilot(dt)

  local ps=SpaceObject.getDrawableObject(self)
  ps:update(dt)
  if not ps:isActive() then --my function is over, lets die
    self:die()
  end

end

function ParticleExplosion:draw()
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  --scale factor can not be aplied to particles
  love.graphics.draw(SpaceObject.getDrawableObject(self), x, y)
end