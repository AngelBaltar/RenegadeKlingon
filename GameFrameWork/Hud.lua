require 'GameFrameWork/SpaceObject'

Hud = class('GameFrameWork.Hud',SpaceObject)

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function Hud:initialize(space)
  local bar=love.graphics.newImage("Resources/gfx/hud.png")
  self._score=0
  SpaceObject.initialize(self,space, bar,0,0,200000)
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
  local bar=SpaceObject.getDrawableObject(self)
  local x_pos=self:getPositionX()+bar:getWidth()
  local y_pos=self:getPositionY()


  local player=self._space:getPlayerShip()
  local player_health=0
  local health_str=" Health: "
  local score_str=" Score: "..self._score

  if player~=nil then
    player_health=player:getHealth()
  end

  health_str=health_str..player_health

  love.graphics.setColor(0,0,0,120)
  love.graphics.rectangle("fill",0,0,self:getWidth(),self:getHeight())

  love.graphics.setColor(255,255,255,255)

  love.graphics.print(health_str, x_pos, y_pos)

  x_pos=x_pos+love.graphics.getFont():getWidth(health_str)
  
  love.graphics.print(score_str, x_pos, y_pos)
  
  SpaceObject.draw(self)
end

--hud does not get hurt
function Hud:collision(object,damage)
  return nil
end

--im the Hud, ovewritting from SpaceObject
function Hud:isHud()
	return true
end

--gets the score
function Hud:getScore()
  return self._score
end

--adds sc points to score
function Hud:addToScore(sc)
  self._score=self._score+sc
end