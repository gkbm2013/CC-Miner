require "/libs/equipLib"
gui = require "/libs/gui"

gui.init()
config = require "/actions/init"

if config == false then
    error("Somthing went wrong. Fix the issue by executing this command 'rm /.tmp/config'")
end

gui.printb("Summary")
gui.printb(string.format("Current y level : %d", config.groundY))
gui.printb(string.format("Minum y level : %d", config.minY))
gui.printb(string.format("Mining y level : %d", config.miningY))
gui.printb(string.format("Mining area : %d*%d", config.miningLength*2, config.miningLength*2))

gui.printfo("Press \"r\" for re-configuration")

re_conf = false
 
function quitProgram()
    param1 = nil
    repeat
        event, param1 = os.pullEvent("char")
    until param1 == "r"
    re_conf = true
end

local WAIT = 0

parallel.waitForAny(quitProgram, function()
    for i=WAIT,0,-1 do
        gui.printPreserveLine(string.format("Waiting... %d", i))
        sleep(1)
    end
end)

gui.printfo("")

if re_conf then
    shell.run("rm /.tmp/config")
    shell.run("rm /.tmp/mining")
    shell.run("/master")
    return
end

setRetry(100)
gui.printb("GO!")
require "/actions/mining"