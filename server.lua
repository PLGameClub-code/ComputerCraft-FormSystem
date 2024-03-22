term.setBackgroundColor(colors.red)
term.setTextColor(colors.blue)
term.clear()
local width, height = term.getSize()
term.setCursorPos(width/2, height/2)
term.write("Starting...")

-- Setup functions
local clock = os.clock
function sleep(n)  -- seconds
    local t0 = clock()
    while clock() - t0 <= n do end
end
function centerText(text)
    term.clear()
    term.setCursorPos((width/2)-(text:len() / 2), height/2)
    term.write(text)
end
function centerTextTop(text)
    term.clear()
    term.setCursorPos((width/2)-(text:len() / 2), 1)
    term.write(text)
end
function centerTextBottom(text)
    term.setCursorPos((width/2)-(text:len() / 2), ( height - 1 ))
    term.write(text)
end
function ask(text)
    term.setCursorPos(1, height/2)
    term.write("> ")
    return read()
end

-- Setup network communication
local modem = peripheral.find("modem") or error("No modem attached!")
local event, side, channel, replyChannel, message, distance
modem.open(1)
modem.open(2)

centerText("Started!")
sleep(1)

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if (channel == 2) then
        if (message == "OK") then
            modem.transmit(3, 2, "OK")
            term.clear()
            centerText("Client connected!")
        end
    elseif (channel == 1) then
        modem.transmit(3, 2, "OK")
        term.clear()
        centerTextTop("Form recived!")
        term.setCursorPos(1, 2)
        print(message)
    end
end