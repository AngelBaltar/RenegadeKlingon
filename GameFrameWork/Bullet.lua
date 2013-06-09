require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/ParticleExplosion'


Bullet = class('GameFrameWork.Bullet',SpaceObject)

Bullet.static.BLUE_BULLET = love.graphics.newImage("Resources/gfx/blue_bullet.png")
Bullet.static.RED_BULLET =love.graphics.newImage("Resources/gfx/red_bullet.png")
--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Bullet:initialize(space,emmiter,x,y,stepx,stepy,bullet_type)
  --3 health for the bullet
  SpaceObject.initialize(self,space,bullet_type,x,y,3)
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
    and not( object:isPlayerShip() and self._emmiter:isPlayerShip()) then
    SpaceObject.collision(self,object,damage)
  end
end


--return the width of this ship
function Bullet:getWidth()
  bullet=SpaceObject.getDrawableObject(self)
	return bullet:getWidth()
end
--return the height of this shiplove.graphics.newImage("Resources/gfx/blue_bullet.png")
function Bullet:getHeight()
  bullet=SpaceObject.getDrawableObject(self)
	return bullet:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function Bullet:pilot(dt)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)

  x=x+self._xStep
  y=y+self._yStep

 
  SpaceObject.setPositionY(self,y)
  SpaceObject.setPositionX(self,x)

end

function Bullet:getEmmiter()
  return self._emmiter
end

--im the bullet, ovewritting from SpaceObject
function Bullet:isBullet()
	return true
end