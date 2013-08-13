require 'Utils/Debugging'

GameConfig = class('GameFrameWork.GameConfig')

local _instance=nil
--constructor

local __initialize = function(self)
	
	self._keyUp="up"
	self._keyDown="down"
	self._keyLeft="left"
	self._keyRight="right"
	self._keyFire="a"
	self._keyPause="p"
	self._keyEnter="return"
	self._keyEscape="escape"

	self._joyFire={joy_num=-1,joy_button=-1}
	self._joyEnter={joy_num=-1,joy_button=-1}
	self._joyEscape={joy_num=-1,joy_button=-1}

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

function GameConfig:setKeyFire(joystick, button )
	self._joyFire.joy_num=joystick
	self._joyFire.joy_button=button
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
	ret=self._keyFire

	if(self._joyFire.joy_num~=-1 and self._joyFire.joy_button~=-1) then
		name = love.joystick.getName(self._joyFire.joy_num)
		ret=ret..name.." B"..self._joyFire.joy_button
	end

	return ret
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
	direction = love.joystick.getAxis( 1, 2 )
	--DEBUG_PRINT("direction:"..direction)
	return love.keyboard.isDown(self._keyUp) or direction==-1 
end

function GameConfig:isDownDown()
	direction = love.joystick.getAxis( 1, 2 )
	return love.keyboard.isDown(self._keyDown) or direction==1
end

function GameConfig:isDownRight()
	direction = love.joystick.getAxis( 1, 1 )
	return love.keyboard.isDown(self._keyRight) or direction==1
end

function GameConfig:isDownLeft()
	direction = love.joystick.getAxis( 1, 1 )
	return love.keyboard.isDown(self._keyLeft) or direction==-1
end

function GameConfig:isDownFire()
	return love.keyboard.isDown(self._keyFire)	
			or love.joystick.isDown( self._joyFire.joy_num,self._joyFire.joy_button)
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