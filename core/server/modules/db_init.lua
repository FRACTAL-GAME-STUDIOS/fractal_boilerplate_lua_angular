if not MySQL then
    print('MySQL is not loaded, please uncomment the MySQL resource in your server.cfg or fxmanifest.lua of this resource.')
    return
end

function Load()
    MySQL.query([[

    ]], {}, function(response)
        if response.changedRows > 0 then
            
        end
    end)
end

MySQL.ready(function()
    Load()
end)