setStage("vTunnel")

final = config.toDigdown

function showPercent()
    local p = (final - (pos.getY() * -1)) / final * 100
    gui.printpl(string.format("Stage : vTunnel. (%d)", 100-(math.floor(p*100)/100) ).."%")
end

local _ctn = 0
while pos.getY() < 0 do
    turtle.digUp()
    turtle.up()
    _ctn = _ctn + 1
    if _ctn >= 2 then
        break
    end
end
faceN()

if getSubstage() ~= "goHome" then
    setSubstage("mining")
    gui.printb("Digging the vertical tunnel.")

    while final - (pos.getY() * -1) >= 3 do
        showPercent()
        toZzero()
        toXzero()
        faceN()
        d333(cb)
    end

    while final - (pos.getY() * -1) > 0 do
        showPercent()
        toZzero()
        toXzero()
        faceN()
        d33(cb)
    end

    turtle.up()
    placeTorch()

    gui.printpl("")
    gui.printfo("back to home.")
end

setSubstage('goHome')
goHome()
gui.printfo("")
gui.printb("Done.", colors.green)
unLoadItem()