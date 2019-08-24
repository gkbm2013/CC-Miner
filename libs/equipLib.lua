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

function hasItemSpace(facing)
    facing = facing or "dig"

    local inspect = nil
    if facing == "dig" then
        inspect = turtle.inspect
    elseif facing == "digUp" then
        inspect = turtle.inspectUp
    elseif facing == "digDown" then
        inspect = turtle.inspectDown
    end

    isBlock, data = inspect()
    if isBlock == false then
        return true
    end

    spaceCtn = 0
    for i=1,16 do
        detail = turtle.getItemDetail(i)
        space = turtle.getItemSpace(i)
        if detail == nil then
            spaceCtn = spaceCtn + 1
        elseif detail.name == data.name and space ~= 0 then
            spaceCtn = spaceCtn + 1
        end
    end

    return spaceCtn ~= 0
end

function doDigAction(name)
    local _name = name
    local retry = 2
    return function()
        local ctn = 0
        local flag = false
        local msg = ""
        repeat
            ctn = ctn + 1
            if hasItemSpace(_name) then
                flag, msg = turtle_ori[_name]()
            else
                msg = "no item space"
            end
            if(ctn >= retry) and flag == false then
                return false, msg
            end
        until flag == true
        return true, nil
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

turtle.digs = doDigAction('dig')
turtle.digUps = doDigAction('digUp')
turtle.digDowns = doDigAction('digDown')

turtle.turnAround = function()
    x = turtle.turnRight()
    y = turtle.turnRight()
    return x and y
end

function handleDig(name, cb, ctn)
    cb = cb or function(x, y) end
    ctn = ctn or 2
    flag, msg = turtle[name]()
    if flag == false then
        cb(flag, msg)
        if ctn >= 0 then
            handleDig(name, cb, ctn-1)
        end
    end
end

function df3(cb) -- a.k.a. Dig Forward 1x1x3
    handleDig("digs", cb)
    turtle.forward()
    handleDig("digUps", cb)
    handleDig("digDowns", cb)
end

function d333(cb) -- a.k.a. Dig 3x3x3
    handleDig("digDowns", cb)
    turtle.down()
    handleDig("digDowns", cb)
    turtle.down()
    handleDig("digDowns", cb)

    --

    df3(cb)
    turtle.turnLeft()
    df3(cb)
    turtle.turnLeft()

    for i = 1, 3 do
        df3(cb)
        df3(cb)
        turtle.turnLeft()
    end

    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnAround()

    turtle.down()
end

function df(cb) --a.k.a. Dig Forward
    handleDig("digs", cb)
    turtle.forward()
end

function d33(cb) -- a.k.a. Dig 3x3x1
    handleDig("digDowns", cb)
    turtle.down()

    df(cb)
    
    turtle.turnLeft()
    df(cb)

    for i = 1, 3 do
        turtle.turnLeft()
        df(cb)
        df(cb)
    end

    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnAround()
end

require "/libs/mapLib"