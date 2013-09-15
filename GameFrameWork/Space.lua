require 'Utils/middleclass/middleclass'
require 'Utils/Debugging'
require 'Utils/GameConfig'

Space = class('GameFrameWork.Space')

local BUCKET_SIZE=16
local SIZE_BUCKETS_X=0
local SIZE_BUCKETS_Y=0

local SCREEN_WD=love.graphics.getWidth()
local SCREEN_HT=love.graphics.getHeight()

--creates the space must create only one space for the game
function Space:initialize()
    --space implementation
    self._objectsList={}

    --collision system implementation
    self._buckets={}

    --create empty list of buckets
    
    SIZE_BUCKETS_X=(SCREEN_WD/BUCKET_SIZE)
    SIZE_BUCKETS_Y=(SCREEN_HT/BUCKET_SIZE)
     for i=0,SIZE_BUCKETS_X do
     	self._buckets[i]={}
     	for j=0,SIZE_BUCKETS_Y do
     		self._buckets[i][j]={}
     	end
     end

    --pause implementation
    self._pause=false

    --background implementation
    self._bgList={}
    self._bgSize=0
    self._bgPos=0
    self._bgActual=0
    self._bgTimingCadence=0
    self._backgroundDistance=4
    self._levelEnded=false

    Hud:new(self)
end

function Space:removeFromBuckets(so)
	--DEBUG_PRINT("removeFromBuckets")
	local bc_x=-1
	local bc_y=-1
	bc_x,bc_y=so:getBucket(so)
	local found=(bc_x~=-1 and bc_y~=-1)
	local delta_x=0
	local delta_y=0

	 if found then
	 	delta_x=math.floor(so:getWidth()/BUCKET_SIZE)
		delta_y=math.floor(so:getHeight()/BUCKET_SIZE)
	 	for i=bc_x,bc_x+delta_x do
		for j=bc_y,bc_y+delta_y do
			if i>=0 
				and i<=SIZE_BUCKETS_X 
				and j>=0
				and j<=SIZE_BUCKETS_Y then
				self._buckets[i][j][so]=nil
			end
		end
	end
	 else
		 --if not cache found, drop it all manually, no memory garbage!!
		 for i=0,SIZE_BUCKETS_X do
	 		for j=0,SIZE_BUCKETS_Y do
	 			self._buckets[i][j][so]=nil
	 		end
	 	end
	 	
	end
	so:setBucket(-1,-1)
end
function Space:updateBucketFor(so)
	--DEBUG_PRINT("updateBucketFor:"..so:toString())
	local bc_x_old=0
	local bc_y_old=0
	bc_x_old,bc_y_old=so:getBucket()

	local found=(bc_x_old~=-1 and bc_y_old~=-1)
	
	local x=so:getPositionX()
	local y=so:getPositionY()
	local bc_x_new=math.floor(x/BUCKET_SIZE)
	local bc_y_new=math.floor(y/BUCKET_SIZE)
	local delta_x=math.floor(so:getWidth()/BUCKET_SIZE)
	local delta_y=math.floor(so:getHeight()/BUCKET_SIZE)

	--do not update for disabled objects
	if not so:isEnabled() then
		return nil
	end

	--this object will die because an out of bounds
	if bc_x_new<0 or bc_y_new<0 then
		return
	end
	if bc_x_new>SIZE_BUCKETS_X or bc_y_new>SIZE_BUCKETS_Y then
		return 
	end


	if found then
		--if the bucket exists check position change
		if (bc_x_new==bc_x_old and bc_y_new==bc_y_old) then
			--nothing to do here
			return nil
		end
		self:removeFromBuckets(so)
	end

	--DEBUG_PRINT("inserting in "..bc_x_new.." "..bc_y_new)
	for i=bc_x_new,bc_x_new+delta_x do
		for j=bc_y_new,bc_y_new+delta_y do
			if i>=0 
				and i<=SIZE_BUCKETS_X 
				and j>=0
				and j<=SIZE_BUCKETS_Y then
				self._buckets[i][j][so]=true
			end
		end
	end

	so:setBucket(bc_x_new,bc_y_new)

end
function Space:addBackGroundImage(path_to_image)
	self._bgList[self._bgSize]=love.graphics.newImage(path_to_image)
	self._bgSize=self._bgSize+1
end

function Space:clearBackGroundImages()
	self._bgSize=0
end

function Space:getBackGroundWidth()
	if(self._bgSize>0) then
		return self._bgList[0]:getWidth()
	else
		return 0
	end
end

function Space:getBackGroundHeight()
	if(self._bgSize>0) then
		return self._bgList[0]:getHeight()
	else
		return 0
	end
end

--returns the x axis position that makes background to
--move
function Space:getPlayerBackGroundScroll()
	return (self:getBackGroundWidth()/4)
end
--adds a new SpaceObject to the space
function Space:addSpaceObject(object)
	--DEBUG_PRINT("addSpaceObject")
	self._objectsList[object]=true
	self:updateBucketFor(object)
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
	--DEBUG_PRINT("removeSpaceObject")
	self:removeFromBuckets(object)
	self._objectsList[object]=nil

end

--checks if so is x inbounds in the map, so can appear in the future
function Space:isObjectEnabled(so)
	--DEBUG_PRINT("isObjectEnabled")
	local x=so:getPositionX()
	if x>=self:getXinit() and x<=self:getXend() then
		return true
	else
		return false
	end
end

local _printBackground=function(self)

   local size=self:getBackGroundWidth()
   love.graphics.draw(self._bgList[self._bgActual], self._bgPos, 0) -- this is the left image
   love.graphics.draw(self._bgList[(self._bgActual+1)%self._bgSize],self._bgPos
    								+ size, 0) -- this is the right image

end

function Space:getBackGroundCadence()
	return self._bgTimingCadence
end

local _getBackGroundTimingCadence=function(self)


	local player=self:getPlayerShip()
	local delta_x=player:getPositionX()-self:getPlayerBackGroundScroll()
	local timingCadence=0


	if player==nil or player:getPositionX()<=self:getPlayerBackGroundScroll() then
		return 0
	end
 --  	-- scrolling the posX to the left
  	if delta_x<=50 then
		timingCadence=0.5
	elseif delta_x<=120 then
		timingCadence=0.8
	elseif delta_x<=230 then
		timingCadence=1
	else
		timingCadence=1.7
	end
	return timingCadence
end

--returs if the actual level is ended
function Space:isLevelEnded()
	return self._levelEnded
end

local _updateBackGround=function(self,dt)
	local step=100*dt/self._backgroundDistance
	local size=self:getBackGroundWidth()
	local player=self:getPlayerShip()
	local delta_x=0
	local player_x=0
	local aux_x=0
	local aux_y=0


	-- if (self._pause) then
	-- 	return nil
	-- end

	if player~=nil 
      and player:getPositionX()>=self:getPlayerBackGroundScroll() then

    	self._bgPos=self._bgPos-self._bgTimingCadence*step

      	player_x=player:getPositionX()
    	--DEBUG_PRINT("translating "..self._bgActual*(-800)+self._bgPos.."\n")
    	
	end

    if self._bgPos*-1 > self:getBackGroundWidth() then
      self._bgPos = 0
      self._bgActual=(self._bgActual+1)
      if(self._bgActual>=self._bgSize-1) then
      	self._levelEnded=true
      end  
      self._bgActual=self._bgActual%self._bgSize
    end

  	
	self._bgTimingCadence=_getBackGroundTimingCadence(self)

	--actualize disabled object
	for obj,_ in pairs(self._objectsList) do
		if not obj:isEnabled() then
			obj:setEnabled(self:isObjectEnabled(obj))
		end
	end

end

--draws all the objects in the space
function Space:draw()

	local player=self:getPlayerShip()
	local step_bg=1
	local n_bgs=4
	local dst=0
 	_printBackground(self)

	if(self._pause) then
		love.graphics.setColor(255,0,0,255)
        love.graphics.print("PAUSE",100,100)
        love.graphics.setColor(255,255,255,255)
	end
 	
 -- 	if player:getPositionX()>=self:getPlayerBackGroundScroll() then
	--  		love.graphics.translate(self._bgPos, 0)
	-- end
	for plane=n_bgs,0,-1 do
		dst=plane*step_bg
		for obj,_ in pairs(self._objectsList) do
			if obj:isEnabled() and obj:getBackGroundDistance()==dst then
				obj:draw()
			end
		end
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

	--objects in diferent planes do not collide
	if(soA:getBackGroundDistance()~=soB:getBackGroundDistance()) then
		return false
	end

	--nothing can hit an explosion
	if soA:isExplosion() or soB:isExplosion() then
		return false
	end


	--bullets do not collide
	if soA:isBullet() and soB:isBullet() then
		return false
	end
	
	--harvestables do not collide
	if soA:isHarvestableObject() and soB:isHarvestableObject() then
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

	--bullets do not hit harvestables
	if soA:isBullet() and soB:isHarvestableObject() then
		return false
	end
	
	if soB:isBullet() and soA:isHarvestableObject() then
		return false
	end

	--enemies cant hit harvestables
	if soA:isEnemyShip() and soB:isHarvestableObject() then
		return false
	end
	
	if soB:isEnemyShip() and soA:isHarvestableObject() then
		return false
	end

	--tiles cant hit tiles
	if soA:isTileBlock() and soB:isTileBlock() then
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
function Space:naturalCollisionCheck(soA,soB)

	--objects in diferent planes do not collide
	if(soA:getBackGroundDistance()~=soB:getBackGroundDistance()) then
		return false
	end

	--nothing can hit an explosion
	if soA:isExplosion() or soB:isExplosion() then
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

	_updateBackGround(self,dt)


	--pilot all the objects

	for obj,k in pairs(self._objectsList) do
		obj:pilot(dt)
	end



	--new collision system based in spacial hashing and buckets

	 for i=0,SIZE_BUCKETS_X do
	 	for j=0,SIZE_BUCKETS_Y do
	 		for soA,kk in pairs(self._buckets[i][j]) do
	 			if soA:isEnabled() then
		 			for soB,ku in pairs(self._buckets[i][j]) do
		 				if soB:isEnabled() then
		     				if soA~=soB then
			 					collision_array[{A=soA,B=soB}]=_collisionCheck(self,soA,soB)
		     				end
	     				end
		 			end
	 			end
		 	end
		end
	end

	--perform collision hits
	for obj,__ in pairs(collision_array) do
		if __ then
			soA=obj.A
			soB=obj.B
			if self:exists(soA) and self:exists(soB) then
				_collisionManagement(self,soA,soB)
			end
	    end
		--in other case soA or soB is dead
	end

end

function Space:readPressed()
	local i=0
	local j=0
	if (GameConfig.getInstance():isDownPause()) then
		self._pause= not self._pause
	end

	if(self._pause) then
		return
	end

	for obj,_ in pairs(self._objectsList) do
		obj:readPressed()
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
			so:setPosition(x,y)

			collision_free=true

			for obj,_ in pairs(self._objectsList) do
				if(not collision_free) then
					break
				end
				if(so~=obj) then
					collision_free=collision_free and not self:naturalCollisionCheck(so,obj)
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

function Space:getAllTileBlocks()
	local all_tiles={}
	for obj,_ in pairs(self._objectsList) do
		if obj:isTileBlock() then
			all_tiles[obj]=true
		end
	end
	return all_tiles
end

function Space:getNumObjects()
	local count=0
	for obj,_ in pairs(self._objectsList) do
		count=count+1
	end
	return count
end

function Space:getNumBucketObjects()
	local count=0
	for i=0,SIZE_BUCKETS_X do
	 	for j=0,SIZE_BUCKETS_Y do
	 		for soA,kk in pairs(self._buckets[i][j]) do
	 			count=count+1
	 		end
	 	end
	 end
	 return count
end

