require 'Utils/Debugging'

GameConfig = class('GameFrameWork.GameConfig')

local _instance=nil
--constructor

local __initialize = function(self)
	self._keyboardOn=true
	self._joypadOn=false
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyRight="right"
	self._keyFire="a"
end

--return the width of this ship
function GameConfig.getInstance()
  if _instance==nil then
  	_instance=GameConfig:new()
  	__initialize(_instance)
  end
  return _instance
end

function GameConfig:setKeyUp(keyUp)
	self._keyUp=keyUp
end


function GameConfig:setKeyDown(keyDown)
	self._keyDown=keyDown
end


function GameConfig:setKeyRight(keyRight)
	self._keyRight=keyRight
end


function GameConfig:setKeyLeft(keyLeft)
	self._keyLeft=keyLeft
end


function GameConfig:setKeyFire(keyFire)
	self._keyFire=keyFire
end



function GameConfig:getKeyUp()
	return self._keyUp
end


function GameConfig:getKeyDown()
	return self._keyDown
end


function GameConfig:getKeyRight()
	return self._keyRight
end


function GameConfig:getKeyLeft()
	return self._keyLeft
end


function GameConfig:getKeyFire()
	return self._keyFire
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
		return love.keyboard.isDown(self._keyRight)
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