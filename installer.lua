width, height = term.getSize()
term.setBackgroundColor(colors.gray)
term.clear()
term.setTextColor(colors.black)

function cancel(reason)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    term.clear()
    if not reason then
        error("Installation canceled")
    else
        error("Installation canceled.\nReason: " .. reason .. "\n\nYou can contact us on the github issues page:\nhttps://ln.plgame.club/t8SO")
    end
end

if fs.exists("/forms") then
    term.setTextColor(colors.red)
    local text = "This application is already installed!"
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
    term.write(text)
    text = "Do you want to continue anyways? Press y/n."
    term.setCursorPos((width/2)-(text:len() / 2), height/2)
    term.write(text)
    text = "WARNING: This will delete the existing installation!"
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
    term.write(text)
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.y) or (key == keys.n) )
    if (key == keys.n) then
        cancel()
    end
end

if not term.isColor() then
    term.setTextColor(colors.red)
    local text = "This application is intented to run on the advanced computer!"
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
    term.write(text)
    text = "Do you want to continue anyways? Press y/n."
    term.setCursorPos((width/2)-(text:len() / 2), height/2)
    term.write(text)
    text = "WARNING: Some features can break!"
    term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
    term.write(text)
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.y) or (key == keys.n) )
    if (key == keys.n) then
        cancel()
    end
end

url = "https://raw.githubusercontent.com/PLGameClub-code/ComputerCraft-FormSystem/main/"

select = 1
select_active = true
while select_active do
    term.setBackgroundColor(colors.gray)
    term.clear()
    term.setTextColor(colors.white)
    local text = "Select device type"
    term.setCursorPos((width/2)-(text:len() / 2), 1)
    term.write(text)
    if (select == 1) then
        text = "X - Client"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.green)
        term.write(text)
        text = "O - Server"
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.black)
        term.write(text)
        text = "O - Cancel"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.black)
        term.write(text)
    elseif (select == 2) then
        text = "O - Client"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.black)
        term.write(text)
        text = "X - Server"
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.green)
        term.write(text)
        text = "O - Cancel"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.black)
        term.write(text)
    elseif (select == 3) then
        text = "O - Client"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) - 1)
        term.setTextColor(colors.black)
        term.write(text)
        text = "O - Server"
        term.setCursorPos((width/2)-(text:len() / 2), height/2)
        term.setTextColor(colors.black)
        term.write(text)
        text = "X - Cancel"
        term.setCursorPos((width/2)-(text:len() / 2), (height/2) + 1)
        term.setTextColor(colors.green)
        term.write(text)
    end
    repeat
        event, key = os.pullEvent("key")
    until ( (key == keys.up) or (key == keys.down) or (key == keys.enter) )
    if (key == keys.up) then
        if (select > 1) then
            select = select - 1
        end
    elseif (key == keys.down) then
        if (select < 3) then
            select = select + 1
        end
    elseif (key == keys.enter) then
        select_active = false
        if (select == 1) then
            url = (url .. "installer-client.lua")
        elseif (select == 2) then
            url = (url .. "installer-server.lua")
        elseif (select == 3) then
            cancel()
        end
    end
end

print(url)
local content = http.get(url)
if not content then
    cancel("Could not download the installer")
end
content = content.readAll()
local f = fs.open("installer.lua", "w")
f.write(content)
f.close()

if fs.exists("/forms") then
    fs.delete("/forms")
end
fs.makeDir("/forms")

shell.run("installer.lua")

fs.delete("installer.lua")