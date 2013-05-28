require 'middleclass/middleclass'

Screen = class('Screen')


function Screen:initialize()
  
end

function Screen:draw()
end

function Screen:update(dt)

end

function Screen:keypressed(key, unicode)
end

function Screen:getExitMark()
	return -10
end