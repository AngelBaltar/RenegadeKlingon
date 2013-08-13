require 'Utils/middleclass/middleclass'

Screen = class('Screen')


function Screen:initialize()
  
end

function Screen:draw()
end

function Screen:update(dt)

end

function Screen:readPressed()
end

function Screen.static:getExitMark()
	return -10
end