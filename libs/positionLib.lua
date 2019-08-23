json = require "/libs/json"

RECORD_FILE = "/.tmp/location"
LOCATION = {x=0, y=0, z=0, f=0}

function cleanRecordFile()
    LOCATION = {x=0, y=0, z=0, f=0}
    h = fs.open(RECORD_FILE, "w")
    h.write(json.encode(LOCATION))
    h.close()
end

if fs.exists("/.tmp") == false or fs.exists(RECORD_FILE) == false then
    shell.run("mkdir /.tmp")
    cleanRecordFile()
end

function updateLocationFile()
    h = fs.open(RECORD_FILE, "w")
    h.write(json.encode(LOCATION))
    h.close()
end

FACING = {
    _values = {'N', 'E', 'S', 'W'},
    _value = 0,
    _update = function(val)
        if val >= 0 then
            FACING._value = FACING._value + 1
        else
            FACING._value = FACING._value - 1
        end
        if FACING._value >= 0 then
            FACING._value = math.fmod(FACING._value, 4)
        else
            FACING._value = math.fmod(FACING._value, 4)
            if FACING._value ~= 0 then
                FACING._value = FACING._value + 4
            end
        end
        LOCATION.f = FACING._value
        updateLocationFile()
    end,
    turnLeft = function() 
        FACING._update(-1)
    end,
    turnRight = function() 
        FACING._update(1)
    end,
    getFacing = function()
        return FACING._values[FACING._value+1]
    end,
    getFacingValue = function()
        return FACING._value
    end
}

pos = {
    _matrix = {
        {x = 1, y = 0, z = 0}, -- N
        {x = 0, y = 0, z = 1}, -- E
        {x = -1, y = 0, z = 0}, -- S
        {x = 0, y = 0, z = -1}, -- W
    },
    updateByName = function(name)
        tmp = pos._matrix[FACING.getFacingValue() + 1]
        if name == 'forward' then
            LOCATION.x = LOCATION.x + tmp.x
            LOCATION.z = LOCATION.z + tmp.z
        elseif name == 'back' then
            LOCATION.x = LOCATION.x - tmp.x
            LOCATION.z = LOCATION.z - tmp.z
        elseif name == 'up' then
            LOCATION.y = LOCATION.y + 1
        elseif name == 'down' then
            LOCATION.y = LOCATION.y - 1
        elseif name == 'turnLeft' then
            FACING.turnLeft()
        elseif name == 'turnRight' then
            FACING.turnRight()
        end
        updateLocationFile()
    end,
    getPos = function() 
        return LOCATION
    end,
    getX = function() 
        return LOCATION.x
    end,
    getY = function() 
        return LOCATION.y
    end,
    getZ = function() 
        return LOCATION.z
    end,
    getF = function()
        return FACING.getFacingValue()
    end,
    getFacing = function()
        return FACING.getFacing()
    end,
    isHome = function()
        return (LOCATION.x == 0) and (LOCATION.y == 0) and (LOCATION.z == 0)
    end,
    forward = function()
        pos.updateByName("forward")
    end,
    back = function()
        pos.updateByName("back")
    end,
    up = function()
        pos.updateByName("up")
    end,
    down = function()
        pos.updateByName("down")
    end,
    turnLeft = function()
        pos.updateByName("turnLeft")
    end,
    turnRight = function()
        pos.updateByName("turnRight")
    end,
}

function fetchLocationFromFile()
    h = fs.open(RECORD_FILE, "r")
    text = h.readAll()
    h.close()
    if string.match(text, "{") == false then
        updateLocationFile()
    else
        LOCATION = json.decode(text)
        FACING._value = LOCATION.f
    end
end

function cleanUp()
    cleanRecordFile()
    fetchLocationFromFile()
end

fetchLocationFromFile()

-- LOCATION = json.decode(hr.readAll())

-- print(LOCATION['x'])