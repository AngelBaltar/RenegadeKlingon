require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/AnimatedBullet'

MachineGunWeapon = class('GameFrameWork.Weapons.MachineGunWeapon',Weapon)

--constructor
function MachineGunWeapon:initialize(ship)
	Weapon.initialize(self,ship)
end


function MachineGunWeapon:PlayerCadence()
	return 0.02
end

function MachineGunWeapon:doFire()
 local my_ship=self:getAttachedShip()
 local my_space=my_ship:getSpace()
 local shot_emit_x,shot_emit_y,x_relative_step,y_relative_step=self:calculateFire()

   AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-2,
                     x_relative_step,y_relative_step,AnimatedBullet.static.PINK_ANIMATED)
end