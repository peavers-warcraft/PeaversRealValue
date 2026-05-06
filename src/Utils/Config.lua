--------------------------------------------------------------------------------
-- PeaversRealValue Configuration
-- Uses PeaversCommons.ConfigManager with AceDB-3.0 for profile management
--------------------------------------------------------------------------------

local addonName, PRV = ...

local PeaversCommons = _G.PeaversCommons
local ConfigManager = PeaversCommons.ConfigManager

local PRV_DEFAULTS = {
    enabled = true,
    debugMode = false,
    showOnlyWithPrice = true,
    priceThreshold = 0,
    cacheExpiry = 3600,
    targetCurrency = "USD",
    showSymbol = true,
    decimalPlaces = 2,
    priceSource = "auction",
}

-- Create the AceDB-backed config
PRV.Config = ConfigManager:NewWithAceDB(
    PRV,
    PRV_DEFAULTS,
    {
        savedVariablesName = "PeaversRealValueDB",
        profileType = "shared",
    }
)

return PRV.Config
