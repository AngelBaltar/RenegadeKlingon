require 'Utils/Debugging'

GameConfig = class('GameFrameWork.GameConfig')

local _instance=nil
--constructor

local __initialize = function(self)
	self._joypadOn=false
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyRight="right"
	self._keyFire="a"
	self._keyPause="p"
	self._keyEnter="return"
	self._keyEscape="escape"
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

function GameConfig:setKeyPause(keyPause)
	self._keyPause=keyPause
end

function GameConfig:setKeyEnter(keyEnter)
	self._keyEnter=keyEnter
end

function GameConfig:setKeyEscape(keyEscape)
	self._keyEscape=keyEscape
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

function GameConfig:getKeyPause()
	return self._keyPause
end

function GameConfig:getKeyEnter()
	return self._keyEnter
end

function GameConfig:getKeyEscape()
	return self._keyEscape
end


function GameConfig:isDownUp()
	return love.keyboard.isDown(self._keyUp)
end

function GameConfig:isDownDown()
	return love.keyboard.isDown(self._keyDown)
end

function GameConfig:isDownRight()
	return love.keyboard.isDown(self._keyRight)
end

function GameConfig:isDownLeft()
	return love.keyboard.isDown(self._keyLeft)
end

function GameConfig:isDownFire()
	return love.keyboard.isDown(self._keyFire)
end

function GameConfig:isDownPause()
	return love.keyboard.isDown(self._keyPause)
end

function GameConfig:isDownEnter()
	return love.keyboard.isDown(self._keyEnter)
end

function GameConfig:isDownEscape()
	return love.keyboard.isDown(self._keyEscape)
end