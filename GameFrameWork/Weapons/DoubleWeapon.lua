require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/AnimatedBullet'

DoubleWeapon = class('GameFrameWork.Weapons.DoubleWeapon',Weapon)

local source=love.audio.newSource( 'Resources/sfx/double_weapon.wav',"static")
--constructor
function DoubleWeapon:initialize(destructor_klingon,bullet)
	self._bullet=bullet
   Weapon.initialize(self,destructor_klingon,0.12)
end

function DoubleWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()

   local position_x=my_ship:getPositionX()
   local position_y=my_ship:getPositionY()
   local shot_emit_x=position_x+my_ship:getWidth()
   local shot_emit_y=position_y+my_ship:getHeight()/2
   local x_relative_step=0
   local y_relative_step=0
   local emit_delta=15

   AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-emit_delta,
                     6+x_relative_step,0+y_relative_step,self._bullet)

    AnimatedBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-emit_delta,
                     6+x_relative_step,0+y_relative_step,self._bullet)
   source:stop()
   source:play()
   
end