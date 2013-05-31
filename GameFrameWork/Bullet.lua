require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'

Bullet = class('GameFrameWork.Bullet',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Bullet:initialize(space,x,y,stepx,stepy)
  self._bullet=love.graphics.newImage("Resources/red_bullet.png")
  --3 health for the bullet
  SpaceObject.initialize(self,space, self._bullet,x,y,3)
  self._xStep=stepx
  self._yStep=stepy
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
  
  x=x+self._xStep
  y=y+self._yStep

 
  SpaceObject.setPositionY(self,y)
  SpaceObject.setPositionX(self,x)
end

--im the bullet, ovewritting from SpaceObject
function Bullet:isBullet()
	return true
end