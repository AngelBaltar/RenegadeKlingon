require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/AnimatedBullet'

MachineGunWeapon = class('GameFrameWork.Weapons.MachineGunWeapon',Weapon)

local source=love.audio.newSource( 'Resources/sfx/machine_gun.wav',"static")
--constructor
function MachineGunWeapon:initialize(destructor_klingon)
	Weapon.initialize(self,destructor_klingon,0.02)
end

function MachineGunWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()

   local position_x=my_ship:getPositionX()
   local position_y=my_ship:getPositionY()
   local shot_emit_x=position_x+my_ship:getWidth()
   local shot_emit_y=position_y+my_ship:getHeight()/2
   local x_relative_step=0
   local y_relative_step=0

   AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-2,
                     6+x_relative_step,0+y_relative_step,AnimatedBullet.static.PINK_ANIMATED)
   source:stop()
   source:play()
   
end