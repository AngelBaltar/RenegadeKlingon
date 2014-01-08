require 'GameScreens/FlowDownTextScreen'

HighScore = class('HighScore', FlowDownTextScreen)


local config=GameConfig.getInstance()

local score_table={}

score_table[0]={     name="ABD",
					 score=2000
				}

score_table[1]={     name="DAG",
					 score=1000
				}
local score_table_size=1

function HighScore:initialize(hud)

  local message=self:calculateMessage()
  FlowDownTextScreen.initialize(self,message)
  self._input=false
  self._indexAct=0
  self._hud=hud
end 

function HighScore:calculateMessage()
  local message=""
  for i=0,score_table_size do
  	message=message..score_table[i].name.."   "..score_table[i].score.."\n"
  end
  return message
end

function HighScore:activateInput()
	self._input=true
	self._indexAct=1
	score_table[score_table_size+1]={score=self._hud:getScore(),
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
		if score_table[score_table_size+1]==nil then
			return nil
		end
		local delta=0
		local my_byte=string.byte(score_table[score_table_size+1].name,self._indexAct)
		if(config:isDownRight() and my_byte<string.byte('Z') ) then
			delta=1
		end
		if(config:isDownLeft() and my_byte>string.byte('A')) then
			delta=-1
		end

		score_table[score_table_size+1].name=
			score_table[score_table_size+1].name:sub(0, self._indexAct - 1) 
			.. string.char(my_byte+delta) .. 
			score_table[score_table_size+1].name:sub(self._indexAct + 1, str:len())

		if(config:isDownEnter() or isDownFire()) then
			self._indexAct=self._indexAct+1
			if(self._indexAct>=4) then
				score_table_size=score_table_size+1
				self._input=false
				FlowDownTextScreen.setMessage(self,self:calculateMessage())
			end
		end
	end
end

function HighScore:draw()
	if not self._input then
		return FlowDownTextScreen.draw(self)
	else
		if score_table[score_table_size+1]==nil then
			return nil
		end
		 love.graphics.setColor(255,0,0,255)
		 love.graphics.print(
		 					"Register Your Score: "..
		 					score_table[score_table_size+1].name.."   "..score_table[score_table_size+1].score.."\n"
	 						, 200, 150)
	end
end