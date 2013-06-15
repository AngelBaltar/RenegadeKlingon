require 'Utils/middleclass/middleclass'


Weapon = class('GameFrameWork.Weapons.Weapon')

--constructor
function Weapon:initialize(ship_to_attach,shot_cadence)
  self._ship=ship_to_attach
  self._shot_cadence=shot_cadence
  self._last_shot=os.clock()
end

function Weapon:doFire()

end

function Weapon:fire()
	if(os.clock()-self._last_shot>self._shot_cadence) then
		self:doFire()
		self._last_shot=os.clock()
	end
end

function Weapon:getAttachedShip()
  return self._ship
end

function Weapon:setAttachedShip(ship)
	self._ship=ship
end