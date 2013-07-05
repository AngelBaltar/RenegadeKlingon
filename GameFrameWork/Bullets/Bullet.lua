require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Explosions/ParticleExplosion'


Bullet = class('GameFrameWork.Bullet',SpaceObject)


--constructor
function Bullet:initialize(space,emmiter,x,y,stepx,stepy,health,drawable)
  --3 health for the bullet
  SpaceObject.initialize(self,space,drawable,x,y,health)
  self._xStep=stepx
  self._yStep=stepy
  self._emmiter=emmiter

end


function Bullet:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  if my_space:isInBounds(self) then
    ParticleExplosion:new(my_space,x,y,0.25,"Resources/gfx/fire.png")
  end
  
  SpaceObject.die(self)
end

function Bullet:collision(object,damage)
  --avoid bullet with bullet collisions
  if(not object:isBullet()) 
    and not( object:isEnemyShip() and self._emmiter:isEnemyShip())
    and not( object:isPlayerShip() and self._emmiter:isPlayerShip())
    and not (object:isHarvestableObject()) then
    SpaceObject.collision(self,object,damage)
  end
end

--Performs movements changing the position of the object, firing bullets...
function Bullet:pilot(dt)
  SpaceObject.pilot(self,dt)
  if not self:isEnabled() then
    return nil
  end
  
  local global_step=70*dt
  local x=self:getPositionX(self)
  local y=self:getPositionY(self)
  local my_space=self:getSpace()

  x=x+self._xStep*global_step
  if(self._xStep<0) then
    x=x-my_space:getBackGroundCadence()
  end
  y=y+self._yStep*global_step

 
  self:setPosition(x,y)

end

function Bullet:getEmmiter()
  return self._emmiter
end

--im the bullet, ovewritting from SpaceObject
function Bullet:isBullet()
	return true
end

function Bullet:toString()
  return "Bullet"
end