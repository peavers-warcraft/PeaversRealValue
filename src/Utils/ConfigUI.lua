local addonName, PRV = ...

local ConfigUI = {}
PRV.ConfigUI = ConfigUI

local PeaversCommons = _G.PeaversCommons
local W = PeaversCommons.Widgets
local C = W.Colors
local Utils = PeaversCommons.Utils

local pageOpts = {
    indent = 25,
    width = 360,
}

local function GetPageOpts(parentFrame)
    local opts = {}
    for k, v in pairs(pageOpts) do opts[k] = v end
    local frameWidth = parentFrame:GetWidth()
    if frameWidth and frameWidth > 100 then
        opts.width = frameWidth - (opts.indent * 2) - 10
    end
    return opts
end

function ConfigUI:BuildGeneralPage(parentFrame)
    local y = -10
    local opts = GetPageOpts(parentFrame)
    local indent = opts.indent
    local width = opts.width

    local _, newY = W:CreateSectionHeader(parentFrame, "General Settings", indent, y)
    y = newY - 8

    local toggle1 = W:CreateToggle(parentFrame, "Enable real value display", {
        checked = PRV.Config.enabled,
        width = width,
        onChange = function(checked)
            PRV.Config.enabled = checked
            PRV.Config:Save()
        end,
    })
    toggle1:SetPoint("TOPLEFT", indent, y)
    y = y - 30

    local toggle2 = W:CreateToggle(parentFrame, "Only show value for items with known auction house prices", {
        checked = PRV.Config.showOnlyWithPrice,
        width = width,
        onChange = function(checked)
            PRV.Config.showOnlyWithPrice = checked
            PRV.Config:Save()
        end,
    })
    toggle2:SetPoint("TOPLEFT", indent, y)
    y = y - 30

    local thresholdSlider = W:CreateSlider(parentFrame, "Price Threshold (gold)", {
        min = 0, max = 10000, step = 10,
        value = PRV.Config.priceThreshold,
        width = width,
        onChange = function(value)
            PRV.Config.priceThreshold = value
            PRV.Config:Save()
        end,
    })
    thresholdSlider:SetPoint("TOPLEFT", indent, y)
    y = y - 52

    local debugToggle = W:CreateToggle(parentFrame, "Enable debug messages", {
        checked = PRV.Config.debugMode,
        width = width,
        onChange = function(checked)
            PRV.Config.debugMode = checked
            PRV.Config.DEBUG_ENABLED = checked
            PRV.Config:Save()
        end,
    })
    debugToggle:SetPoint("TOPLEFT", indent, y)
    y = y - 30

    parentFrame:SetHeight(math.abs(y) + 30)
end

function ConfigUI:BuildCurrencyPage(parentFrame)
    local y = -10
    local opts = GetPageOpts(parentFrame)
    local indent = opts.indent
    local width = opts.width

    local _, newY = W:CreateSectionHeader(parentFrame, "Currency Settings", indent, y)
    y = newY - 8

    local currencies = {
        { value = "USD", label = "US Dollar ($)" },
        { value = "EUR", label = "Euro (€)" },
        { value = "GBP", label = "British Pound (£)" },
        { value = "AUD", label = "Australian Dollar (A$)" },
        { value = "CAD", label = "Canadian Dollar (C$)" },
        { value = "JPY", label = "Japanese Yen (¥)" },
        { value = "CNY", label = "Chinese Yuan (¥)" },
        { value = "KRW", label = "Korean Won (₩)" },
    }

    local currencyDropdown = W:CreateDropdown(parentFrame, "Target Currency", {
        options = currencies,
        selected = PRV.Config.targetCurrency or "USD",
        width = width,
        onChange = function(value)
            PRV.Config.targetCurrency = value
            PRV.Config:Save()
        end,
    })
    currencyDropdown:SetPoint("TOPLEFT", indent, y)
    y = y - 58

    local symbolToggle = W:CreateToggle(parentFrame, "Show currency symbol", {
        checked = PRV.Config.showSymbol,
        width = width,
        onChange = function(checked)
            PRV.Config.showSymbol = checked
            PRV.Config:Save()
        end,
    })
    symbolToggle:SetPoint("TOPLEFT", indent, y)
    y = y - 30

    local decimalSlider = W:CreateSlider(parentFrame, "Decimal Places", {
        min = 0, max = 4, step = 1,
        value = PRV.Config.decimalPlaces,
        width = width,
        onChange = function(value)
            PRV.Config.decimalPlaces = value
            PRV.Config:Save()
        end,
    })
    decimalSlider:SetPoint("TOPLEFT", indent, y)
    y = y - 52

    parentFrame:SetHeight(math.abs(y) + 30)
end

function ConfigUI:BuildSourcePage(parentFrame)
    local y = -10
    local opts = GetPageOpts(parentFrame)
    local indent = opts.indent
    local width = opts.width

    local _, newY = W:CreateSectionHeader(parentFrame, "Price Source Settings", indent, y)
    y = newY - 8

    local priceSources = {
        { value = "auction", label = "Auction House (if available)" },
        { value = "vendor", label = "Vendor Prices Only" },
    }

    local sourceDropdown = W:CreateDropdown(parentFrame, "Price Source", {
        options = priceSources,
        selected = PRV.Config.priceSource or "auction",
        width = width,
        onChange = function(value)
            PRV.Config.priceSource = value
            PRV.Config:Save()
            PRV.PriceCache:Clear()
            Utils.Print(PRV, "Price source changed - cache cleared")
        end,
    })
    sourceDropdown:SetPoint("TOPLEFT", indent, y)
    y = y - 58

    local infoText = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    infoText:SetPoint("TOPLEFT", indent, y)
    infoText:SetText("Auction prices use TSM or Auctionator if available")
    infoText:SetTextColor(C.textMuted[1], C.textMuted[2], C.textMuted[3])
    y = y - 30

    local _, newY = W:CreateSectionHeader(parentFrame, "Performance Settings", indent, y)
    y = newY - 8

    local cacheSlider = W:CreateSlider(parentFrame, "Cache Expiry (seconds)", {
        min = 300, max = 7200, step = 60,
        value = PRV.Config.cacheExpiry,
        width = width,
        onChange = function(value)
            PRV.Config.cacheExpiry = value
            PRV.Config:Save()
        end,
    })
    cacheSlider:SetPoint("TOPLEFT", indent, y)
    y = y - 52

    local clearBtn = W:CreateButton(parentFrame, "Clear Price Cache", {
        style = "secondary",
        width = 150,
        onClick = function()
            PRV.PriceCache:Clear()
            Utils.Print(PRV, "Price cache cleared")
        end,
    })
    clearBtn:SetPoint("TOPLEFT", indent, y)
    y = y - 40

    parentFrame:SetHeight(math.abs(y) + 30)
end

function ConfigUI:BuildRatesPage(parentFrame)
    local y = -10
    local opts = GetPageOpts(parentFrame)
    local indent = opts.indent

    local PCD = _G.PeaversCurrencyData
    if not PCD then
        local errorText = W:CreateLabel(parentFrame, "PeaversCurrencyData not available", { color = C.danger })
        errorText:SetPoint("TOPLEFT", indent, y)
        parentFrame:SetHeight(40)
        return
    end

    local _, newY = W:CreateSectionHeader(parentFrame, "Data Freshness", indent, y)
    y = newY - 8

    local lastUpdatedLabel = W:CreateLabel(parentFrame, "Last Updated: " .. (PCD:GetLastUpdated() or "Unknown"), { color = C.textSec })
    lastUpdatedLabel:SetPoint("TOPLEFT", indent, y)
    y = y - 30

    local _, newY = W:CreateSectionHeader(parentFrame, "WoW Token Prices", indent, y)
    y = newY - 8

    local currentRegion = PRV.TooltipHook and PRV.TooltipHook.GetCurrentRegionName and PRV.TooltipHook:GetCurrentRegionName() or "US"

    if PCD.TokenPrices and PCD.TokenPrices.regions then
        local regionData = PCD.TokenPrices.regions[currentRegion]
        if regionData then
            local tokenText = string.format("%s = %s",
                PCD:FormatWoWCurrency(regionData.goldPrice),
                PCD:FormatCurrency(regionData.realPrice, regionData.currency))
            local regionLabel = W:CreateLabel(parentFrame, currentRegion .. " Region: " .. tokenText, { color = C.gold })
            regionLabel:SetPoint("TOPLEFT", indent, y)
            y = y - 25

            local goldValue = regionData.realPrice / regionData.goldPrice
            local goldLabel = W:CreateLabel(parentFrame, "1 Gold = " .. PCD:FormatCurrency(goldValue, regionData.currency, nil, 6), { color = C.textSec })
            goldLabel:SetPoint("TOPLEFT", indent, y)
            y = y - 35
        end
    end

    local _, newY = W:CreateSectionHeader(parentFrame, "Currency Exchange Rates", indent, y)
    y = newY - 8

    local commonCurrencies = {"EUR", "GBP", "AUD", "CAD", "JPY", "CNY", "KRW"}

    for _, currency in ipairs(commonCurrencies) do
        local rate = PCD:GetExchangeRate("USD", currency)
        if rate then
            local symbol = PCD:GetCurrencySymbol(currency)
            local extra = (symbol and symbol ~= currency) and (" (" .. symbol .. ")") or ""
            local rateLabel = W:CreateLabel(parentFrame,
                string.format("1 USD = %.4f %s%s", rate, currency, extra), { color = C.textSec })
            rateLabel:SetPoint("TOPLEFT", indent, y)
            y = y - 20
        end
    end

    parentFrame:SetHeight(math.abs(y) + 30)
end

function ConfigUI:GetPages()
    return {
        { key = "general", label = "General", builder = function(f) ConfigUI:BuildGeneralPage(f) end },
        { key = "currency", label = "Currency", builder = function(f) ConfigUI:BuildCurrencyPage(f) end },
        { key = "source", label = "Source", builder = function(f) ConfigUI:BuildSourcePage(f) end },
        { key = "rates", label = "Rates", builder = function(f) ConfigUI:BuildRatesPage(f) end },
    }
end

function ConfigUI:BuildIntoFrame(parentFrame)
    self:BuildGeneralPage(parentFrame)
    return parentFrame
end

function ConfigUI:Initialize()
end

function ConfigUI:Open()
    if _G.PeaversConfig and _G.PeaversConfig.MainFrame then
        _G.PeaversConfig.MainFrame:Show()
        _G.PeaversConfig.MainFrame:SelectAddon("PeaversRealValue")
        return
    end

    if Settings and Settings.OpenToCategory then
        local addon = _G[addonName]
        if addon and addon.directSettingsCategoryID then
            pcall(Settings.OpenToCategory, addon.directSettingsCategoryID)
        end
    end
end

return ConfigUI
