function init()
    turtle.turnRight()
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()

    turtle.digDown()
    turtle.down()

    turtle.digDown()
    turtle.down()
end

function dig3x3()
    turtle.dig()
    turtle.forward()
    turtle.digUp()
    turtle.digDown()

    turtle.turnRight()

    turtle.dig()
    turtle.forward()
    turtle.digUp()
    turtle.digDown()

    turtle.turnRight()
    turtle.turnRight()
    
    turtle.forward()

    turtle.dig()
    turtle.forward()
    turtle.digUp()
    turtle.digDown()

    turtle.back()
    turtle.turnRight()
end

function moveDown()
    turtle.digDown()
    turtle.down()

    turtle.digDown()
    turtle.down()

    turtle.digDown()
    turtle.down()
end

init()

till = 15

for i = 1, till do
    print(i)
    dig3x3()
    dig3x3()
    turtle.back()
    turtle.back()
    moveDown()
end

for i = 1, till*3+2 do
    turtle.up()
end

turtle.forward()