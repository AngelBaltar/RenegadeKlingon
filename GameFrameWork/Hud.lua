require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'

Hud = class('GameFrameWork.Hud',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Hud:initialize(space)
  self._bar=love.graphics.newImage("Resources/hud.png")
  SpaceObject.initialize(self,space, self._bar,0,0,200)
end

--return the width of this ship
function Hud:getWidth()
	return love.graphics.getWidth()
end

--return the height of this ship
function Hud:getHeight()
	return self._bar:getHeight()
end

--Performs movements changing the position of the object, firing bullets...
function Hud:pilot(dt)

end

--overwrite draw function
function Hud:draw()

  local my_space=SpaceObject.getSpace(self)
  local x_pos=self:getPositionX()
  local y_pos=self:getPositionY()

  local player=self._space:getPlayerShip()
  local player_health=0

  if player~=nil then
    player_health=player:getLife()
  end
  love.graphics.print("Health: "..player_health, x_pos+60, y_pos)
  SpaceObject.draw(self)
end

--Read from keyboard
function Hud:keypressed(key, unicode)

end

--im the Hud, ovewritting from SpaceObject
function Hud:isHud()
	return true
end