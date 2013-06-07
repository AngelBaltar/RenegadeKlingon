require 'middleclass/middleclass'

Space = class('GameFrameWork.Space')

--creates the space must create only one space for the game
function Space:initialize()
    self._objectsList={}
    self._pause=false
end

--adds a new SpaceObject to the space
function Space:addSpaceObject(object)
	self._objectsList[object]=true
end

function Space:exists(so)
	local pos=0
	local found=false
	for obj,_ in pairs(self._objectsList) do
		if(obj==so) then
			return true
		end
	end
	return false
end
--removes a object from the space
function Space:removeSpaceObject(object)
	self._objectsList[object]=nil
end

--draws all the objects in the space
function Space:draw()
	local i=0

	if(self._pause) then
		love.graphics.setColor(255,0,0,255)
        love.graphics.print("PAUSE",100,100)
	end

	for obj,_ in pairs(self._objectsList) do
		obj:draw()
		i=i+1
	end
end

--checks a collision between space object A and B
local _collisionCheck = function(self,soA,soB)
	local x1A = soA:getPositionX()
	local x2A = soA:getWidth()+x1A
	local y1A = soA:getPositionY()
	local y2A = soA:getHeight()+y1A

	local x1B = soB:getPositionX()
	local x2B = soB:getWidth()+x1B
	local y1B = soB:getPositionY()
	local y2B = soB:getHeight()+y1B

	local X_contained=(( x1B>=x1A and x1B<=x2A ) or (x2B>=x1A and x2B<=x2A) ) or (( x1A>=x1B and x1A<=x2B ) or (x2A>=x1B and x2A<=x2B) )
	local Y_contained=(( y1B>=y1A and y1B<=y2A ) or (y2B>=y1A and y2B<=y2A) ) or (( y1A>=y1B and y1A<=y2B ) or (y2A>=y1B and y2A<=y2B) )

	if(soA==soB) then
		return false
	end

	return X_contained and Y_contained
end

--checks and handles a collision between space object A and B
local _collisionManagement = function(self,soA,soB) 

	local healthA=soA:getHealth()
	local healthB=soB:getHealth()
	soA:collision(soB,healthB)
	soB:collision(soA,healthA)
end

--updates the space, call all objects method pilot so they can move shoot...
function Space:update(dt)
	local collision_array={}

	--check game paused
	if(self._pause) then
		return
	end

	--pilot all the objects
	for obj,k in pairs(self._objectsList) do
		obj:pilot(dt)
	end

	--check collisions between objects
	--annotate collisions
	for soA,k in pairs(self._objectsList) do
		for soB,h in pairs(self._objectsList) do
			if _collisionCheck(self,soA,soB) then
				collision_array[{A=soA,B=soB}]=true
			end
		end
	end

	--perform collision hits
	for obj,__ in pairs(collision_array) do
		soA=obj.A
		soB=obj.B
		if self:exists(soA) and self:exists(soB) then
			_collisionManagement(self,soA,soB)
		end
		--in other case soA or soB is dead
	end

end

function Space:keypressed(key, unicode)
	local i=0
	local j=0
	if (key=="p") then
		self._pause= not self._pause
	end

	if(self._pause) then
		return
	end

	for obj,_ in pairs(self._objectsList) do
		obj:keypressed(key,unicode)
		i=i+1
	end
end

function Space:getPlayerShip()
	local i=0
	for obj,_ in pairs(self._objectsList) do
		if obj:isPlayerShip() then
			return obj
		end
		i=i+1
	end
	return nil
end

function Space:getXinit()
	return 0
end

function Space:getXend()
	return love.graphics.getWidth()
end

function Space:getYinit()
	local i=0
	local hud=nil
	local hud_found=false
	
	for obj,_ in pairs(self._objectsList) do	
		if(obj:isHud()) then
			hud_found=true
			hud=obj
			break
		else
			i=i+1
		end
	end
	if(hud_found) then
		return hud:getHeight()
	else
		return 0
	end
end

function Space:getYend()
	return love.graphics.getHeight()
end

--places the object so in a place free of other space Objects
function Space:placeOnfreeSpace(so)
	local i=0
	local x=self:getXend()/2
	local y=self:getYinit()
	local step=7
	local collision_free=true

	while(x < self:getXend()) do
		y=self:getYinit()

		while (y<self:getYend()) do
			so:setPositionX(x)
			so:setPositionY(y)
			i=0
			collision_free=true
			--while(i<self._insertAt and collision_free) do
			for obj,_ in pairs(self._objectsList) do
				if(not collision_free) then
					break;
				end
				if(so~=obj) then
					collision_free=collision_free and not _collisionCheck(self,so,obj)
				end
				i=i+1
			end
			if(collision_free) then
				print("placing in x= "..x.." y= "..y.."\n")
				return true
			end
			y=y+step
		end
		x=x+step
	end
	print("cant place anywhere")
	return false
end

--returns true if the object so is in the area of play, else will return false
function Space:isInBounds(so)
	local inf_y=self:getYinit()
	local sup_y=self:getYend()
	local inf_x=self:getXinit()
	local sup_x=self:getXend()

	local x=so:getPositionX()
	local y=so:getPositionY()

	local inbounds_x= x<sup_x and x>inf_x
	local inbounds_y= y<sup_y and y>inf_y

	return inbounds_x and inbounds_y
end