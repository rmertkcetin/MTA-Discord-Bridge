addCommandHandler("register", function(player)
    local login = getPlayerAccount(player)
    if isGuestAccount(login) then return end

    local loginName = getAccountName(login)
    local code = string.format("%04d", math.random(1000, 9999))
    
    local db = getDatabase()
    if not db then return end

    dbQuery(function(qh, p, c)
        local result = dbPoll(qh, 0)
        if not result then return end
        
        if isElement(p) then 
            if #result > 0 then
                local accountData = result[1]
                
                if accountData.discordid then 
                    -- user already linked accounts
                    return 
                end
                
                dbExec(db, "INSERT INTO account_codes (accountid, code) VALUES (?, ?) ON DUPLICATE KEY UPDATE code = ?", accountData.id, c, c)
                
                -- code created
            else
                -- error
            end
        end
    end, {player, code}, db, "SELECT id, discordid FROM accounts WHERE loginname = ?", loginName)
end, false)