local Init = {
    Frameworks  =  { "es_extended", "qb-core" },
    Inventories =  { "qb-inventory", "esx_inventoryhud", "qs-inventory", "codem-inventory", "gfx-inventory", "ox_inventory" },
    SkinScripts =  { "esx_skin", "qb-clothing", "skinchanger", "illenium-appearance", "fivem-appearance" },
    SQLScripts  =  { "mysql-async", "ghmattimysql", "oxmysql" },
}

local initialized = false
local currentResourceName = GetCurrentResourceName()

---@class Utils

---@param name string The name of the event
---@param cb function The callback function
function RegisterCallback(name, cb)
    RegisterNetEvent(name, function(id, args)
        local src = source
        local eventName = currentResourceName..":triggerCallback:" .. id
        CreateThread(function()
            local result = cb(src, table.unpack(args))
            TriggerClientEvent(eventName, src, result)
        end)
    end)
end

Utils = {
    Framework,
    FrameworkObject,
    FrameworkShared,
    InventoryName,
    SQLScript
}

function GetFramework()
    return Utils.Framework
end

function GetFrameworkObject()
    return Utils.FrameworkObject
end

function GetFrameworkShared()
    return Utils.FrameworkShared
end

function InitalFunc()
    if initialized then return end
    initialized = true
    InitFramework()
    InitInventory()
    InitSkinScript()
    InitSQLScript()

    print("--------------["..currentResourceName.."]-----------------")
    print("Framework: "..(Utils.Framework or "Not found"))
    print("Inventory: "..(Utils.InventoryName or "Not found"))
    print("SkinScript: "..(Utils.SkinScript or "Not found"))
    print("SQLScript: "..(Utils.SQLScript or "Not found"))
    print("-------------- Script has initialized -------------------")
end

function InitFramework()
    if Utils.Framework ~= nil then return end
    for i = 1, #Init.Frameworks do
        if IsDuplicityVersion() then
            if GetResourceState(Init.Frameworks[i]) == "started" then
                Utils.Framework = Init.Frameworks[i]
                Utils.FrameworkObject = InitFrameworkObject()
                Utils.FrameworkShared = InitFrameworkShared()
            end
        else
            if GetResourceState(Init.Frameworks[i]) == "started" then
                Utils.Framework = Init.Frameworks[i]

                Utils.FrameworkObject = InitFrameworkObject()
                Utils.FrameworkShared = InitFrameworkShared()
            end
        end
    end
end

function InitFrameworkObject()
    if Utils.Framework == "es_extended" then
        local ESX = nil
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(1000)
        if ESX == nil then
            ESX = exports["es_extended"]:getSharedObject()
        end
        return ESX
    elseif Utils.Framework == "qb-core" then
        local QBCore = nil
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
        Citizen.Wait(1000)
        if QBCore == nil then
            QBCore = exports["qb-core"]:GetCoreObject()
        end
        return QBCore
    end
end

function InitFrameworkShared()
    while Utils.FrameworkObject == nil do
        Citizen.Wait(100)
    end
    if Utils.Framework == "qb-core" then
        return Utils.FrameworkObject.Shared
    elseif Utils.Framework == "es_extended" then
        return Utils.FrameworkObject.Config
    end
end

function InitInventory()
    for i = 1, #Init.Inventories do
        if IsDuplicityVersion() then
            if GetResourceState(Init.Inventories[i]) == "started" then
                Utils.InventoryName = Init.Inventories[i]
            end
        else
            if GetResourceState(Init.Inventories[i]) == "started" then
                Utils.InventoryName = Init.Inventories[i]
            end
        end
    end
end

function InitSkinScript()
    for i = 1, #Init.SkinScripts do
        if IsDuplicityVersion() then
            if GetResourceState(Init.SkinScripts[i]) == "started" then
                Utils.SkinScript = Init.SkinScripts[i]
            end
        else
            if GetResourceState(Init.SkinScripts[i]) == "started" then
                Utils.SkinScript = Init.SkinScripts[i]
            end
        end
    end
end

function InitSQLScript()
    for i = 1, #Init.SQLScripts do
        if IsDuplicityVersion() then
            if GetResourceState(Init.SQLScripts[i]) == "started" then
                Utils.SQLScript = Init.SQLScripts[i]
            end
        else
            if GetResourceState(Init.SQLScripts[i]) == "started" then
                Utils.SQLScript = Init.SQLScripts[i]
            end
        end
    end
end

---@param query string The query to execute
function ExecuteSql(query, parameters, cb)
    local promise = promise:new()
    if Utils.SQLScript == "oxmysql" then
        exports.oxmysql:execute(query, parameters, function(data)
            promise:resolve(data)
            if cb then
                cb(data)
            end
        end)
    elseif Utils.SQLScript == "ghmattimysql" then
        exports.ghmattimysql:execute(query, parameters, function(data)
            promise:resolve(data)
            if cb then
                cb(data)
            end
        end)
    elseif Utils.SQLScript == "mysql-async" then
        MySQL.Async.fetchAll(query, parameters, function(data)
            promise:resolve(data)
            if cb then
                cb(data)
            end
        end)
    end
    return Citizen.Await(promise)
end

---@param source number The players server id
function GetPlayer(source)
    if Utils.Framework == "es_extended" then
        return Utils.FrameworkObject.GetPlayerFromId(source)
    elseif Utils.Framework == "qb-core" then
        return Utils.FrameworkObject.Functions.GetPlayer(source)
    end
end

---@param identifier string The players identifier
function GetPlayerFromIdentifier(identifier)
    if Utils.Framework == "es_extended" then
        return Utils.FrameworkObject.GetPlayerFromIdentifier(identifier)
    elseif Utils.Framework == "qb-core" then
        return Utils.FrameworkObject.Functions.GetPlayerByCitizenId(identifier)
    end
end

---@param charId string The players character id
function GetPlayerFromCharacterId(charId)
    if Utils.Framework == "es_extended" then
        return Utils.FrameworkObject.GetPlayerFromCharacterId(charId)
    elseif Utils.Framework == "qb-core" then
        return Utils.FrameworkObject.Functions.GetPlayerByCitizenId(charId)
    end
end

---@param source number The players server id
function GetIdentifier(source)
    if Utils.Framework == "es_extended" then
        local player = GetPlayer(source)
        return player.identifier
    elseif Utils.Framework == "qb-core" then
        local player = GetPlayer(source)
        return player.PlayerData.citizenid
    end
end

---@param source number The players server id
function GetPlayerNameBySource(source)
    if Utils.Framework == "es_extended" then
        local player = GetPlayer(source)
        return player.getName()
    elseif Utils.Framework == "qb-core" then
        local player = GetPlayer(source)
        return player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname
    end
end

---@param item string The item name
---@param handler function The handler function
function RegisterItem(item, handler)
    if Utils.Framework == "es_extended" then
        Utils.FrameworkObject.RegisterUsableItem(item, handler)
    elseif Utils.Framework == "qb-core" then
        Utils.FrameworkObject.Functions.CreateUseableItem(item, handler)
    end
end

---@param id string|number The players identifier or server id
function GetPlayerSkinData(id)
    id = type(id) == "number" and GetIdentifier(id) or id
    local p = promise:new()
    if Utils.SkinScript == "qb-clothes" then
        ExecuteSql('SELECT * FROM playerskins WHERE citizenid = @citizenid AND active = @active', {
            ['@citizenid'] = id,
            ['@active'] = 1
        }, function(result)
            if result[1] ~= nil then
                p:resolve({tonumber(result[1].model), json.decode(result[1].skin)})
            else
                return p:resolve(nil)
            end
        end)
    elseif Utils.SkinScript == "skinchanger" then
        ExecuteSql('SELECT skin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = id
        }, function(result)
            if result[1] ~= nil then
                p:resolve({GetHashKey(result[1].skin), json.decode(result[1].skin)})
            else
                return p:resolve(nil)
            end
        end)
    elseif Utils.SkinScript == "fivem-appearance" then
        if Config.Framework == "es_extended" then
            ExecuteSql('SELECT skin FROM users WHERE identifier = @identifier', {
                ['@identifier'] = id
            }, function(result)
                if result[1] ~= nil then
                    local resSkin = json.decode(result[1].skin).model
                    p:resolve({resSkin, json.decode(result[1].skin)})
                else
                    return p:resolve(nil)
                end
            end)
        elseif Config.Framework == "qb-core" then
            ExecuteSql('SELECT skin FROM playerskins WHERE citizenid = @citizenid', {
                ['@citizenid'] = id
            }, function(result)
                if result[1] ~= nil then
                    local resSkin = json.decode(result[1].skin).model
                    p:resolve({resSkin, json.decode(result[1].skin)})
                else
                    return p:resolve(nil)
                end
            end)
        end
    elseif Utils.SkinScript == "illenium-appearance" then
        if Utils.Framework == "es_extended" then
            ExecuteSql('SELECT skin FROM users WHERE identifier = @identifier', {
                ['@identifier'] = id
            }, function(result)
                if result[1] ~= nil then
                    local resSkin = json.decode(result[1].skin).model
                    p:resolve({resSkin, json.decode(result[1].skin)})
                else
                    return p:resolve(nil)
                end
            end)
        elseif Utils.Framework == "qb-core" then
            ExecuteSql('SELECT skin FROM playerskins WHERE citizenid = @citizenid', {
                ['@citizenid'] = id
            }, function(result)
                if result[1] ~= nil then
                    local resSkin = json.decode(result[1].skin).model
                    p:resolve({resSkin, json.decode(result[1].skin)})
                else
                    return p:resolve(nil)
                end
            end)
        end
    elseif Utils.SkinScript == "esx_skin" then
        ExecuteSql('SELECT skin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = id
        }, function(result)
            if result[1] ~= nil then
                local resSkin = json.decode(result[1].skin).model
                p:resolve({resSkin, json.decode(result[1].skin)})
            else
                return p:resolve(nil)
            end
        end)
    end
    return Citizen.Await(p)
end

AddItem =  {
    ["esx_inventoryhud"] = function(source, item, count)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        xPlayer.addInventoryItem(item, count)
    end,
    ["qb-inventory"] = function(source, item, count, metadata, slot)
        exports["qb-inventory"]:AddItem(source, item, count, slot, metadata)
    end,
    ["gfx-inventory"] = function(source, item, count)
        exports["gfx-inventory"]:AddItem(source, "inventory", item, count)
    end,
    ["ox_inventory"] = function(source, item, count, metadata, slot)
        exports["ox_inventory"]:AddItem(source, item, count, metadata, slot)
        
    end,
    ["codem-inventory"] = function(source, item, count, metadata, slot)
        exports["codem-inventory"]:AddItem(source, item, count, slot, metadata)
    end,
    ["qs-inventory"] = function(source, item, count, metadata, slot)
        exports["qs-inventory"]:AddItem(source, item, count, slot, metadata)
    end
}

---@param source number The players server id
---@param item string The item name
---@param count number The amount of the item to add
---@param metadata table The metadata of the item
---@param slot number The slot of the item
function AddItem(source, item, count, metadata, slot)
    if AddItem[Utils.InventoryName] then
        AddItem[Utils.InventoryName](source, item, count, metadata, slot)
    end
end

RemoveItem = {
    ["esx_inventoryhud"] = function(source, item, count)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, count)
    end,
    ["qb-inventory"] = function(source, item, count, metadata, slot)
        exports["qb-inventory"]:RemoveItem(source, item, count, slot, metadata)
    end,
    ["gfx-inventory"] = function(source, item, count)
        exports["gfx-inventory"]:RemoveItem(source, "inventory", item, count)
    end,
    ["ox_inventory"] = function(source, item, count, metadata, slot)
        exports["ox_inventory"]:RemoveItem(source, item, count, metadata, slot)
    end,
    ["codem-inventory"] = function(source, item, count, metadata, slot)
        exports["codem-inventory"]:RemoveItem(source, item, count, slot)
    end,
    ["qs-inventory"] = function(source, item, count, metadata, slot)
        exports["qs-inventory"]:RemoveItem(source, item, count, slot, metadata)
    end
}

---@param source number The players server id
---@param item string The item name
---@param count number The amount of the item to remove
---@param metadata table The metadata of the item
---@param slot number The slot of the item
function RemoveItem(source, item, count, metadata, slot)
    if RemoveItem[Utils.InventoryName] then
        RemoveItem[Utils.InventoryName](source, item, count, metadata, slot)
    end
end

GetInventory = {
    ["esx_inventoryhud"] = function(source)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        return xPlayer.getInventory()
    end,
    ["qb-inventory"] = function(source)
        local player = GetPlayer(source)
        return player.PlayerData.items
    end,
    ["gfx-inventory"] = function(source)
        return exports["gfx-inventory"]:GetInventory(source, "inventory")
    end,
    ["ox_inventory"] = function(source)
        return exports["ox_inventory"]:GetInventoryItems(source)
    end,
    ["codem-inventory"] = function(source)
        local identifier = type(source) == "string" and source or nil
        return exports["codem-inventory"]:GetInventory(identifier, source)
    end,
    ["qs-inventory"] = function(source)
        return exports["qs-inventory"]:GetInventory(source)
    end
}

---@param source number The players server id
function GetInventory(source)
    if GetInventory[Utils.InventoryName] then
        return GetInventory[Utils.InventoryName](source)
    end
end

HasItem = {
    ["esx_inventoryhud"] = function(source, item, count)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item).count >= count
    end,
    ["qb-inventory"] = function(source, item, count)
        return exports["qb-inventory"]:HasItem(source, item, count)
    end,
    ["gfx-inventory"] = function(source, item, count)
        return exports["gfx-inventory"]:HasItem(source, "inventory", item, count)
    end,
    ["ox_inventory"] = function(source, item, count)
        return exports["ox_inventory"]:GetItemCount(source, item) >= count
    end,
    ["codem-inventory"] = function(source, item, count)
        return exports["codem-inventory"]:HasItem(source, item, count)
    end,
    ["qs-inventory"] = function(source, item, count)
        return exports["qs-inventory"]:GetItemTotalAmount(source, item) >= count
    end
}

GetMoney = {
    ["es_extended"] = function(source)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        return xPlayer.getMoney()
    end,
    ["qb-core"] = function(source)
        local player = GetPlayer(source)
        return player.PlayerData.money["cash"]
    end
}

---@param source number The players server id
function GetMoney(source)
    if GetMoney[Utils.Framework] then
        return GetMoney[Utils.Framework](source)
    end
end

AddMoney = {
    ["es_extended"] = function(source, amount)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        xPlayer.addMoney(amount)
    end,
    ["qb-core"] = function(source, amount)
        local player = GetPlayer(source)
        player.Functions.AddMoney("cash", amount)
    end
}

---@param source number The players server id
---@param amount number The amount of money to add
function AddMoney(source, amount)
    if AddMoney[Utils.Framework] then
        AddMoney[Utils.Framework](source, amount)
    end
end

RemoveMoney = {
    ["es_extended"] = function(source, amount)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        xPlayer.removeMoney(amount)
    end,
    ["qb-core"] = function(source, amount)
        local player = GetPlayer(source)
        player.Functions.RemoveMoney("cash", amount)
    end
}

---@param source number The players server id
---@param amount number The amount of money to remove
function RemoveMoney(source, amount)
    if RemoveMoney[Utils.Framework] then
        RemoveMoney[Utils.Framework](source, amount)
    end
end

HasMoney = {
    ["es_extended"] = function(source, amount)
        local xPlayer = Utils.FrameworkObject.GetPlayerFromId(source)
        return xPlayer.getMoney() >= amount
    end,
    ["qb-core"] = function(source, amount)
        local player = GetPlayer(source)
        return player.PlayerData.money["cash"] >= amount
    end
}

---@param source number The players server id
---@param amount number The amount of money to check
function HasMoney(source, amount)
    if HasMoney[Utils.Framework] then
        return HasMoney[Utils.Framework](source, amount)
    end
end

---@param source number The players server id
---@param item string The item name
---@param count number The amount of the item to remove
function HasItem(source, item, count)
    if HasItem[Utils.InventoryName] then
        return HasItem[Utils.InventoryName](source, item, count)
    end
end

---@param source number The players server id
---@param item string The item name
---@param count number The amount of the item to remove
function AddVehicleToPlayer(source, vehicle, props)
    local xPlayer = GetPlayer(source)
    local plate = CreateRandomPlate()

    if Utils.Framework == "qb-core" then
        local cid = xPlayer.PlayerData.citizenid
        ExecuteSql("INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES ('"..xPlayer.PlayerData.license.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '"..json.encode(props).."', '"..plate.."', '".."pillboxgarage".."', '0')")
    elseif Utils.Framework == "es_extended" then
        local xPlayer = Framework.GetPlayerFromId(source)
        ExecuteSql("INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES ('"..xPlayer.identifier.."', '"..plate.."', '"..json.encode(json.encode(props)).."', '".."car".."', '0')")
    end
end

function CreateRandomPlate()
    local plate = ""
    for i = 1, 8 do
        plate = plate .. string.char(math.random(65, 90))
    end
    return plate
end

Citizen.CreateThread(function()
    InitalFunc()
end)