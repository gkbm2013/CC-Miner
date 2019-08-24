setStage("vTunnle")

final = config.toDigdown

function showPercent()
    local p = (final - (pos.getY() * -1)) / final * 100
    gui.printpl(string.format("Stage : vTunnle. (%d)", 100-(math.floor(p*100)/100) ).."%")
end

local _ctn = 0
while pos.getY() < 0 do
    turtle.up()
    _ctn = _ctn + 1
    if _ctn >= 2 then
        break
    end
end
faceN()

gui.printb("Digging the vertical tunnle.")

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

gui.printpl("")
gui.printfo("back to home.")
goHome()
gui.printfo("")
gui.printb("Done.", colors.green)