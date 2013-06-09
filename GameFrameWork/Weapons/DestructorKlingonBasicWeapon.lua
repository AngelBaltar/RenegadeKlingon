require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullet'

DestructorKlingonBasicWeapon = class('GameFrameWork.Weapons.DestructorKlingonBasicWeapon',Weapon)

--constructor
function DestructorKlingonBasicWeapon:initialize(destructor_klingon)
	Weapon:initialize(destructor_klingon)
end

function DestructorKlingonBasicWeapon:fire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()

   local position_x=my_ship:getPositionX()
   local position_y=my_ship:getPositionY()
   local shot_emit_x=position_x+my_ship:getWidth()
   local shot_emit_y=position_y+my_ship:getHeight()/2
   local x_relative_step=0
   local y_relative_step=0

	 Bullet:new(my_space,my_ship,shot_emit_x,shot_emit_y-my_ship:getHeight()/2-2,
                    6+x_relative_step,0+y_relative_step,Bullet.static.RED_BULLET)
     Bullet:new(my_space,my_ship,shot_emit_x,shot_emit_y+my_ship:getHeight()/2-2
                ,6+x_relative_step,0+y_relative_step,Bullet.static.RED_BULLET)
end