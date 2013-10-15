require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/AnimatedBullet'

DoubleWeapon = class('GameFrameWork.Weapons.DoubleWeapon',Weapon)

--constructor
function DoubleWeapon:initialize(ship,bullet)
	self._bullet=bullet
   Weapon.initialize(self,ship,0.12)
end

function DoubleWeapon:doFire()
  local my_ship=self:getAttachedShip()
  local my_space=my_ship:getSpace()
  local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=self:calculateFire()
  local emit_delta=15

   AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-emit_delta,
                     x_relative_step,y_relative_step,self._bullet)

    AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-emit_delta,
                     x_relative_step,y_relative_step,self._bullet)
   
end