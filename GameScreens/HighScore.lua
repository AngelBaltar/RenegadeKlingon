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
		if(config:isDownRight() and my_byte<string.byte('Z') ) then
			delta=1
		end
		if(config:isDownLeft() and my_byte>string.byte('A')) then
			delta=-1
		end

		self._score_table[self._score_table_size+1].name=
			self._score_table[self._score_table_size+1].name:sub(0, self._indexAct - 1) 
			.. string.char(my_byte+delta) .. 
			self._score_table[self._score_table_size+1].name:sub(self._indexAct + 1, str:len())

		if(config:isDownEnter() or config:isDownFire()) then
			self._indexAct=self._indexAct+1
			if(self._indexAct>=4) then
				self._score_table_size=self._score_table_size+1
				self._input=false
				FlowDownTextScreen.setMessage(self,self:calculateMessage())
				writeScoreFile(self)
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