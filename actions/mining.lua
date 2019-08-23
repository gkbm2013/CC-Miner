json = require "/libs/json"
gui.clear()

MINING_RECORD_FILE = "/.tmp/mining"
STATUS = {
    stage = "vTunnle",
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
            goTo(STATUS.x, STATUS.y, STATUS.z, STATUS.f)
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
            goTo(STATUS.x, STATUS.y, STATUS.z, STATUS.f)
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

checkFuel(80, 1)
gui.printb("GO!")