require 'GameFrameWork/Hud'
require 'GameFrameWork/Level'
require 'Utils/Debugging'
require 'Utils/GameConfig'

GameScreen = class('GameScreen',Screen)

local mini_font=love.graphics.newFont( 12 )
local config=GameConfig.getInstance()

local _round=function (num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function GameScreen:initialize()
    self._space=Space:new()
    self._levels={}

    self._levels[0]="map1.tmx"
    self._levels[1]="map2.tmx"

    self._levelact=0
    self._numLevels=2
    load_level(self._levels[self._levelact],self._space)
    

end

function GameScreen:draw()
   local player=self._space:getPlayerShip()
   local memory = _round(collectgarbage("count")/1024,2) -- Kb to Mb
  
   --DEBUG_PRINT("space draw")
   self._space:draw()

 if(player==nil)then
    love.graphics.setColor(255,0,0,255)
    love.graphics.print("GAME OVER", self._space:getXend()/2-70,self._space:getYend()/2-60)
   end

  if getDebug() then
    font_ant=love.graphics.getFont()
    love.graphics.setFont(mini_font)
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",550,500,216,93)
    love.graphics.setColor(255,255,255,255)

    love.graphics.setColor(255,255,255,255)
    love.graphics.print("FPS: "..love.timer.getFPS(), 570, 510)
    love.graphics.print("Memory: "..memory.." Mb", 570, 530)
    love.graphics.print("Entities: "..self._space:getNumObjects(), 570, 550)
    love.graphics.print("Bucket Entities: "..self._space:getNumBucketObjects(), 570, 570)
    -- local all_enemies=self._space:getAllEnemies()
    -- local count=12
    -- for en,_ in pairs(all_enemies) do
    --   love.graphics.print("Enemy: "..en:getHealth(), 570, 550+count)
    --   count=count+12
    -- end
    love.graphics.setFont(font_ant)
  end
end

function GameScreen:update(dt)
  local player=self._space:getPlayerShip()
   --if player dead!
  if(player==nil)then
   		return nil
  else
      --DEBUG_PRINT("space update")
      self._space:update(dt)

      if(self._space:isLevelEnded()) then
        self._levelact=self._levelact+1
        if(self._levelact>=self._numLevels) then
          return nil
        else
           load_level(self._levels[self._levelact],self._space)
        end
      end

  end
end

function GameScreen:readPressed()
	if config:isDownEscape() then
    	return Screen:getExitMark()
   end
   self._space:readPressed()
end