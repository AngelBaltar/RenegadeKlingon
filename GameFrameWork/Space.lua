require 'middleclass/middleclass'

Space = class('GameFrameWork.Space')

--creates the space must create only one space for the game
function Space:initialize()
    self._insertAt=0
    self._objectsList={}
    self._pause=false
end

--adds a new SpaceObject to the space
function Space:addSpaceObject(object)
	self._objectsList[self._insertAt]=object
	self._insertAt=self._insertAt+1
end

--removes a object from the space
function Space:removeSpaceObject(object)

	local pos=0
	local found=false
	while ((not found) and (pos<self._insertAt)) do

		if(self._objectsList[pos]==object) then
			found=true
		else
			pos=pos+1
		end
	end

	if(found) then
		table.remove(self._objectsList,pos)
		self._insertAt=self._insertAt-1
	end
end

--draws all the objects in the space
function Space:draw()
	local i=0

	if(self._pause) then
		love.graphics.setColor(255,0,0,255)
        love.graphics.print("PAUSE",100,100)
	end

	while(i<self._insertAt) do

		self._objectsList[i]:draw()
		i=i+1
	end
end

local _collisionManagement = function(self,soA,soB) 
	local x1A = soA:getPositionX()
	local x2A = soA:getWidth()+x1A
	local y1A = soA:getPositionY()
	local y2A = soA:getHeight()+y1A

	local x1B = soB:getPositionX()
	local x2B = soB:getWidth()+x1B
	local y1B = soB:getPositionY()
	local y2B = soB:getHeight()+y1B

	local X_contained=(( x1B>x1A and x1B<x2A ) or (x2B>x1A and x2B<x2A) ) or (( x1A>x1B and x1A<x2B ) or (x2A>x1B and x2A<x2B) )
	local Y_contained=(( y1B>y1A and y1B<y2A ) or (y2B>y1A and y2B<y2A) ) or (( y1A>y1B and y1A<y2B ) or (y2A>y1B and y2A<y2B) )

	local lifeA=soA:getLife()
	local lifeB=soB:getLife()
	if(X_contained and Y_contained) then
			soA:collision(soB)
			soB:collision(soA)
			soA:setLife(lifeA-lifeB)
			soB:setLife(lifeB-lifeA)
	end

end

--updates the space, call all objects method pilot so they can move shoot...
function Space:update(dt)
	local i=0
	local j=0

	--check game paused
	if(self._pause) then
		return
	end

	--pilot all the objects
	while(i<self._insertAt) do
		self._objectsList[i]:pilot(dt)
		i=i+1
	end

	--check collisions between objects
	i=0
	j=0
	while(i<self._insertAt) do
		soA=self._objectsList[i]
		j=i+1
		while(j<self._insertAt) do
			soB=self._objectsList[j]
			_collisionManagement(self,soA,soB)
			j=j+1
		end
		i=i+1
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

	while(i<self._insertAt) do
		self._objectsList[i]:keypressed(key,unicode)
		i=i+1
	end
end

function Space:getPlayerShip()
	local i=0
	while(i<self._insertAt) do
		if self._objectsList[i]:isPlayerShip() then
			return self._objectsList[i]
		end
		i=i+1
	end
	return nil
end