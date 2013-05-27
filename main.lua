require("Menu")

--global game variables
selected_option=0

NONE_OPTION=0
PLAY_OPTION=1
OPTIONS_OPTION=2


imgx=0
imgy=0
mainMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
mainMenu:addItem("Play")
mainMenu:addItem("Options")

optionsMenu=Menu:new(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
optionsMenu:addItem("enable joypad")



function gameDraw()
   love.graphics.setColor(255,255,255,255)
   love.graphics.setBackgroundColor(0,0,0)
   love.graphics.draw(image, imgx, imgy)
end

play=gameDraw

function love.load()
   image = love.graphics.newImage("Resources/destructor_klingon.png")
   local f = love.graphics.newFont(23)
   love.graphics.setFont(f)
   love.graphics.setColor(255,0,0,255)
   love.graphics.setBackgroundColor(0,0,0)
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
end


function read_keyboard()
	step=5
  if love.keyboard.isDown("up") then
		if(imgy>0)then
			imgy=imgy-step
		end
   end
  if love.keyboard.isDown("down") then
		if(imgy<love.graphics.getHeight()-image:getHeight())then
			imgy=imgy+step
		end
   end

   if love.keyboard.isDown("left") then
    if(imgx>0)then
      imgx=imgx-step
    end
   end
  if love.keyboard.isDown("right") then
    if(imgx<love.graphics.getWidth()-image:getWidth()) then
      imgx=imgx+step
    end
   end
   if love.keyboard.isDown("escape") then
    selected_option=0
   end

end

function love.update(dt)
   
   if(selected_option==NONE_OPTION) then
    selected_option=mainMenu:read()
   end
    if(selected_option==PLAY_OPTION) then
       read_keyboard()
       love.graphics.draw(image, imgx, imgy)
    end
     if(selected_option==OPTIONS_OPTION) then
        optionsMenu:read()
    end
end

function love.draw()
  
    if(selected_option==NONE_OPTION) then
        mainMenu:print()
    end
    if(selected_option==PLAY_OPTION) then
     play()
    end
    if(selected_option==OPTIONS_OPTION) then
        optionsMenu:print()
    end
end

function love.keypressed(key, unicode)

end