require 'Utils/middleclass/middleclass'
require 'Utils/GameConfig'

Screen = class('Screen')


function Screen:initialize()
	self._status=0
	 self._read_cadence=0.02
  self._last_read=os.clock()
end

function Screen:draw()
end

function Screen:update(dt)
	--monitorice joystick axis, must be in update call
	local pad=GameConfig.getInstance():getActiveJoyPad()
	local direction1 = love.joystick.getAxis(pad, 2 )
	local direction2 = love.joystick.getAxis(pad, 1 )
	if(os.clock()-self._last_read>self._read_cadence) then
		self._last_read=os.clock()
		if(direction1~=0 or direction2~=0) and self._status==0 then
			self._status=1
			self:readPressed()
		else
			self._status=0
		end
	end
end

function Screen:readPressed()
end

function Screen.static:getExitMark()
	return -10
end