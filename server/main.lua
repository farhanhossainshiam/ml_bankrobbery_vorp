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

local msg = {
    reward = "You found $1000 and 3 golden bars!",
    robbing = "There are not enough police officers nearby",
    lockpick = "You do not have enough lockpicks",
}

-- Register the "mlpayout" server event
RegisterServerEvent("mlpayout")
AddEventHandler("mlpayout", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local _user = user

        -- Give the player money and items as a reward
        TriggerEvent("vorp:addMoney", _source, 0, 1000, _user)
        Inventory.addItem(_source, "goldbar", 3)
        -- Notify the player of their reward using vorp:NotifyLeft event
        TriggerClientEvent("vorp:NotifyLeft", _source, "Reward", msg.reward, "menu_textures", "log_gang_bag", 5000, "COLOR_GREEN")
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
            if policeCount >= Config.MinPoliceCount then
                -- Perform actions when there are 5 or more police
                Inventory.subItem(_source, "lockpick", 1)
                TriggerClientEvent('StartRobbing', _source)
            else
                -- Perform alternative actions when there are less than 5 police
                TriggerClientEvent("vorp:NotifyLeft", _source, "Robbery", msg.robbing, "menu_textures", "menu_icon_ability_defense", 5000, "COLOR_RED")
            end
        else
            TriggerClientEvent("vorp:NotifyLeft", _source, "Lockpick", msg.lockpick, "menu_textures", "menu_icon_info_lock", 5000, "COLOR_RED")
        end
    end)
end)
