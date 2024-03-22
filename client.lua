admin_password = "test"

term.setBackgroundColor(colors.red)
term.setTextColor(colors.blue)
term.clear()
local width, height = term.getSize()
term.setCursorPos(width/2, height/2)
term.write("Starting...")

config = json.decodeFromFile("/forms/config")

os.pullEvent = os.pullEventRaw -- Disable terminate

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
modem.open(3)

centerText("Connecting to server...")
-- Connect to the server
repeat
    print(".")
    modem.transmit(2, 3, "OK")
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
until ( ( channel == 3 ) and ( message == "OK" ) )

centerText("Started!")
sleep(1)

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

while true do
    centerText("Press any key")
    local event, key = os.pullEvent('key')
    if (key == keys.esc) then
        centerTextTop("Enter admin password")
        if (ask() == admin_password) then
            centerTextTop("Admin shell")
            local command = ask()
            if (command == "exit") then
                print("Exited!")
            elseif (command == "terminate") then
                error("Terminated!")
            else
                print("Unknown command!")
            end
        else
            centerText("Wrong password!")
            sleep(1)
        end
    end

    local to_send = ""
    -- Text question
    centerTextTop("Text question")
    to_send = ( to_send .. "\n1: " .. ask() )
    centerTextTop("Text question")
    to_send = ( to_send .. "\n2: " .. ask() )
    centerTextTop("Text question")
    to_send = ( to_send .. "\n3: " .. ask() )
    centerTextTop("Submit the answers?")
    term.setCursorPos(1, 2)
    write(to_send)
    centerTextBottom("Press y to send the form or n to cancel!")
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.y) or (key == keys.n) )
    if (key == keys.y) then
        centerText("Sending...")
        repeat
            print(".")
            modem.transmit(1, 3, to_send)
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until ( ( channel == 3 ) and ( message == "OK" ) )
        centerText("Done!")
        sleep(5)
    else
        centerText("Submition canceled!")
        sleep(5)
    end
end