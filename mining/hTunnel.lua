local SUBSTAGE = {
    mn = 'middleN',
    ms = 'middleS',
    wn = 'westN',
    wn2 = 'westN2',
    es = 'eastS',
    es2 = 'eastS2',
    gn = 'goHome',
}

setStage('hTunnel')

workingYPos = config.miningY - config.groundY

gui.printb("Digging the horizontal tunnel.")

if getSubstage() == nil then
    goTo(0, workingYPos + 1, 0, 0)
    setSubstage(SUBSTAGE.mn)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.mn then
    faceN()
    backToWork()
    while pos.getX() - config.miningLength < 0 do
        checkFuel(pos.getX() - config.miningLength * -1)
        df3(cb)
        if math.fmod(pos.getX() - 2, 11) == 0 then
            placeTorch()
        end
    end
    placeTorch()
    setSubstage(SUBSTAGE.ms)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.ms then
    if pos.getX() > 0 then
        checkFuel()
        goTo(0, workingYPos + 1, 0, 2)
        saveWorkingPos()
    end
    backToWork()
    faceS()
    while pos.getX() + config.miningLength > 0 do
        checkFuel(pos.getX() + config.miningLength)
        df3(cb)
        if math.fmod(pos.getX() + 2, 11) == 0 then
            placeTorch()
        end
    end
    placeTorch()
    setSubstage(SUBSTAGE.wn)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.wn then
    backToWork()
    if pos.getF() ~= 0 or pos.getZ() ~= -1 then
        checkFuel()
        goTo(-1*config.miningLength, workingYPos + 1, -1, 0)
    end
    saveWorkingPos()
    turtle.digUp()
    turtle.digDown()
    while pos.getX() < 0 do
        checkFuel(pos.getX() * -1)
        df3(cb)
    end
    setSubstage(SUBSTAGE.wn2)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.wn2 then
    backToWork()
    while pos.getX() - config.miningLength < 0 do
        checkFuel(config.miningLength - pos.getX())
        df3(cb)
    end
    setSubstage(SUBSTAGE.es)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.es then
    backToWork()
    if pos.getF() ~= 2 or pos.getZ() ~= 1 then
        checkFuel()
        goTo(config.miningLength, workingYPos + 1, 1, 2)
    end
    saveWorkingPos()
    turtle.digUp()
    turtle.digDown()
    while pos.getX() > 0 do
        checkFuel(pos.getX())
        df3(cb)
    end
    setSubstage(SUBSTAGE.es2)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.es2 then
    backToWork()
    while pos.getX() + config.miningLength > 0 do
        checkFuel(pos.getX() + config.miningLength)
        df3(cb)
    end
    setSubstage(SUBSTAGE.gn)
    saveWorkingPos()
end

if getSubstage() == SUBSTAGE.gn then
    goHome()
end

gui.printb("")