require 'Utils/Debugging'
require 'Utils/ButtonRead'

GameConfig = class('GameFrameWork.GameConfig')

local _instance=nil
local button_read=ButtonRead.getInstance()
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
	self._joyPause={joy_num=-1,joy_button=-1}
	self._joyEnter={joy_num=-1,joy_button=-1}
	self._joyEscape={joy_num=-1,joy_button=-1}

	name =nil
	joypad_found=false
	i=0
	self._activepad=0
	n_joys=love.joystick.getNumJoysticks()
	while (i<=n_joys and not joypad_found) do
		name = love.joystick.getName(i)
		if name ~= nil then
			joypad_found=true
			self._activepad=i
		end
		i=i+1
	end
	DEBUG_PRINT("ACTIVE PAD IS: "..self._activepad)

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

function GameConfig:setKeyFire(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyFire=joystick_key
	else
		self._joyFire.joy_num=joystick_key
		self._joyFire.joy_button=button_nil
	end
	
end

function GameConfig:setKeyPause(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyPause=joystick_key
	else
		self._joyPause.joy_num=joystick_key
		self._joyPause.joy_button=button_nil
	end
	
end

function GameConfig:setKeyEnter(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyEnter=joystick_key
	else
		self._joyEnter.joy_num=joystick_key
		self._joyEnter.joy_button=button_nil
	end
	
end

function GameConfig:setKeyEscape(joystick_key, button_nil )
	
	if(button_nil==nil) then
		self._keyEscape=joystick_key
	else
		self._joyEscape.joy_num=joystick_key
		self._joyEscape.joy_button=button_nil
	end
	
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
		DEBUG_PRINT(self._joyFire)
		name = love.joystick.getName(self._joyFire.joy_num)
		ret=ret.." OR "..name.." B"..self._joyFire.joy_button
	end

	return ret
end

function GameConfig:getKeyPause()
	ret=self._keyPause

	if(self._joyPause.joy_num~=-1 and self._joyPause.joy_button~=-1) then
		name = love.joystick.getName(self._joyPause.joy_num)
		ret=ret.." OR "..name.." B"..self._joyPause.joy_button
	end

	return ret
end

function GameConfig:getKeyEnter()
	ret=self._keyEnter

	if(self._joyEnter.joy_num~=-1 and self._joyEnter.joy_button~=-1) then
		name = love.joystick.getName(self._joyEnter.joy_num)
		ret=ret.." OR "..name.." B"..self._joyEnter.joy_button
	end

	return ret
end

function GameConfig:getKeyEscape()
	ret=self._keyEscape

	if(self._joyEscape.joy_num~=-1 and self._joyEscape.joy_button~=-1) then
		name = love.joystick.getName(self._joyEscape.joy_num)
		ret=ret.." OR "..name.." B"..self._joyEscape.joy_button
	end

	return ret
end

function GameConfig:getActiveJoyPad()
	return self._activepad
end

function GameConfig:isDownUp()
	direction = love.joystick.getAxis(self._activepad, 2 )
	DEBUG_PRINT("activepad: "..self._activepad.." direction:"..direction)
	return love.keyboard.isDown(self._keyUp) or direction==-1 
end

function GameConfig:isDownDown()
	direction = love.joystick.getAxis(self._activepad, 2 )
	return love.keyboard.isDown(self._keyDown) or direction==1
end

function GameConfig:isDownRight()
	direction = love.joystick.getAxis(self._activepad, 1 )
	return love.keyboard.isDown(self._keyRight) or direction==1
end

function GameConfig:isDownLeft()
	direction = love.joystick.getAxis(self._activepad, 1 )
	return love.keyboard.isDown(self._keyLeft) or direction==-1
end

function GameConfig:isDownFire()
	return love.keyboard.isDown(self._keyFire)	
			or love.joystick.isDown( self._joyFire.joy_num,self._joyFire.joy_button)
end

function GameConfig:isDownPause()
	return love.keyboard.isDown(self._keyPause)
		or love.joystick.isDown( self._joyPause.joy_num,self._joyPause.joy_button)
end

function GameConfig:isDownEnter()
	return button_read:getKey()==self._keyEnter
		or love.joystick.isDown( self._joyEnter.joy_num,self._joyEnter.joy_button)
end

function GameConfig:isDownEscape()
	return love.keyboard.isDown(self._keyEscape)
		or love.joystick.isDown( self._joyEscape.joy_num,self._joyEscape.joy_button)
end