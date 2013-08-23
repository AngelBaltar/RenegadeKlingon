require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/SimpleBullet'
require 'GameFrameWork/Bullets/AnimatedBullet'

DestructorKlingonBasicWeapon = class('GameFrameWork.Weapons.DestructorKlingonBasicWeapon',Weapon)

local source=love.audio.newSource( 'Resources/sfx/basic_weapon.wav',"static")

--constructor
function DestructorKlingonBasicWeapon:initialize(destructor_klingon)
	Weapon.initialize(self,destructor_klingon,0.1)
end

function DestructorKlingonBasicWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()

   local position_x=my_ship:getPositionX()
   local position_y=my_ship:getPositionY()
   local shot_emit_x=position_x+my_ship:getWidth()
   local shot_emit_y=position_y+my_ship:getHeight()/2
   local x_relative_step=0
   local y_relative_step=0

	  SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-2,
                     6+x_relative_step,0+y_relative_step,SimpleBullet.static.RED_BULLET)
    SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-2
               ,6+x_relative_step,0+y_relative_step,SimpleBullet.static.RED_BULLET)

   source:stop()
   source:play()
   
end