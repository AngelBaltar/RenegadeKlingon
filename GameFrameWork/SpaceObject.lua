require 'middleclass/middleclass'

SpaceObject = class('GameFrameWork.SpaceObject')

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function SpaceObject:initialize(space,draw_object,posx,posy,life)
  self._toDraw=draw_object
  self._xPos=posx
  self._yPos=posy
  self._space=space
  self._life=life
  space:addSpaceObject(self)
end

--Performs movements changing the position of the object, firing bullets...
function SpaceObject:pilot(dt)

end

--Draws the object in the screen
function SpaceObject:draw()
	love.graphics.setColor(255,255,255,255)
   	love.graphics.setBackgroundColor(0,0,0)
   	love.graphics.draw(self._toDraw, self._xPos, self._yPos)
end

--Read from keyboard
function SpaceObject:keypressed(key, unicode)
end

function SpaceObject:die()

	self._space:removeSpaceObject(self)
	-- if self:isPlayerShip() then
	-- 	pp=pp+1
	-- end
end

--returns the X component of the position for this object
function SpaceObject:getPositionX()
	return self._xPos
end

--returns the Y component of the position for this object
function SpaceObject:getPositionY()
	return self._yPos
end

--sets the X coordenate
function SpaceObject:setPositionX(x)
	self._xPos=x
	if(x<0) or (x>love.graphics.getWidth()) then
		self:die()
	end
end

--sets the Y coordenate
function SpaceObject:setPositionY(y)
	self._yPos=y
	if(y<0) or (y>love.graphics.getHeight()) then
		self:die()
	end
end

--must be implemented in subclasses
function SpaceObject:getWidth()

end

--must be implemented in subclasses
function SpaceObject:getHeight()

end

function SpaceObject:getLife()
	return self._life;
end

function SpaceObject:setLife(life)
	self._life=life;
	if(life<=0) then
		self:die()
	end
end

function SpaceObject:collision(object)

end

--returns the space where this object is
function SpaceObject:getSpace()
	return self._space
end

--the PlayerShip class must extend this class and overwritte this method returning true
function SpaceObject:isPlayerShip()
	return false
end


--the Bullet class must extend this class and overwritte this method returning true
function SpaceObject:isBullet()
	return false
end


--the EnemyShip class must extend this class and overwritte this method returning true
function SpaceObject:isEnemyShip()
	return false
end

--im the Hud, ovewritting from SpaceObject
function SpaceObject:isHud()
	return false
end