json = require "/libs/json"

if pos.isHome() then

    turtle.turnRight()
    gui.printb("Checking for chest... [1]")
    gui.waitCondition(function()
        flag, data = turtle.inspect()
        return flag == true and data.name == "minecraft:chest"
    end, "[STOP] Put a chest in front of the turtle.", "Waiting..........")
    turtle.turnLeft()
    gui.printb("OK", colors.green)

    turtle.turnLeft()
    gui.printb("Checking for chest... [2]")
    gui.waitCondition(function()
        flag, data = turtle.inspect()
        return flag == true and data.name == "minecraft:chest"
    end, "[STOP] Put a chest in front of the turtle.", "Waiting..........")
    turtle.turnRight()
    gui.printb("OK", colors.green)
 
    gui.printb("Checking for chest... [3]")
    gui.waitCondition(function()
        flag, data = turtle.inspectUp()
        return flag == true and data.name == "minecraft:chest"
    end, "[STOP] Put a chest on top of the turtle to continue.", "Waiting..........")
    gui.printb("OK", colors.green)
end

gui.printb("Checking for configuration...")
local config = nil
local config_file = "/.tmp/config"
if fs.exists("/.tmp") == false or fs.exists(config_file) == false then
    shell.run("mkdir /.tmp")
    require "/actions/config"
end

config = nil

h = fs.open(config_file, "r")
jsonStr = h.readLine()
h.close()

isOk, err = pcall(function()
    config = json.decode(jsonStr)
end)

if isOk then
    gui.printb("OK", colors.green)
    return config
else
    gui.printb("Error", colors.red)
    return false
end