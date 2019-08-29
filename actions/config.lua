gui.clear()

level = 0
minY = 0
currentY = 0
miningLevel = 0
levelM = 0
miningLength = 0

gui.printfo("press Ctrl+T to exit.")

repeat
    gui.printb("Enter the current Y level : ")
    currentY = tonumber(read())
until(currentY ~= nil)

repeat
    gui.printb("Enter the minum y level to dig down : ")
    minY = tonumber(read())
until(minY ~= nil)

level = currentY - minY
if level < 0 then
    term.clear()
    gui.showHeader()
    error("Error! current y level is less then the y level you want to dig down")
end

repeat
    gui.printb("Enter the y level to mining : ")
    miningLevel = tonumber(read())
until(miningLevel ~= nil)

if miningLevel - minY < 0 then
    term.clear()
    gui.showHeader()
    error("Error! The mining level is lower than the Minum level")
else
    levelM = currentY - miningLevel
end

repeat
    gui.printb("Enter the length of the tunnel : ")
    miningLength = tonumber(read())
until(miningLength ~= nil)

gui.clear()

gui.printfo("")
gui.printb("Summary")
gui.printb(string.format("Current y level : %d", currentY))
gui.printb(string.format("Minum y level to dig down : %d", minY))
gui.printb(string.format("Level to mining : %d", miningLevel))
gui.printb(string.format("Mining area : %d*%d", miningLength*2, miningLength*2))

repeat
    gui.printb("Confirm? (y/n)")
    confirm = read()
until(confirm == 'y' or confirm == 'n')

if(confirm ~= 'y') then
    term.clear()
    gui.showHeader()
    print("exit.")
    error("Stop by user.")
end

gui.printb("Checking fuel for digging down...")
gui.waitCondition(function()
    turtle.select(1)
    turtle.refuel(1)
    local max = (level * 9)
    local current = turtle.getFuelLevel()
    gui.printPreserveLine(string.format("Fuel : %d / %d", current, max))
    return current >= max
end, "[STOP] Please add some fuel into the left top slot of turtle.", nil)
gui.printb("OK", colors.green)

local data = {
    toDigdown = level,
    minY = minY,
    groundY = currentY,
    miningY = miningLevel,
    toMining = levelM,
    miningLength = miningLength
}
local DATA_FILE = "/.tmp/config"
h = fs.open(DATA_FILE, "w")
h.write(json.encode(data))
h.close()

gui.clear()
gui.printb("The turtle is ready for mining. Before mining, please add some fuel to the chest on the left hand side of the turtle.")
gui.printb("Also, add some torches to the chect on the right hand side of the turtle.")
gui.printb("Press any key to start...", colors.yellow)
os.pullEvent("key")
