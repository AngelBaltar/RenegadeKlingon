require 'GameFrameWork/Space'

SpaceObject = class('GameFrameWork.SpaceObject')

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function SpaceObject:initialize(space,draw_object,posx,posy,health)
  self._toDraw=draw_object
  self._space=space
  self._health=health
  self._xPos=posx
  self._yPos=posy
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
	local x_inf=self._space:getXinit()
	local x_sup=self._space:getXend()
	local x_old=self._xPos
	self._xPos=x
	if(x<x_inf) or (x>x_sup) then
		self:die()
	else
		if x_old~=x then
			self._space:updateBucketFor(self)
		end
	end

end

--sets the Y coordenate
function SpaceObject:setPositionY(y)
	local y_inf=self._space:getYinit()
	local y_sup=self._space:getYend()
	local y_old=self._yPos
	self._yPos=y
	if(y<y_inf) or (y>y_sup) then
		self:die()
	else
		if y~=y_old then
			self._space:updateBucketFor(self)
		end
	end
end

--must be implemented in subclasses
function SpaceObject:getWidth()

end

--must be implemented in subclasses
function SpaceObject:getHeight()

end

--gets the stimated size of the object to get an idea how big it is
function SpaceObject:getStimatedSize()
	local w=self:getWidth()
	local h=self:getHeight()
	return math.sqrt(w*w+h*h)
end

function SpaceObject:getHealth()
	return self._health;
end

function SpaceObject:setHealth(health)
	self._health=health;
	if(health<=0) then
		self:die()
	end
end

--gets the drawable object
function SpaceObject:getDrawableObject()
	return self._toDraw;
end

function SpaceObject:collision(object,damage)
	self:setHealth(self:getHealth()-damage)
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

function SpaceObject:isHud()
	return false
end

function SpaceObject:isExplosion()
	return false
end

function SpaceObject:isHarvestableObject()
	return false
end

function SpaceObject:isTileBlock()
	return false
end