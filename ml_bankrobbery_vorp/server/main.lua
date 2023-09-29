local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Import the VORP Inventory and other dependencies if necessary
Inventory = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData", function(call)
    data = call
end)



-- Register the "mlpayout" server event
RegisterServerEvent("mlpayout")
AddEventHandler("mlpayout", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local _user = user

        -- Give the player money and items as a reward
        TriggerEvent("vorp:addMoney", _source, 0, 1000, _user)
        Inventory.addItem(_source, "goldbar", 3)
        -- Notify the player of their reward
        TriggerClientEvent("vorp:Tip", _source, 'You found 1000$ and 3 golden bars!', 5000)
    end)
end)

-- Register the "lockpick" server event
RegisterServerEvent('lockpick')
AddEventHandler('lockpick', function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local count = Inventory.getItemCount(_source, "lockpick")
        local policeCount = 0

        -- Calculate the number of police officers
        for _, player in ipairs(GetPlayers()) do
            local Character = VORPcore.getUser(player).getUsedCharacter
            if Character.job == "police" then
                policeCount = policeCount + 1
            end
        end

        if count >= 1 then
            -- Check the police count and execute the appropriate action
            if policeCount >= 5 then
                -- Perform actions when there are 5 or more police
                Inventory.subItem(_source, "lockpick", 1)
                TriggerClientEvent('StartRobbing', _source)
            else
                -- Perform alternative actions when there are less than 5 dashes
                TriggerClientEvent("vorp:Tip", _source, 'There are not enough police officers nearby', 5000)
            end
        else
            TriggerClientEvent("vorp:Tip", _source, 'You do not have enough lockpicks', 5000)
        end
    end)
end)