require 'Utils/Debugging'

GameConfig = class('GameFrameWork.GameConfig')

GameConfig.static._instance =nil
--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object

local __initialize = function(self)
	self._keyboardOn=true
	self._joypadOn=false
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyright="right"
	self._keyFire="a"
end

--return the width of this ship
function GameConfig.getInstance()
  if GameConfig.static._instance==nil then
  	GameConfig.static._instance=GameConfig:new()
  	__initialize(GameConfig.static._instance)
  end
  return GameConfig.static._instance
end

function GameConfig:isDownUp()
	if(self._keyboardOn) then
		return love.keyboard.isDown(self._keyUp)
	end
	return false
end

function GameConfig:isDownDown()
	if(self._keyboardOn) then
		return love.keyboard.isDown(self._keyDown)
	end
	return false
end

function GameConfig:isDownRight()
	if(self._keyboardOn) then
		return love.keyboard.isDown(self._keyright)
	end
	return false
end

function GameConfig:isDownLeft()
	if(self._keyboardOn) then
		return love.keyboard.isDown(self._keyLeft)
	end
	return false
end

function GameConfig:isDownFire()
	if(self._keyboardOn) then
		return love.keyboard.isDown(self._keyFire)
	end
	return false
end