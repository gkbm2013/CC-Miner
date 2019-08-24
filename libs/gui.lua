HEIGHT = 13
WIDTH = 39

FOOTER_CACHE = ""

local gui = {}

function gui.showHeader()
    local x, y = term.getCursorPos()
    term.setCursorPos(1, 1)
    print("=======================================")
    print("  Mining Program By GKB version 0.0.0  ")
    print("=======================================")
    term.setCursorPos(x, y)
end

function gui.showFooter()
    local x, y = term.getCursorPos()
    term.setBackgroundColor(colors.green)
    term.setCursorPos(1, 12)
    term.clearLine()
    term.setCursorPos(1, 13)
    term.clearLine()
    term.setBackgroundColor(colors.black)
    term.setCursorPos(x, y)
end

function gui.clear()
    term.clear()
    gui.showHeader()
    gui.showFooter()
    term.setCursorPos(1, 4)
end

function gui.init()
    gui.clear()
end

-- http://www.computercraft.info/forums2/index.php?/topic/15790-modifying-a-word-wrapping-function/
function wrap(str, limit)
    limit = limit or 39
    local here = 1
    local buf = ""
    local t = {}
    str:gsub("(%s*)()(%S+)()",
    function(sp, st, word, fi)
          if fi-here > limit then
             --# Break the line
             here = st
             table.insert(t, buf)
             buf = word
          else
             buf = buf..sp..word  --# Append
          end
    end)
    --# Tack on any leftovers
    if(buf ~= "") then
          table.insert(t, buf)
    end
    return t
end

function gui.printWrap(str)
    arr = wrap(str, 39)
    for k, v in pairs(arr) do
        local x, y = term.getCursorPos()
        term.write(v)
        term.setCursorPos(1, y+1)
    end
end

function gui.printFooter(str)
    local x, y = term.getCursorPos()
    gui.showFooter()
    term.setBackgroundColor(colors.green)
    term.setCursorPos(1, 12)
    str = string.sub(str, 0, WIDTH*2)
    gui.printWrap(str)
    FOOTER_CACHE = str
    term.setBackgroundColor(colors.black)
    term.setCursorPos(x, y)
end

function gui.printPreserveLine(str)
    local x, y = term.getCursorPos()
    term.setCursorPos(1, 11)
    str = string.sub(str, 0, WIDTH)
    term.setTextColor(colors.yellow)
    term.clearLine()
    term.write(str)
    term.setTextColor(colors.white)
    term.setCursorPos(x, y)
end

function gui.printBody(str, color)
    color = color or colors.white
    local x, y = term.getCursorPos()
    if y < 4 or y >= 12 then
        term.setCursorPos(1, 4)
    end
    lineNum = math.ceil((string.len(str)+2) / WIDTH)
    -- only have 8 to use (y4~y11)
    if y + lineNum > 11 then
        term.scroll(y + lineNum - 11)
        ctn = 0
        term.setCursorPos(1, 11)
        while(ctn < lineNum) do
            x, y = term.getCursorPos()
            term.clearLine()
            term.setCursorPos(x, y-1)
            ctn = ctn + 1
        end

        gui.showHeader()
        gui.showFooter()
        gui.printFooter(FOOTER_CACHE)
    end
    term.clearLine()
    term.setTextColor(colors.yellow)
    term.write("> ")
    term.setTextColor(color)
    print(str)
    term.setTextColor(colors.white)
end

function gui.printb(str, color)
    gui.printBody(str, color)
end

function gui.printfo(str)
    gui.printFooter(str)
end

function gui.printpl(str)
    gui.printPreserveLine(str)
end

function gui.repeats(s, n) return n > 0 and s .. gui.repeats(s, n-1) or "" end

function gui.waitCondition(func, foMsg, plMsg)
    while true do
        if func() == true then
            break
        else
            if foMsg ~= nil then gui.printfo(foMsg) end
            if plMsg ~= nil then gui.printPreserveLine(plMsg) end
        end
        sleep(0.25)
    end
    gui.printPreserveLine("")
    gui.printfo("")
end

return gui

