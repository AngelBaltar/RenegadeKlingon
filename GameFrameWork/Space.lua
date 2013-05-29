require 'middleclass/middleclass'

Space = class('GameFrameWork.Space')

--creates the space must create only one space for the game
function Space:initialize()
    self._insertAt=0
    self._objectsList={}
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
	table.remove(self._objectsList,pos)
	
	self._insertAt=self._insertAt-1
end

--draws all the objects in the space
function Space:draw()
	local i=0
	while(i<self._insertAt) do

		self._objectsList[i]:draw()
		i=i+1
	end
end

--updates the space, call all objects method pilot so they can move shoot...
function Space:update(dt)
	local i=0
	while(i<self._insertAt) do
		self._objectsList[i]:pilot(dt)
		i=i+1
	end
end