require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'

Explosion = class('GameFrameWork.Explosion',SpaceObject)



--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Explosion:initialize(space,x,y)
  local particle = love.graphics.newImage("Resources/fire.png")
  particle:setFilter("nearest","nearest")

  local ps = love.graphics.newParticleSystem(particle, 5000)
  ps:stop()
  ps:setEmissionRate(500)
  ps:setLifetime(0.25)
  ps:setParticleLife(1)
  ps:setSpread(2*3.1415)
  ps:setRadialAcceleration(-25)
  ps:setSpeed(10, 150)
  ps:setPosition(x, y)
  ps:setDirection(1)
  ps:setGravity(20)
  ps:setSpin(0, 3.1415, 0.5)
  SpaceObject.initialize(self,space,ps,0,0,0)
  ps:start()

end

--the explosions do not collide
--overwrite it as nothing
function Explosion:collision(object,damage)

end


--return the width of this ship
function Explosion:getWidth()
	return 0
end

--return the height of this ship
function Explosion:getHeight()
	return 0
end

--Performs movements changing the position of the object, firing Explosions...
function Explosion:pilot(dt)

  local ps=SpaceObject.getDrawableObject(self)
  ps:update(dt)
  if not ps:isActive() then --my function is over, lets die
    self:die()
  end

end

--im the Explosion, ovewritting from SpaceObject
function Explosion:isExplosion()
	return true
end