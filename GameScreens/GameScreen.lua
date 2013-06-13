require 'middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Space'
require 'GameFrameWork/Enemies/RomulanScout'
require 'GameFrameWork/Hud'
require 'GameFrameWork/Harvestables/HealthObject'
require 'GameFrameWork/Harvestables/WeaponObject'
require 'GameFrameWork/TileBlock'

GameScreen = class('GameScreen',Screen)

local mini_font=love.graphics.newFont( 12 )
function GameScreen:initialize()
    self._space=Space:new()
    self._space:addBackGroundImage("Resources/gfx/space-1.png")
    self._space:addBackGroundImage("Resources/gfx/space-2.png")
    self._space:addBackGroundImage("Resources/gfx/space-3.png")
    self._space:addBackGroundImage("Resources/gfx/space-4.png")
    Hud:new(self._space)
    PlayerShip:new(self._space)
    RomulanScout:new(self._space)
    RomulanScout:new(self._space)
    RomulanScout:new(self._space)
    RomulanScout:new(self._space)
    RomulanScout:new(self._space)
    HealthObject:new(self._space)
    TileBlock:new(self._space,"Resources/gfx/block1.png",500,500)
    WeaponObject:new(self._space,WeaponObject.static.MACHINE_GUN)

end

local _round=function (num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function GameScreen:draw()
   local player=self._space:getPlayerShip()
   local memory = _round(collectgarbage("count")/1024,2) -- Kb to Mb
   self._space:draw()
   if(player==nil)then
      love.graphics.setColor(255,0,0,255)
      love.graphics.print("GAME OVER", self._space:getXend()/2-70,self._space:getYend()/2-60)
   end
  font_ant=love.graphics.getFont()
  love.graphics.setFont(mini_font)
  love.graphics.setColor(0,0,0,100)
  love.graphics.rectangle("fill",550,500,216,93)
  love.graphics.setColor(255,255,255,255)

  love.graphics.setColor(255,255,255,255)
  love.graphics.print("FPS: "..love.timer.getFPS(), 570, 510)
  love.graphics.print("Memory: "..memory.." Mb", 570, 530)
  love.graphics.print("Entities: "..self._space:getNumObjects(), 570, 550)
  local all_enemies=self._space:getAllEnemies()
  local count=12
  for en,_ in pairs(all_enemies) do
    love.graphics.print("Enemy: "..en:getHealth(), 570, 550+count)
    count=count+12
  end
  love.graphics.setFont(font_ant)
end

function GameScreen:update(dt)
  local player=self._space:getPlayerShip()
   --if player dead!
   if(player==nil)then
   		
  else
      self._space:update(dt)
  end
end

function GameScreen:keypressed(key, unicode)
	if key=="escape" then
    	return Screen:getExitMark()
   end
   self._space:keypressed(key,unicode)
end