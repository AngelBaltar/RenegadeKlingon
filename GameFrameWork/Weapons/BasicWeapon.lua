require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/SimpleBullet'

BasicWeapon = class('GameFrameWork.Weapons.BasicWeapon',Weapon)


--constructor
function BasicWeapon:initialize(ship)
	--cadence 1.2 seconds
  local cadence=0.9
    if(ship ~=nil and ship:isPlayerShip()) then 
      cadence=0.1
   end
  Weapon.initialize(self,ship,cadence)
end

function BasicWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()
   local shot_emit_x,shot_emit_y,delta_x,delta_y=self:calculateFire()
   local bullet=nil

   if (my_ship:isEnemyShip()) then
	   bullet=SimpleBullet.static.BLUE_BULLET
  else
     bullet=SimpleBullet.static.RED_BULLET
   end

  SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y,delta_x,delta_y,bullet)
end