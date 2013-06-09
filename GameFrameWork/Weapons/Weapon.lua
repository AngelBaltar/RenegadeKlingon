require 'middleclass/middleclass'


Weapon = class('GameFrameWork.Weapons.Weapon')

--constructor
function Weapon:initialize(ship_to_attach)
  self._ship=ship_to_attach
end

function Weapon:fire()

end

function Weapon:getAttachedShip()
  return self._ship
end