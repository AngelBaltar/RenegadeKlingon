require 'GameFrameWork/Weapons/Weapon'
require 'GameFrameWork/Bullets/SimpleBullet'

EnemyBasicWeapon = class('GameFrameWork.Weapons.EnemyBasicWeapon',Weapon)

--constructor
function EnemyBasicWeapon:initialize(enemie)
	--cadence 1.2 seconds
  Weapon.initialize(self,enemie,0.7)
end

function EnemyBasicWeapon:doFire()
   local my_ship=self:getAttachedShip()
   local my_space=my_ship:getSpace()

   local position_x=my_ship:getPositionX()
   local position_y=my_ship:getPositionY()

   local shot_emit_x=position_x-50
   local shot_emit_y=position_y+my_ship:getHeight()/2
   local player=my_space:getPlayerShip()

   local player_x=0
   local player_y=0
   
   local delta_x=-3
   
   local delta_y=0
   
   if(player~=nil) then
     player_x=player:getPositionX()
     player_y=player:getPositionY()
   
     delta_x=-3
     delta_y=3*((player_y-position_y)/(math.abs(player_x-position_x)))
   end

   

	 SimpleBullet:new(my_space,my_ship,shot_emit_x,shot_emit_y,delta_x,delta_y,SimpleBullet.static.BLUE_BULLET)
end