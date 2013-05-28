require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'

PlayerShip = class('GameFrameWork.PlayerShip',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function PlayerShip:initialize()
  self._ship=love.graphics.newImage("Resources/destructor_klingon.png")
  SpaceObject.initialize(self, self._ship,0,0)
end

--return the width of this ship
function PlayerShip:getWidth()
	return self._ship:getWidth()
end

--return the height of this ship
function PlayerShip:getHeight()
	return self._ship:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function PlayerShip:pilot()
  local step=5
  if love.keyboard.isDown("up") then
		if(SpaceObject.getPositionY(self)>0)then
			SpaceObject.setPositionY(self,SpaceObject.getPositionY(self)-step)
		end
   end
  if love.keyboard.isDown("down") then
		if(SpaceObject.getPositionY(self)<love.graphics.getHeight()-self:getHeight())then
			SpaceObject.setPositionY(self,SpaceObject.getPositionY(self)+step)
		end
   end

   if love.keyboard.isDown("left") then
    if(SpaceObject.getPositionX(self)>0)then
			SpaceObject.setPositionX(self,SpaceObject.getPositionX(self)-step)
		end
   end
  if love.keyboard.isDown("right") then
    if(SpaceObject.getPositionX(self)<love.graphics.getWidth()-self:getWidth())then
			SpaceObject.setPositionX(self,SpaceObject.getPositionX(self)+step)
		end
   end
end

--im the player, ovewritting from SpaceObject
function PlayerShip:isPlayerShip()
	return true
end
