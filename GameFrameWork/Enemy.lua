require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'

Enemy = class('GameFrameWork.Enemy',SpaceObject)


--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Enemy:initialize(space,drawable,health)
  
  local absolute_init_x=space:getXinit()
  local absolule_end_x=space:getXend()

  local absolute_init_y=space:getYinit()
  local absolule_end_y=space:getYend()
  --100 health for the enemy
  SpaceObject.initialize(self,space, drawable,100,300,health)
  --place it in free space
  space:placeOnfreeSpace(self,absolule_end_x-200,absolule_end_x,absolute_init_y,absolule_end_y)
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