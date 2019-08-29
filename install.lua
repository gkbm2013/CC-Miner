function clear()
    term.clear()
    term.setCursorPos(1, 4)
end

function download(path)
    local baseUrl = "https://raw.githubusercontent.com/gkbm2013/CC-Miner/master/"
    shell.run(string.format("wget %s %s", baseUrl..path, path))
end

clear()

print("Computer Craft Mining Program Installer")

print("Creating directory...")
shell.run("mkdir actions")
shell.run("mkdir libs")
shell.run("mkdir mining")

print("Downloading files...")
download("/actions/config.lua")
download("/actions/init.lua")
download("/actions/mining.lua")

download("/libs/equipLib.lua")
download("/libs/gui.lua")
download("/libs/json.lua")
download("/libs/mapLib.lua")
download("/libs/positionLib.lua")

download("/mining/hTunnel.lua")
download("/mining/miningTunnel.lua")
download("/mining/vTunnel.lua")

download("master.lua")

shell.run("label set Miner")

print("Done!")

flag = true;
print("Do you want to automatically start the mining program when booting? (Y/n)")
while true do
    event, p1 = os.pullEvent()
    if event == "key" then
        if p1 == 21 or p1 == 28 then
            flag = true
            break
        elseif p1 == 49 then
            flag = false
            break
        end
    end
end

if flag then
    local h = fs.open("startup.lua", fs.exists("startup.lua") and "a" or "w")
    h.writeLine("")
    h.writeLine("-- The mining program")
    h.writeLine('shell.run("/master")')
    h.flush()
    h.close()
end

print("")
print("Done! You can use the command 'shell master' to start the mining program.")
print("")

flag = true
print("Start the mining program now? (Y/n)")
while true do
    event, p1 = os.pullEvent()
    if event == "key" then
        if p1 == 21 or p1 == 28 then
            flag = true
            break
        elseif p1 == 49 then
            flag = false
            break
        end
    end
end

if flag then
    shell.run("shell /master")
end