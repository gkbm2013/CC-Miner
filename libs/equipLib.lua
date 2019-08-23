require "/libs/positionLib"

-- function from http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function setRetry(retry)
    TURTUL_RETRY = retry
end

function doTurtleAction(name)
    local _name = name
    return function()
        local ctn = 0
        while turtle_ori[_name]() == false do
            ctn = ctn + 1
            if(ctn >= TURTUL_RETRY) then
                return false
            end
            sleep(0.05)
        end
        pos.updateByName(name)
        return true
    end
end

TURTUL_RETRY = 0
turtle_ori = deepcopy(turtle)

turtle.forward = doTurtleAction('forward')
turtle.back = doTurtleAction('back')
turtle.turnLeft = doTurtleAction('turnLeft')
turtle.turnRight = doTurtleAction('turnRight')
turtle.up = doTurtleAction('up')
turtle.down = doTurtleAction('down')

turtle.turnAround = function()
    x = turtle.turnRight()
    y = turtle.turnRight()
    return x and y
end

function df3() -- a.k.a. Dig Forward 1x3
    turtle.dig()
    turtle.forward()
    turtle.digUp()
    turtle.digDown()
end

function d333() -- a.k.a. Dig 3x3x3
    turtle.digDown()
    turtle.down()
    turtle.digDown()
    turtle.down()
    turtle.digDown()

    --

    df3()
    turtle.turnLeft()
    df3()
    turtle.turnLeft()

    for i = 1, 3 do
        df3()
        df3()
        turtle.turnLeft()
    end

    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnAround()

    turtle.down()
end

function df() --a.k.a. Dig Forward
    turtle.dig()
    turtle.forward()
end

function d33() -- a.k.a. Dig 3x3x1
    turtle.digDown()
    turtle.down()

    df()
    
    turtle.turnLeft()
    df()

    for i = 1, 3 do
        turtle.turnLeft()
        df()
        df()
    end

    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnAround()
end

require "/libs/mapLib"