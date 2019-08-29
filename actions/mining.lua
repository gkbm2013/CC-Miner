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
    sleep(0.05)
end

function backToWork()
    goTo(STATUS.x, STATUS.y, STATUS.z, STATUS.f, true)
end

function equipTorch(try)

    return equipItem(try, 16, "minecraft:torch", 'right')
end

function checkFuel(remain, try)
    remain = remain or 1280
    gui.printpl(string.format("Fuel Level : %d", turtle.getFuelLevel()))
    if turtle.getFuelLevel() <= pos.getX() + pos.getY() + pos.getZ() + (remain * 2) then
        gui.printfo("go home for refuel")
        saveWorkingPos()
        equipTorch(try)
        result = equipFuel((STATUS.x + STATUS.y + STATUS.z) + (remain * 2), try, 'left')
        if result == true then
            gui.printfo("back to work")
            backToWork()
            gui.printfo("")
        else
            gui.printfo("")
            gui.printb("[Error] Cannot refuel, put some fuel in the box on the left hand side of the turtle.", colors.red)
            gui.printb("Press Enter to retry.")
            read()
            checkFuel(remain, try)
        end
    end
end

function checkTorch(try)
    detail = turtle.getItemDetail(16)
    if detail == nil or detail.name ~= "minecraft:torch" or detail.count <= 1 then
        gui.printfo("go home for adding torches")
        saveWorkingPos()
        local result = equipTorch(try)
        if result == true then
            gui.printfo("back to work")
            backToWork()
            gui.printfo("")
        else
            gui.printfo("")
            gui.printb("[Error] Cannot refunding torches, put some torches in the box on the right hand side of the turtle.", colors.red)
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
        local detail = turtle.getItemDetail()
        if detail ~= nil and detail.name == "minecraft:torch" then
            local flag = turtle.transferTo(16)
            if flag == false then
                turtle.dropUp()
            end
        else
            turtle.dropUp()
        end
    end
    turtle.select(1)
    gui.printfo("try to load torch")
    equipTorch(2)
    gui.printfo("try to refuel")
    equipFuel((STATUS.x + STATUS.y + STATUS.z) + (1280), 2, 'left')
    gui.printfo("back to work")
    backToWork()
    gui.printfo("")
end

function placeTorch()
    checkTorch()
    turtle.select(16)
    local flag = turtle.placeDown()
    turtle.select(1)
    return flag
end

if fs.exists(MINING_RECORD_FILE) == false then
    saveStage()
end

function setSubstage(str)
    STATUS.substage = str
    saveStage()
end

function getSubstage()
    return STATUS.substage
end

loadStage()

gui.printb("Checking for torches...")
gui.waitCondition(function()
    local result = equipTorch(1)
    return result == true
end, "[STOP] Add some torch to the chest on the right hand side of the turtle.", "Waiting..........")
gui.printb("OK", colors.green)

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

if STATUS.stage == "vTunnel" then
    require("/mining/vTunnel")
    saveWorkingPos()
    setSubstage(nil)
    setStage('hTunnel')
end

if STATUS.stage == "hTunnel" then
    require("/mining/hTunnel")
    unLoadItem()
    setSubstage(nil)
    setStage('miningTunnel')
end

require("/mining/miningTunnel")

if STATUS.stage == "miningTunnel" then
    while getSubstage() == nil or STATUS.stage ~= "done" do
        wrapper()
        goHome()
        saveWorkingPos()
        unLoadItem()
        gui.printb("Cooldown...")
        sleep(3)
        setSubstage('NAN')
        gui.printb("Go to next mining tunnel.")
    end
end

if STATUS.stage == "done" then
    goHome()
    unLoadItem()
    gui.printb("MINING FINISHED!", colors.green)
end