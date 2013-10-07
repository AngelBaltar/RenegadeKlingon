require 'Utils/middleclass/middleclass'

PilotPattern = class('GameFrameWork.PilotPatterns.PilotPattern')

--constructor
function PilotPattern:initialize(ship)
    self._ship=ship
end

function PilotPattern:pilot(dt)

end

function PilotPattern:setShip(ship)
	self._ship=ship
end

function PilotPattern:getShip()
	return self._ship
end