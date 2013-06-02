require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Explosion'

Bullet = class('GameFrameWork.Bullet',SpaceObject)



--ps:setColor(255,255,255,255,255,255,255,0)
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Bullet:initialize(space,x,y,stepx,stepy)
  local bullet=love.graphics.newImage("Resources/red_bullet.png")
  --3 health for the bullet
  SpaceObject.initialize(self,space,bullet,x,y,3)
  self._xStep=stepx
  self._yStep=stepy
  self._enabled=true

end


function Bullet:die()
  local my_space=SpaceObject.getSpace(self)
  local x=SpaceObject.getPositionX(self)
  local y=SpaceObject.getPositionY(self)
  
  --it only causes explosion if dies because a collision
  --no by out of bounds
  if my_space:isInBounds(self) then
    Explosion:new(my_space,x,y)
  end
  
  SpaceObject.die(self)
end


--return the width of this ship
function Bullet:getWidth()
  bullet=SpaceObject.getDrawableObject(self)
	return bullet:getWidth()
end

--return the height of this ship
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

--im the bullet, ovewritting from SpaceObject
function Bullet:isBullet()
	return true
end