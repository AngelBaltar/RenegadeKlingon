-- /* RenegadeKlingon - LÖVE2D GAME
--  * SpaceObject.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */
require 'GameFrameWork/Space'
require 'Utils/GameConfig'

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
  self._bucket_x=-1
  self._bucket_y=-1
  self._backgroundDistance=1
  self._isEnabled=space:isObjectEnabled(self)
  self._dead=false
  self._shielddraw=0
  space:addSpaceObject(self)
end

function SpaceObject:isEnabled()
	return self._isEnabled
end

function SpaceObject:setEnabled(e)
	self._isEnabled=e
end

--Performs movements changing the position of the object, firing bullets...
function SpaceObject:pilot(dt)
   local step=100*dt/self:getBackGroundDistance()
   local my_space=self:getSpace()
   local x=self:getPositionX()
   local y=self:getPositionY()
   x=x-my_space:getBackGroundCadence()*step
   self:setPosition(x,y)
end

--Draws the object in the screen
function SpaceObject:draw()
	if(self:isPlayerShip() or self:isEnemyShip() or self:isPlayerDummy()) then
		local shieldstep=2
	    if(self._shielddraw>shieldstep) then
	      local r,g,b=self:getShipColor()
	      love.graphics.setColor(r,g,b,self._shielddraw)
	      love.graphics.circle( "fill", self:getPositionX()+self:getWidth()/2, self:getPositionY()+self:getHeight()/2, self:getStimatedSize()/2, 700 )
	      love.graphics.setColor(255,255,255,255)
	      self._shielddraw=self._shielddraw-shieldstep
	    else
	      self._shielddraw=0
	    end
	end
	sx,sy=GameConfig.getInstance():getScale()
	love.graphics.draw(self._toDraw, self._xPos, self._yPos,0,sx,sy)
end

--Read from keyboard
function SpaceObject:readPressed()
end

function SpaceObject:die()

	self._space:removeSpaceObject(self)
	self:setEnabled(false)
	self._dead=true
end

--returns the X component of the position for this object
function SpaceObject:getPositionX()
	return self._xPos
end

--returns the Y component of the position for this object
function SpaceObject:getPositionY()
	return self._yPos
end

function SpaceObject:setPosition(x,y)
	local x_inf=self._space:getXinit()
	local x_sup=self._space:getXend()
	local x_old=self._xPos
	local y_inf=self._space:getYinit()
	local y_sup=self._space:getYend()
	local y_old=self._yPos
	self._yPos=y
	self._xPos=x
	if(x+self:getWidth()<x_inf) or (x>x_sup)
		or (y<y_inf) or (y-self:getHeight()>y_sup) then
		if self:isEnabled() then
			self:die()
		end
	else
		if x_old~=x or y_old~=y then
			if(self:isEnabled()) then
				self._space:updateBucketFor(self)
			end
		end
	end

end

function SpaceObject:getWidth()
	local ship=SpaceObject.getDrawableObject(self)
	sx,sy=GameConfig.getInstance():getScale()
	if ship~=nil then
		return ship:getWidth()*sx
	else
		return 0
	end
end

function SpaceObject:getHeight()
	local ship=SpaceObject.getDrawableObject(self)
	sx,sy=GameConfig.getInstance():getScale()
	if ship~=nil then
		return ship:getHeight()*sy
	else
		return 0
	end
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
	local my_space=self:getSpace()
	local player=my_space:getPlayerShip()
	local hud=my_space:getHud()
	local emmiter=nil
	if(object:isBullet()) then
		emmiter=object:getEmmiter()
		damage=damage*((emmiter:getWeaponPower()/emmiter:getTotalPower())+1)
	end
	if(damage>0) then
		--apply shield only on positive damages
		damage=damage-damage*(self:getShieldPower()/(self:getTotalPower()+1))
		self._shielddraw=255*(self:getShieldPower()/self:getTotalPower())
	end
	self:setHealth(self:getHealth()-damage)
	if(object:isBullet() and emmiter==player) then
		hud:addToScore(damage)
		hud:setEnemy(self)
	end
	--DEBUG_PRINT("space COLLIDING WITH DAMAGE "..damage.."\n")
end

--returns the space where this object is
function SpaceObject:getSpace()
	return self._space
end

function SpaceObject:getBucket()
	return self._bucket_x,self._bucket_y
end

function SpaceObject:setBucket(x,y)
	self._bucket_x=x
	self._bucket_y=y
end

function SpaceObject:getBackGroundDistance()
	return self._backgroundDistance
end

function SpaceObject:setBackGroundDistance(bd)
	self._backgroundDistance=bd
	--update the bucket on switching between planes
	self._space:updateBucketFor(self)
end

function SpaceObject:getTotalPower()
	return 10
end

--gets the object power on weapons
function SpaceObject:getWeaponPower()
	return 10
end

--gets the object power on shields
function SpaceObject:getShieldPower()
	return 0
end

function SpaceObject:getShipColor()
	return 255,255,255
end

function SpaceObject:toString()
	return "spaceobject"
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

function SpaceObject:isTextMessage()
	return false
end

function SpaceObject:isMusicObject()
  return false
end

function SpaceObject:isPlayerDummy()
  return false
end

function SpaceObject:isDead()
	return self._dead
end