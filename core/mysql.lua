local database = nil

local dbIp = "127.0.0.1"    -- server ip
local dbPort = 3306         -- server port
local dcUser = "root"       -- server username
local dbPass = ""           -- server password
local dbName = "mta_sunucu" -- server db name

addEventHandler("onResourceStart", resourceRoot, function()
    database = dbConnect("mysql", "dbname=" .. dbName .. ";host=" .. dbIp .. ";port=" .. dbPort .. ";charset=utf8", dcUser, dbPass)
    
    if database then
        outputDebugString("[MYSQL] +") -- if you see this on debug log connection is good!
    else
        outputDebugString("[MYSQL] -", 1) -- if you see this on debug log connection is NOT good.
    end
end)

function getDatabase()
    return database
end