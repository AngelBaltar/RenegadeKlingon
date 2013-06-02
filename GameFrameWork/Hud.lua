require 'middleclass/middleclass'
require 'GameFrameWork/SpaceObject'
require 'GameFrameWork/Bullet'

Hud = class('GameFrameWork.Hud',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Hud:initialize(space)
  local bar=love.graphics.newImage("Resources/hud.png")
  SpaceObject.initialize(self,space, bar,0,0,200)
end

--return the width of this ship
function Hud:getWidth()
	return SpaceObject.getSpace(self):getXend()
end

--return the height of this ship
function Hud:getHeight()
  local bar=SpaceObject.getDrawableObject(self)
	return bar:getHeight()
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
    player_health=player:getHealth()
  end

  love.graphics.setColor(0,0,0,120)
  love.graphics.rectangle("fill",0,0,self:getWidth(),self:getHeight())

  love.graphics.setColor(255,255,255,255)
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