require 'Utils/Debugging'

ButtonRead = class('GameFrameWork.ButtonRead')

local _instance=nil
--constructor

local __initialize = function(self)
	self._keyboard=false
	self._key="unknown"
	self._unicode=0
	self._joypad=false
	self._joypadNum=0
	self._joypadButton=0
end

--return the width of this ship
function ButtonRead.getInstance()
  if _instance==nil then
  	_instance=ButtonRead:new()
  	__initialize(_instance)
  end
  return _instance
end

function ButtonRead:setKey(key,unicode)
	__initialize(self)
	self._keyboard=true
	self._key=key
	self._unicode=unicode
end

function ButtonRead:setJoyButton(joypad,button)
	__initialize(self)
	self._joypad=true
	self._joypadNum=joypad
	self._joypadButton=button
end

function ButtonRead:getKey()
	if not self._keyboard then
		return nil
	else
		key=self._key
		__initialize(self) --only 1 read
		return key
		
	end
	
end

function ButtonRead:getJoys()
	if not self._joypad then
		return nil,nil
	else
		joy=self._joypadNum
		button=self._joypadButton
		__initialize(self) --only 1 read
		return joy,button
	end
end