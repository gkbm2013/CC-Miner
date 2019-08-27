function wrapper()
    METADATA = {
        xMiddleLines = {},
        remaining = {}
    }
    
    local SUBSTAGE = {
        me = 'middleE',
        mw = 'middleW',
        ne = 'northE',
        nw2 = 'northE2',
        sw = 'southW',
        sw2 = 'southW2',
        gn = 'goHome',
        done = 'done'
    }
    
    function saveMetadata()
        STATUS.metadata = METADATA
        saveStage()
    end
    
    function fetchMetadata()
        METADATA = STATUS.metadata
    end
    
    if STATUS.metadata == nil then
        -- Claculate the middle line (x) of each mining tunnel
        for i=0,config.miningLength,5 do
        table.insert(METADATA.xMiddleLines, i)
        end
    
        for i=0-5,-config.miningLength,-5 do
        table.insert(METADATA.xMiddleLines, i)
        end
    
        METADATA.remaining = deepcopy(METADATA.xMiddleLines)
        saveMetadata()
    else
        fetchMetadata()
    end
    
    local currentMiddleLine = METADATA.xMiddleLines[0] or METADATA.xMiddleLines[1]
    
    _goHome = deepcopy(goHome)
    _goTo = deepcopy(goTo)
    goHome = function(...)
        if pos.getX() ~= currentMiddleLine then
            goToX(currentMiddleLine)
        end
        return _goHome(...)
    end
    goTo = function(x, y, z, f, force)
        if pos.getX() ~= currentMiddleLine then
            goToX(currentMiddleLine)
        end
    
        force = force or true
        goToY(y, force)
        goToZ(z, force)
        goToX(x, force)
    
        local df = 0
        if z - pos.getZ() > 0 then
            df = 1
        elseif z - pos.getZ() < 0 then
            df = 3
        end
    
        f = f or df
    
        while pos.getF() ~= f do
            turtle.turnRight()
        end
    end
    
    local _ctn = 0
    for k, v in pairs(METADATA.remaining) do
      _ctn = _ctn + 1
    end
    if _ctn == 0 then
        setSubstage(SUBSTAGE.done)
        setStage('done')
    else
        setStage('miningTunnel')
    end
    
    workingYPos = config.miningY - config.groundY
    gui.printb("Current : Mining Tunnel "..currentMiddleLine)
    
    if getSubstage() == nil then
        goTo(currentMiddleLine, workingYPos + 1, 0, 1)
        setSubstage(SUBSTAGE.me)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.me then
        faceE()
        backToWork()
        while pos.getZ() - config.miningLength < 0 do
            checkFuel(pos.getZ() - config.miningLength * -1)
            df3(cb)
            if math.fmod(pos.getZ() - 2, 11) == 0 then
                placeTorch()
            end
        end
        placeTorch()
        setSubstage(SUBSTAGE.mw)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.mw then
        if pos.getZ() > 0 then
            checkFuel()
            goTo(currentMiddleLine, workingYPos + 1, 0, 3)
            saveWorkingPos()
        end
        backToWork()
        faceW()
        while pos.getZ() + config.miningLength > 0 do
            checkFuel(pos.getZ() + config.miningLength)
            df3(cb)
            if math.fmod(pos.getZ() + 2, 11) == 0 then
                placeTorch()
            end
        end
        placeTorch()
        setSubstage(SUBSTAGE.ne)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.ne then
        backToWork()
        if pos.getF() ~= 1 or pos.getX() ~= currentMiddleLine+1 then
            checkFuel()
            goTo(currentMiddleLine+1, workingYPos + 1, -1*config.miningLength, 1)
        end
        saveWorkingPos()
        faceE()
        turtle.digUp()
        turtle.digDown()
        while pos.getZ() < 0 do
            checkFuel(pos.getZ() * -1)
            df3(cb)
        end
        setSubstage(SUBSTAGE.ne2)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.ne2 then
        backToWork()
        while pos.getZ() - config.miningLength < 0 do
            checkFuel(config.miningLength - pos.getZ())
            df3(cb)
        end
        setSubstage(SUBSTAGE.sw)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.sw then
        backToWork()
        if pos.getF() ~= 3 or pos.getX() ~= currentMiddleLine-1 then
            checkFuel()
            goTo(currentMiddleLine-1, workingYPos + 1, config.miningLength, 3)
        end
        saveWorkingPos()
        faceW()
        turtle.digUp()
        turtle.digDown()
        while pos.getZ() > 0 do
            checkFuel(pos.getZ())
            df3(cb)
        end
        setSubstage(SUBSTAGE.sw2)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.sw2 then
        backToWork()
        while pos.getZ() + config.miningLength > 0 do
            checkFuel(pos.getZ() + config.miningLength)
            df3(cb)
        end
        setSubstage(SUBSTAGE.gn)
        saveWorkingPos()
    end
    
    if getSubstage() == SUBSTAGE.gn then
        goHome()
    end
    
    local _temp = {}
    local _flag = false
    for k, v in pairs(METADATA.remaining) do
        if _flag == true then
            table.insert(_temp, v)
        end
        _flag = true
    end
    METADATA.remaining = _temp
    saveMetadata()
    
    gui.printb("Cooldown...")
    sleep(5)
    
    gui.printb("")
    
    goHome = _goHome
    goTo = _goTo
end