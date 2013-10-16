require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/SimpleBullet'
require 'GameFrameWork/Bullets/AnimatedBullet'

DoubleBasicWeapon = class('GameFrameWork.Weapons.DoubleBasicWeapon',Weapon)

--constructor
function DoubleBasicWeapon:initialize(ship)
   local cadence=3.4
   if(ship ~=nil and ship:isPlayerShip()) then 
      cadence=0.1
   end
	Weapon.initialize(self,ship,cadence)
end

function DoubleBasicWeapon:doFire()

   local my_ship=self:getAttachedShip()
    local my_space=my_ship:getSpace()
   local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=self:calculateFire()

   local bullet=nil

   if (my_ship:isEnemyShip()) then
      bullet=SimpleBullet.static.BLUE_BULLET
   else
     bullet=SimpleBullet.static.RED_BULLET
   end

	SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-2,
                     x_relative_step,y_relative_step,bullet)
   SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-2
               ,x_relative_step,y_relative_step,bullet)
   
end