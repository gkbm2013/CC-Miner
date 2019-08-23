function toZzero()
    if pos.getZ() > 0 then
        while pos.getFacing() ~= 'W' do
            turtle.turnRight()
        end
    elseif pos.getZ() < 0 then
        while pos.getFacing() ~= 'E' do
            turtle.turnRight()
        end
    else
        return
    end
    while pos.getZ() ~= 0 do
        turtle.dig()
        turtle.forward()
    end
end

function toXzero()
    if pos.getX() > 0 then
        while pos.getFacing() ~= 'S' do
            turtle.turnRight()
        end
    elseif pos.getX() < 0 then
        while pos.getFacing() ~= 'N' do
            turtle.turnRight()
        end
    else
        return
    end
    while pos.getX() ~= 0 do
        turtle.dig()
        turtle.forward()
    end
end

function toYzero()
    while pos.getFacing() ~= 'N' do
        turtle.turnRight()
    end
    if pos.getY() > 0 then
        while pos.getY() ~= 0 do
            turtle.digDown()
            turtle.down()
        end
    elseif pos.getY() < 0 then
        while pos.getY() ~= 0 do
            turtle.digUp()
            turtle.up()
        end
    else
        return
    end
end

function goHome()
    toZzero()
    toXzero()
    toYzero()
end

function equipItem(try, slot, name)
    try = try or 64
    goHome()

    while try > 0 do
        detail = turtle.getItemDetail(slot)
        if (detail ~= nil and detail.name ~= name) then
            turtle.select(slot)
            turtle.dropUp()
            turtle.select(1)
        elseif turtle.getItemSpace(slot) == 0 then
            turtle.select(1)
            turtle.dropUp()
            return true
        end
        
        turtle.select(1)
        detail = turtle.getItemDetail(1)
        if (detail ~= nil and detail.name ~= name) then
            turtle.dropUp()
        else
            ctn = turtle.getItemSpace(slot)
            turtle.transferTo(slot, ctn)
            turtle.dropUp()
        end
        turtle.suck()
        try = try -1
    end

    turtle.select(1)
    turtle.dropUp()

    detail = turtle.getItemDetail(slot)
    if (detail ~= nil and detail.name == name) and turtle.getItemSpace(slot) == 0 then
        return true
    else
        return false
    end
end 

function equipFuel(target, try)
    try = try or 4096
    goHome()

    turtle.select(1)
    turtle.dropUp()

    while try > 0 do
        turtle.suck()
        flag, reason = turtle.refuel()
        if flag == false then
            turtle.dropUp()
        elseif turtle.getFuelLevel() >= target then
            return true
        else
            try = try + 1
        end
        try = try -1
    end
    return false
end

function getLocationString()
    return string.format("x:%d, y:%d, z:%d", pos.getX(), pos.getY(), pos.getZ())
end

function goTo(x, y, z, f, force)
    force = force or true
    while pos.getY() ~= y do
        if y - pos.getY() > 0 then
            local temp = force and turtle.digUp() or false
            turtle.up()
        else
            local temp = force and turtle.digDown() or false
            actionA = turtle.down()
        end
    end

    while pos.getX() ~= x do
        if x - pos.getX() > 0 then
            while pos.getFacing() ~= 'N' do
                turtle.turnRight()
            end
        elseif x - pos.getX() < 0 then
            while pos.getFacing() ~= 'S' do
                turtle.turnRight()
            end
        end
        local temp = force and turtle.dig() or false
        turtle.forward()
    end

    local df = 0

    while pos.getZ() ~= z do
        if z - pos.getZ() > 0 then
            while pos.getFacing() ~= 'E' do
                turtle.turnRight()
            end
            df = 1
        elseif z - pos.getZ() < 0 then
            while pos.getFacing() ~= 'W' do
                turtle.turnRight()
            end
            df = 3
        end
        local temp = force and turtle.dig() or false
        turtle.forward()
    end

    f = f or df

    while pos.getF() ~= f do
        turtle.turnRight()
    end
end