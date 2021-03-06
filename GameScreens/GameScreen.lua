-- /* RenegadeKlingon - LÖVE2D GAME
--  * GameScreen.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */
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

function GameScreen:initialize(autoplay)
    self._space=Space:new()
    self._levels={}

    self._levels[0]="map2.tmx"
    self._levels[1]="map2.tmx"
    self._levels[2]="map3.tmx"
      --UNCOMMENT FOR TESTING
    --self._levels[0]="testing_map.tmx"

    self._levelact=0
    self._numLevels=3
    self._autoplay=autoplay
    load_level(self._levels[self._levelact],self._space)
    self._space:getPlayerShip():setAutoPilot(self._autoplay)

    self._scores=nil

end

function GameScreen:draw()
   local player=self._space:getPlayerShip()
   local memory = _round(collectgarbage("count")/1024,2) -- Kb to Mb
  
   --DEBUG_PRINT("space draw")
   self._space:draw()

 if(player==nil)then
   if(self._scores~=nil) then
    self._scores:draw()
    if(not self._scores:isInputActivate()) then
      love.graphics.setColor(255,0,0,255)
      love.graphics.print("GAME OVER", self._space:getXend()/2-70,self._space:getYend()/2-60)
    end
   end
 end

 if(self._credits~=nil) then
     self._credits:draw()
 end

  if getDebug() then

    local r, g, b, a = love.graphics.getColor( )
    font_ant=love.graphics.getFont()
    love.graphics.setFont(mini_font)
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",550,500,216,93)
    love.graphics.setColor(255,255,255,255)

    love.graphics.setColor(255,255,255,255)
    love.graphics.print("FPS: "..love.timer.getFPS(),  self._space:getXend()-200, self._space:getYend()-100)
    love.graphics.print("Memory: "..memory.." Mb", self._space:getXend()-200, self._space:getYend()-100+20)
    love.graphics.print("Entities: "..self._space:getNumObjects(), self._space:getXend()-200, self._space:getYend()-100+40)
    love.graphics.print("Bucket Entities: "..self._space:getNumBucketObjects(), self._space:getXend()-200, self._space:getYend()-100+60)
    -- local all_enemies=self._space:getAllEnemies()
    -- local count=12
    -- for en,_ in pairs(all_enemies) do
    --   love.graphics.print("Enemy: "..en:getHealth(), 570, 550+count)
    --   count=count+12
    -- end
    love.graphics.setFont(font_ant)
    love.graphics.setColor(r,g,b,a)
  end
end

function GameScreen:update(dt)
  local player=self._space:getPlayerShip()
   --if player dead!
  if(player==nil)then
   		if(self._scores==nil) then
        self._scores=HighScore:new(self._space:getHud())
        self._scores:activateInput()
      end
      if(self._scores:isInputActivate()) then
        return 0
      end
      return nil
  else
      --DEBUG_PRINT("space update")

      if(self._space:isLevelEnded()) then
        self._levelact=self._levelact+1
        if(self._levelact>=self._numLevels) then
          if(self._credits==nil) then
            self._credits=CreditsScreen:new()
          end
          return self._credits:update()
        else
           load_level(self._levels[self._levelact],self._space)
        end
      end

  end
  self._space:update(dt)
end

function GameScreen:readPressed()
	if config:isDown(GameConfig.static.ESCAPE) then
      love.audio.stop()
    	return Screen:getExitMark()
  end
  if(self._autoplay) then
      if config:isDownAnyThing() then
        return Screen:getExitMark()
      end
  end
  self._space:readPressed()
  if(self._credits~=nil) then
    self._credits:readPressed()
  end
  if(self._scores~=nil and self._scores:isInputActivate()) then
    self._scores:readPressed()
  end
end