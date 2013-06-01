require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'

Bullet = class('GameFrameWork.Bullet',SpaceObject)



--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Bullet:initialize(space,x,y,stepx,stepy)
  self._bullet=love.graphics.newImage("Resources/red_bullet.png")
  --3 health for the bullet
  SpaceObject.initialize(self,space, self._bullet,x,y,3)
  self._xStep=stepx
  self._yStep=stepy
  self._enabled=true

  particle = love.graphics.newImage("Resources/fire.png")
  particle:setFilter("nearest","nearest")

  self._ps = love.graphics.newParticleSystem(particle, 5000)
  self._ps:stop()
  self._ps:setEmissionRate(500)
  self._ps:setLifetime(0.25)
  self._ps:setParticleLife(1)
  self._ps:setSpread(2*3.1415)
  self._ps:setRadialAcceleration(-25)
  self._ps:setSpeed(10, 150)
  --ps:setSize(3.0)
  self._ps:setGravity(20)
  self._ps:setSpin(0, 3.1415, 0.5)

end


function Bullet:die()
  local my_space=SpaceObject.getSpace(self)

  --if i am in bounds i die becouse a collision, keep me alive but disabled
  --to get particle system work
  if(my_space:isInBounds(self)) then
    self._enabled=false;
  else
    SpaceObject.die(self)
  end
end

function Bullet:collision(object,damage)
    local my_health=self:getHealth()
    local x=self:getPositionX()
    local y=self:getPositionY()
    if(self._enabled) then
      SpaceObject.collision(self,object,damage)
       --if i will die, explode particle system
      if(damage>=my_health) then
        self._ps:setPosition(x, y)
        self._ps:setDirection(1)
        self._ps:start()
      end
    end
end

function Bullet:draw()
  if(self._enabled) then
    SpaceObject.draw(self)
  else
    love.graphics.draw(self._ps, 0, 0)
  end
end

--return the width of this ship
function Bullet:getWidth()
	return 1
end

--return the height of this ship
function Bullet:getHeight()
	return 1
end

--Performs movements changing the position of the object, firing bullets...
function Bullet:pilot(dt)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  self._ps:update(dt)
  if(self._enabled) then
    x=x+self._xStep
    y=y+self._yStep

   
    SpaceObject.setPositionY(self,y)
    SpaceObject.setPositionX(self,x)
  else
    self:setHealth(0)
    --if not enabled keep health on 0
    if not self._ps:isActive() then
        SpaceObject.die(self)--now truly kill the bullet
    end
  end
end

--im the bullet, ovewritting from SpaceObject
function Bullet:isBullet()
	return true
end