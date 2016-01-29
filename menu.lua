local Menu = {} 

function Menu:init()
    print("init")
end

function Menu:enter(previous) -- runs every time the state is entered
    print("enter")
end

function Menu:update(dt) -- runs every frame
    
end

function Menu:draw()
    
end

function Menu:keyreleased(key)
    if key == 'up' then
        print("released up")
    elseif key == 'down' then
        print("released down")
    end
end

function Menu:mousereleased(x,y, mouse_btn)
    print("mousereleased")
end

return Menu