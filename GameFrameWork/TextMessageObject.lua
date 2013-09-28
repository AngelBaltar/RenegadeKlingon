require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'
require 'Utils/GameConfig'

TextMessageObject = class('GameFrameWork.TextMessageObject',SpaceObject)

local frame_exit_char='#'

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function TextMessageObject:initialize(space,tile,posx,posy,messageFile)
  --100 health for the player
 
  self._msgTxt=""
  self._msgDraw=""
  self._ch_act=0
  self._last_frame=os.clock()
  self._frame_rate=0.7
  --DEBUG_PRINT("Opening"..messageFile)
  if not love.filesystem.exists(messageFile) then
    return nil
  end
  
  local iterator=love.filesystem.lines(messageFile)
  for line in iterator do
        self._msgTxt=self._msgTxt..line.."\n"
  end
  --DEBUG_PRINT(self._msgTxt)
  SpaceObject.initialize(self,space, tile,posx,posy,2000)
end

--return the width of this ship
function TextMessageObject:getWidth()
	return 2
end

--return the height of this ship
function TextMessageObject:getHeight()
	return 3
end


function TextMessageObject:die()

DEBUG_PRINT("Text dies")

  SpaceObject.die(self)
  
  ---
end

--updates de message
function TextMessageObject:pilot(dt)
    local ch=''
    
    if(self._ch_act>=string.len(self._msgTxt)) then
      self:die()
      --all message was done
    end

    if(os.clock()-self._last_frame<=self._frame_rate) then
      return nil
    end
    
    self._last_frame=os.clock()
    self._msgDraw=""

    for i = self._ch_act, string.len(self._msgTxt) do
      ch=string.sub(self._msgTxt, i, i)
      self._ch_act=i
      if(ch==frame_exit_char) then
        self._ch_act=i+1
        break
      end
      self._msgDraw=self._msgDraw..ch
    end
end

--Draws the object in the screen
function TextMessageObject:draw()
    local x=self:getPositionX()
    local y=self:getPositionY()
    love.graphics.setColor(150,10,10,100)
    love.graphics.rectangle("fill",x,y,500,300)
    love.graphics.setColor(255,255,255,255)

    love.graphics.setColor(255,255,255,255)
    love.graphics.print(self._msgDraw, x, y)

end
