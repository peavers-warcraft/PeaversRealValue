local addonName, PRV = ...

local PeaversCommons = _G.PeaversCommons
local Utils = PeaversCommons.Utils

PRV.ConsumableTracker = {}
local ConsumableTracker = PRV.ConsumableTracker

local spellToItem = {}
local rebuildPending = false
local pendingMessages = {}

local function IsConsumable(itemID)
    local _, _, _, _, _, _, _, _, _, _, _, classID = GetItemInfo(itemID)
    return classID == Enum.ItemClass.Consumable
end

function ConsumableTracker:RebuildSpellMap()
    spellToItem = {}

    for bag = 0, NUM_BAG_SLOTS do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemID = C_Container.GetContainerItemID(bag, slot)
            if itemID and IsConsumable(itemID) then
                local spellName, spellID = C_Item.GetItemSpell(itemID)
                if spellID then
                    spellToItem[spellID] = itemID
                end
            end
        end
    end

    Utils.Debug(PRV, "Consumable spell map rebuilt")
end

function ConsumableTracker:ScheduleRebuild()
    if rebuildPending then return end
    rebuildPending = true
    C_Timer.After(0.5, function()
        rebuildPending = false
        self:RebuildSpellMap()
    end)
end

local function GetAutoChatType()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        return "INSTANCE_CHAT"
    elseif IsInRaid() then
        return "RAID"
    elseif IsInGroup() then
        return "PARTY"
    else
        return "SAY"
    end
end

local CHANNEL_MAP = {
    say = "SAY",
    party = "PARTY",
    guild = "GUILD",
    instance = "INSTANCE_CHAT",
    raid = "RAID",
}

function ConsumableTracker:PrintUsageMessage(itemID)
    local itemName, itemLink = GetItemInfo(itemID)
    if not itemLink then return end

    local price = PRV.PriceCache:GetMinBuyout(itemID)
    if not price or price <= 0 then return end

    local formattedValue = PRV.TooltipHook.FormatRealValue(price)
    if not formattedValue then return end

    local message = "Used " .. itemLink .. " worth " .. formattedValue
    local channel = PRV.Config.consumableChannel or "self"

    if channel == "self" then
        Utils.Print(PRV, message)
    elseif InCombatLockdown() then
        Utils.Print(PRV, message)
        table.insert(pendingMessages, message)
    else
        local chatType = channel == "auto" and GetAutoChatType() or CHANNEL_MAP[channel]
        if chatType then
            SendChatMessage(message, chatType)
        end
    end
end

function ConsumableTracker:OnSpellCastSucceeded(event, unit, castGUID, spellID)
    if unit ~= "player" then return end
    if not PRV.Config.consumableAlerts then return end

    local itemID = spellToItem[spellID]
    if not itemID then return end

    C_Timer.After(0, function()
        self:PrintUsageMessage(itemID)
    end)
end

function ConsumableTracker:FlushPendingMessages()
    if #pendingMessages == 0 then return end

    local channel = PRV.Config.consumableChannel or "self"
    if channel == "self" then
        pendingMessages = {}
        return
    end

    local chatType = channel == "auto" and GetAutoChatType() or CHANNEL_MAP[channel]
    if chatType then
        for _, message in ipairs(pendingMessages) do
            SendChatMessage(message, chatType)
        end
    end
    pendingMessages = {}
end

function ConsumableTracker:Initialize()
    PeaversCommons.Events:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        self:FlushPendingMessages()
    end)

    PeaversCommons.Events:RegisterEvent("BAG_UPDATE_DELAYED", function()
        self:ScheduleRebuild()
    end)

    PeaversCommons.Events:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", function(event, unit, castGUID, spellID)
        self:OnSpellCastSucceeded(event, unit, castGUID, spellID)
    end)

    C_Timer.After(2, function()
        self:RebuildSpellMap()
    end)

    Utils.Debug(PRV, "Consumable tracker initialized")
end

return ConsumableTracker
