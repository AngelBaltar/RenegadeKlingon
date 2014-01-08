require 'GameScreens/Screen'

FlowDownTextScreen = class('FlowDownTextScreen', Screen)

local config=GameConfig.getInstance()


function FlowDownTextScreen:initialize(message)
 	self:setMessage(message)
end 

function  FlowDownTextScreen:setMessage(message)
	  self._xPos=450
	  self._yPos=nil -- if depends of the font of the system, we cant do this here, will do in the first update
	  self._message=message
	  self._numLines=0
	  for i in self._message:gmatch("\n") do self._numLines=self._numLines+1 end
end

function FlowDownTextScreen:draw()
	if(self._yPos~=nil) then
	 love.graphics.setColor(255,0,0,255)
	 love.graphics.print(self._message
	 					, self._xPos, self._yPos)
	end

end

function FlowDownTextScreen:update(dt)
	font=love.graphics.getFont()
	if(self._yPos==nil) then
	 	self._yPos=(2-self._numLines)*font:getHeight()
	end
	self._yPos=self._yPos+0.5
	if(self._yPos>600) then
		self._yPos=(2-self._numLines)*font:getHeight()
	end
end

function FlowDownTextScreen:readPressed()
	if config:isDownEscape() then
		self._xPos=0
		self._yPos=0
    	return Screen:getExitMark()
   end
   return 1
end