require 'GameFrameWork/Harvestables/HarvestableObject'
require 'GameFrameWork/Weapons/MachineGunWeapon'
require 'Utils/Animation'

WeaponObject = class('GameFrameWork.Harverstables.WeaponObject',HarvestableObject)

WeaponObject.static.MACHINE_GUN = love.graphics.newImage("Resources/gfx/crystal_pink.png")
local WP_MACHINEGUN=1


local weapons_tab={}
weapons_tab[WeaponObject.static.MACHINE_GUN]={
												size_x=17,
												size_y=18,
												n_steps=4,
												mode="loop",
                        delay=0.3,
                        zoom=3,
												weapon=WP_MACHINEGUN}

--constructor
function WeaponObject:initialize(space,weapon_type,posx,posy)

 self._animation = newAnimation(weapon_type,
  					                   weapons_tab[weapon_type].size_x,
  					                   weapons_tab[weapon_type].size_y,
                               weapons_tab[weapon_type].delay,
                               weapons_tab[weapon_type].n_steps)
  self._animation:setMode(weapons_tab[weapon_type].mode)

  if(weapons_tab[weapon_type].weapon==WP_MACHINEGUN) then
  	self._weapon=MachineGunWeapon:new(nil)
  end
  self._zoom=weapons_tab[weapon_type].zoom
  HarvestableObject.initialize(self,space,weapon_type,posx,posy,0)

end

function WeaponObject:pilot(dt)
	HarvestableObject.pilot(self,dt)
	self._animation:update(dt)
end

function WeaponObject:collision(object,damage)
    HarvestableObject.collision(self,object,damage)
    if(object:isPlayerShip()) then
    	object:setWeapon(self._weapon)
    end
end

--return the width of this ship
function WeaponObject:getWidth()
  return self._animation:getWidth()*self._zoom
end

function WeaponObject:getHeight()
  return self._animation:getHeight()*self._zoom
end

function WeaponObject:draw()

  self._animation:draw(SpaceObject.getPositionX(self), SpaceObject.getPositionY(self),0,self._zoom) 
end

function WeaponObject:toString()
  return "weapon"
end