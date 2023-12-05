-- lua function 
function checkCapital()
    if (Config.Framework == "esx") then
        if (Config.Capital == 'money') then
            return GetMoney()
        elseif (Config.Capital == 'bank') then
            return GetBankMoney()
        end
    elseif (Config.Framework == "qbcore") then
        if (Config.Capital == 'money') then
            return GetMoney()
        elseif (Config.Capital == 'bank') then
            return GetBankMoney()
        end
    end
end

function splitPrice(price)
    price = tostring(price)
    local formatted = price
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end