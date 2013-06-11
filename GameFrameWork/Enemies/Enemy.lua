require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'

Enemy = class('GameFrameWork.Enemies.Enemy',SpaceObject)


--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Enemy:initialize(space,drawable,health)
  --100 health for the enemy
  SpaceObject.initialize(self,space, drawable,100,300,health)
  --place it in free space
 
end

--return the width of this ship
function Enemy:getWidth()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getWidth()
end

--return the height of this ship
function Enemy:getHeight()
  local ship=SpaceObject.getDrawableObject(self)
	return ship:getHeight()
end

function Enemy:collision(object,damage)
  --other enemies bullets do not hit me
 if not (object:isBullet() and object:getEmmiter():isEnemyShip())
  and not object:isEnemyShip() and
  not object:isHarvestableObject() then
    SpaceObject.collision(self,object,damage)
    DEBUG_PRINT("COLLIDING WITH DAMAGE "..damage.."\n")
  end
end

--Performs movements changing the position of the object, firing bullets...
function Enemy:pilot(dt)

end

--Read from keyboard
function Enemy:keypressed(key, unicode)

end

--im the enemy, ovewritting from SpaceObject
function Enemy:isEnemyShip()
	return true
end