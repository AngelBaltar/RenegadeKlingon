require 'middleclass/middleclass'
require 'Utils/Debugging'

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

	if(self._pause) then
		love.graphics.setColor(255,0,0,255)
        love.graphics.DEBUG_PRINT("PAUSE",100,100)
	end

	for obj,_ in pairs(self._objectsList) do
		obj:draw()
	end
end

function Space:getDistance(soA,soB)
	xa=soA:getPositionX()
	ya=soA:getPositionY()

	xb=soB:getPositionX()
	yb=soB:getPositionY()

    ct1=(xa-xb)
    ct2=(ya-yb)
	return math.sqrt(ct1*ct1+ct2*ct2)
end

--checks a collision between space object A and B
local _collisionCheck = function(self,soA,soB)
	
	--some of this checks are implemented in subclasses method collision
	--but returning false here we get more performance

	--bullets do not collide
	if soA:isBullet() and soB:isBullet() then
		return false
	end

	--two enemies do not collide
	if soA:isEnemyShip() and soB:isEnemyShip() then
		return false
	end

	--enemy bullets do not hit enemies
	if soA:isBullet() and soB:isEnemyShip() and soA:getEmmiter():isEnemyShip() then
		return false
	end
	
	if soB:isBullet() and soA:isEnemyShip() and soB:getEmmiter():isEnemyShip() then
		return false
	end

	--player bullets do not hit player
	if soA:isBullet() and soB:isPlayerShip() and soA:getEmmiter():isPlayerShip() then
		return false
	end


	if soB:isBullet() and soA:isPlayerShip() and soB:getEmmiter():isPlayerShip() then
		return false
	end

	if(soA==soB) then
		return false
	end

	local max_siz=0
	local sizA=soA:getStimatedSize()
	local sizB=soB:getStimatedSize()

	if(sizA>sizB) then
		max_siz=sizA
	else
		max_siz=sizB
	end

	--a previous filter to get better performance
	if(self:getDistance(soA,soB)>max_siz+10) then
		return false
	end

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


	return X_contained and Y_contained
end



--checks a collision between space object A and B
--check natural collision, enemies collide enemies...
--bullets collide bullets ...
local _naturalCollisionCheck = function(self,soA,soB)

	if(soA==soB) then
		return false
	end

	local max_siz=0
	local sizA=soA:getStimatedSize()
	local sizB=soB:getStimatedSize()

	if(sizA>sizB) then
		max_siz=sizA
	else
		max_siz=sizB
	end

	--a previous filter to get better performance
	if(self:getDistance(soA,soB)>max_siz+10) then
		return false
	end

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
	local count_extr=0
	local count_intr=0
	for soA,k in pairs(self._objectsList) do
		count_intr=0
		for soB,h in pairs(self._objectsList) do

			if(count_intr>count_extr) then
				if _collisionCheck(self,soA,soB) then
					collision_array[{A=soA,B=soB}]=true
				end
			end
			count_intr=count_intr+1
		end
		count_extr=count_extr+1
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
function Space:placeOnfreeSpace(so,init_x,end_x,init_y,end_y)

	local x=init_x
	local y=init_y
	local step=7
	local collision_free=true
    local iter_x=0
    local iter_y=0

	while(iter_x < 100) do
		x=init_x+math.random(end_x-init_x)
		iter_y=0
		while (iter_y<100) do
		    y=init_y+math.random(end_y-init_y)
			so:setPositionX(x)
			so:setPositionY(y)

			collision_free=true

			for obj,_ in pairs(self._objectsList) do
				if(not collision_free) then
					break
				end
				if(so~=obj) then
					collision_free=collision_free and not _naturalCollisionCheck(self,so,obj)
				end
			end
			if(collision_free) then
				DEBUG_PRINT("placing in x= "..x.." y= "..y.."\n")
				return true
			end
			iter_y=iter_y+1
		end
		iter_x=iter_x+1
	end
	DEBUG_PRINT("cant place anywhere")
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

function Space:getAllEnemies()
	local all_enemies={}
	for obj,_ in pairs(self._objectsList) do
		if obj:isEnemyShip() then
			all_enemies[obj]=true
		end
	end
	return all_enemies
end

function Space:getNumObjects()
	local count=0
	for obj,_ in pairs(self._objectsList) do
		count=count+1
	end
	return count
end
