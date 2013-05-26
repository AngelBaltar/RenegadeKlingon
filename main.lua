require("Cuadrado")

key_pressed="none"
imgx=0
imgy=0


function love.load()
   image = love.graphics.newImage("Resources/destructor_klingon.png")
   local f = love.graphics.newFont(12)
   love.graphics.setFont(f)
   love.graphics.setColor(255,255,255,255)
   love.graphics.setBackgroundColor(255,255,255)
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
		if(imgy<400)then
			imgy=imgy+step
		end
   end

end

function love.update(dt)
   
   read_keyboard()
   
   love.graphics.draw(image, imgx, imgy)
end

function love.draw()
   
   --testing a simple cuadrado
   --figura = newCuadrado(5)
   --a=figura:Area()
   --love.graphics.print(a, 400, 300)
   love.graphics.draw(image, imgx, imgy)
end

function love.keypressed(key, unicode)
   if key == 'b' then
      text = "The B key was pressed."
   elseif key == 'a' then
      a_down = true
   end
end