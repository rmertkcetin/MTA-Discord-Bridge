local webhookURL = "" -- Discord channel webhook

-- Send messages to Discord from game (start)
function sendToDiscord(message)
    local jsonData = toJSON({content=message}):sub(2,-2)
    
    local data = {
        method = "POST",
        headers = {["Content-Type"]="application/json"},
        postData = jsonData
    }
    
    fetchRemote(webhookURL, data, function(answerData, answerInfo)end)
end

addEventHandler("onPlayerChat", root, function(message, chatType)
    local playerName = string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","")
    local message = string.gsub(message,"#%x%x%x%x%x%x","")
    if chatType ~= 0 then return false end
    message = "**"..playerName.."**: "..message
    if message == "" then return false end
    sendToDiscord(message)
end)
-- Send messages to Discord from game (end)

-- Send messages to game from Discord
function sendToGame(playerName, message)
    if not playerName or not message then return false end
    outputChatBox("#1C7BD2[Discord] #FFFFFF"..playerName..": "..message,root,255,255,255,true)
    return true
end

-- Create user data on login (if already have data update it)
addEventHandler("onPlayerLogin", root, function(_, account)
    local playerName = getPlayerName(source)
    local loginName = getAccountName(account)
    local db = getDatabase()
    if not db then return end

    setElementData(source, "session_start", getTickCount(), false)

    dbExec(db, "INSERT INTO accounts (loginname, playername) VALUES (?, ?) ON DUPLICATE KEY UPDATE playername = ?", loginName, playerName, playerName)

    local query = [[SELECT p.aclname FROM account_permissions p JOIN accounts a ON p.accountid = a.id WHERE a.loginname = ? AND (p.expiredate > NOW() OR p.expiredate IS NULL)]]
    
    dbQuery(function(queryHandle)
        local results = dbPoll(queryHandle, 0)
        if results and #results > 0 then
            for _, row in ipairs(results) do
                local group = aclGetGroup(row.aclname)
                if group then
                    aclGroupAddObject(group,"user."..loginName)
                    outputDebugString(loginName.." + "..row.aclname)
                end
            end
        end
    end, db, query, loginName)
end)

-- update username (start)
addEventHandler("onPlayerQuit", root, function()
    local account = getPlayerAccount(source)
    if not isGuestAccount(account) then
        refreshDatabase(source, account)
    end
end)

addEventHandler("onPlayerLogout", root, function(_, account)
    refreshDatabase(source, account)
end)

addEventHandler("onPlayerChangeNick", root, function(old, new)
    local account = getPlayerAccount(source)
    if isGuestAccount(account) then return end
    
    local loginName = getAccountName(account)
    local db = getDatabase()
    
    if db then
        dbExec(db, "UPDATE accounts SET playername = ? WHERE loginname = ?", new, loginName)
    end
end)
-- update username (end)