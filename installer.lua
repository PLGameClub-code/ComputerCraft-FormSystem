term.setBackgroundColor(colors.gray)
term.clear()
term.setTextColor(colors.black)
if not term.isColor() then
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
    term.write("This application is intented to run on the advanced computer!")
    term.setCursorPos((width/2)-(text:len() / 2), height/2)
    term.write("Do you want to continue anyways? Press y/n.")
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
    term.write("WARNING: Some features can break!")
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.y) or (key == keys.n) )
    if (key == keys.n) then
        error("Installation canceled")
    end
end

url = "https://raw.githubusercontent.com/PLGameClub-code/ComputerCraft-FormSystem/main/"

select = 1
while select_active do
    term.setBackgroundColor(colors.gray)
    term.clear()
    term.setTextColor(colors.black)
    term.setCursorPos((width/2)-(text:len() / 2), 1)
    term.write("Select device type")
    if (select == 1) then
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.green)
        term.write("X - Client")
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.black)
        term.write("O - Server")
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.black)
        term.write("O - Cancel")
    elseif (select == 2) then
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.black)
        term.write("O - Client")
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.green)
        term.write("X - Server")
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.black)
        term.write("O - Cancel")
    elseif (select == 3) then
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.black)
        term.write("O - Client")
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.black)
        term.write("O - Server")
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.green)
        term.write("X - Cancel")
    elseif (select > 3) then
        select = 3
    else
        select = 1
    end
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.up) or (key == keys.down) or (key == keys.enter) )
    if (key == keys.up) then
        select = select + 1
    elseif (key == keys.down) then
        select = select - 1
    elseif (key == keys.enter) then
        if (select == 1) then
            url = (url .. "installer-client.lua")
        elseif (select == 2) then
            url = (url .. "installer-server.lua")
        elseif (select == 3) then
            error("Installation canceled")
        end
    end
end

print(url)
local content = http.get(url).readAll()
if not content then
    error("Could not download the installer!")
end
local f = fs.open(file, "w")
f.write(content)
f.close()