json = require "/libs/json"
gui.clear()

MINING_RECORD_FILE = "/.tmp/mining"
STATUS = {
    stage = "vTunnel",
    x = 0, y = 0, z = 0, f = 0
}

function saveStage()
    local h = fs.open(MINING_RECORD_FILE, "w")
    h.write(json.encode(STATUS))
    h.close()
end

function loadStage()
    local h = fs.open(MINING_RECORD_FILE, "r")
    text = h.readAll()
    h.close()
    if string.match(text, "{") == false then
        saveStage()
    else
        STATUS = json.decode(text)
    end
end

function setStage(stage)
    STATUS.stage = stage
    saveStage()
end

function saveWorkingPos()
    STATUS.x = pos.getX()
    STATUS.y = pos.getY()
    STATUS.z = pos.getZ()
    STATUS.f = pos.getF()
    saveStage()
end

function backToWork()
    goTo(STATUS.x, STATUS.y, STATUS.z, STATUS.f, true)
end

function equipTorch(try)
    return equipItem(try, 16, "minecraft:torch")
end

function checkFuel(remain, try)
    remain = remain or 1280
    if turtle.getFuelLevel() <= pos.getX() + pos.getY() + pos.getZ() + (remain * 2) then
        gui.printfo("go home for refuel")
        saveWorkingPos()
        equipTorch(try)
        result = equipFuel((STATUS.x + STATUS.y + STATUS.z) + (remain * 2), try)
        if result == true then
            gui.printfo("back to work")
            backToWork()
            gui.printfo("")
        else
            gui.printfo("")
            gui.printb("[Error] Cannot refuel, please chek the fuel in the chest and retry.", colors.red)
            gui.printb("Press Enter to retry.")
            read()
            checkFuel(remain, try)
        end
    end
end

function checkTorch()
    detail = turtle.getItemDetail(16)
    if detail == nil or detail.name ~= "minecraft:torch" or detail.count <= 1 then
        gui.printfo("go home for adding torches")
        saveWorkingPos()
        local result = equipTorch()
        if result == true then
            gui.printfo("back to work")
            backToWork()
            gui.printfo("")
        else
            gui.printfo("")
            gui.printb("[Error] Cannot refunding torches, please add some torches in the chest and retry.", colors.red)
            gui.printb("Press Enter to retry.")
            read()
            checkTorch()
        end
    end
end

function unLoadItem()
    gui.printfo("go home for unloading item")
    saveWorkingPos()
    goHome()
    for i=1,15 do
        turtle.select(i)
        turtle.dropUp()
    end
    turtle.select(1)
    gui.printfo("try to load torch")
    equipTorch(2)
    gui.printfo("try to refuel")
    equipFuel((STATUS.x + STATUS.y + STATUS.z) + (1280), 2)
    gui.printfo("back to work")
    backToWork()
    gui.printfo("")
end

if fs.exists(MINING_RECORD_FILE) == false then
    saveStage()
end

loadStage()

-- gui.printb("Checking for torches... [1]")
-- gui.waitCondition(function()
--     flag, data = turtle.inspect()
--     return flag == true and data.name == "minecraft:chest"
-- end, "[STOP] Please put some torch in the chest in front of the turtle.", "Waiting..........")
-- gui.printb("OK", colors.green)

-- print(config.toDigdown)
-- goHome()

-- goTo(5, 6, 10, true)

-- goHome()

-- goTo(5, -10, 7)
-- gui.printb(turtle.getFuelLevel())
-- checkFuel()
-- gui.printb(turtle.getFuelLevel())

-- print(checkItemSpace())

cb = function(flag, msg)
    if string.find(msg, "no item space") then
        unLoadItem()
    elseif string.find(msg, "Unbreakable") then
        saveWorkingPos()
        goHome()
        error(string.format("encountered an unbreakable block at x: %d, y: %d, z: %d.  Hold Ctrl + R to restart the program.", STATUS.x, STATUS.y, STATUS.z))
    else
        saveWorkingPos()
        goHome()
        error(string.format("some error occured at x: %d, y: %d, z: %d. %s. Hold Ctrl + R to restart the program.", STATUS.x, STATUS.y, STATUS.z, msg))
    end
end

-- goHome()
if STATUS.stage == "vTunnel" then
    require("/mining/vTunnel")
    setStage('hTunnel')
end

if STATUS.stage == "hTunnel" then
    require("/mining/hTunnel")
end