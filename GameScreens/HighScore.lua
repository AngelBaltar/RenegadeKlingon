-- /* RenegadeKlingon - LÖVE2D GAME
--  * HighScore.lua
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
require 'GameScreens/FlowDownTextScreen'

HighScore = class('HighScore', FlowDownTextScreen)


local config=GameConfig.getInstance()



local writeScoreFile=function(self)
	local File score_file=love.filesystem.newFile("RenegadeKlingon.score")
	score_file:open('w')

	score_file:write(self._score_table_size.."\n")
	for i=0,self._score_table_size do
  		score_file:write(self._score_table[i].name.."\n"..self._score_table[i].score.."\n")
  	end

	score_file:close()

end

local readScoreFile=function(self)
	if not love.filesystem.exists( "RenegadeKlingon.score") then
		return nil
	end
	local i=1
	local reg_count=0
	local iterator=love.filesystem.lines("RenegadeKlingon.score")
	for line in iterator do
		if(i==1) then
			self._score_table_size=tonumber(line)
		else
			if(i%2==0) then
				self._score_table[reg_count]={name="xxx", score=0}
				self._score_table[reg_count].name=line
			else
				self._score_table[reg_count].score=tonumber(line)
				reg_count=reg_count+1
			end
		end
		i=i+1
   	end

end

function HighScore:initialize(hud)
  self._score_table={}

  self._score_table[0]={     name="ABD",
						 score=2000
					}

  self._score_table[1]={     name="DAG",
						 score=1000
					}
  self._input=false
  self._indexAct=0
  self._hud=hud
  self._score_table_size=1
  readScoreFile(self)
  local message=self:calculateMessage()
  FlowDownTextScreen.initialize(self,message)
end 


function HighScore:update(dt)
	FlowDownTextScreen.update(self,dt)
end

function HighScore:calculateMessage()
  local message=""
  for i=0,self._score_table_size do
  	message=message..self._score_table[i].name.."   "..self._score_table[i].score.."\n"
  end
  return message
end

function HighScore:activateInput()
	self._input=true
	self._indexAct=1
	self._score_table[self._score_table_size+1]={score=self._hud:getScore(),
									 name="AAA"
									}
end

function HighScore:isInputActivate()
	return self._input
end

function HighScore:readPressed()
	if not self._input then
		return FlowDownTextScreen.readPressed(self)
	else
		if self._score_table[self._score_table_size+1]==nil then
			return nil
		end
		local delta=0
		local my_byte=string.byte(self._score_table[self._score_table_size+1].name,self._indexAct)
		local readed=config:readInput()
		if(readed==GameConfig.static.RIGHT and my_byte<string.byte('Z') ) then
			delta=1
		end
		if(readed==GameConfig.static.LEFT and my_byte>string.byte('A')) then
			delta=-1
		end

		self._score_table[self._score_table_size+1].name=
			self._score_table[self._score_table_size+1].name:sub(0, self._indexAct - 1) 
			.. string.char(my_byte+delta) .. 
			self._score_table[self._score_table_size+1].name:sub(self._indexAct + 1, str:len())

		if(readed==GameConfig.static.ENTER or readed==GameConfig.static.FIRE) then
			self._indexAct=self._indexAct+1
			if(self._indexAct>=4) then
				self._score_table_size=self._score_table_size+1
				self._input=false
				writeScoreFile(self)
				FlowDownTextScreen.setMessage(self,self:calculateMessage())
			end
		end
	end
end

function HighScore:draw()
	if not self._input then
		return FlowDownTextScreen.draw(self)
	else
		if self._score_table[self._score_table_size+1]==nil then
			return nil
		end
		 love.graphics.setColor(255,0,0,255)
		 love.graphics.print(
		 					"Register Your Score: "..
		 					self._score_table[self._score_table_size+1].name.."   "..self._score_table[self._score_table_size+1].score.."\n"
	 						, 200, 150)
	end
end