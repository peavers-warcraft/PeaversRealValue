# PeaversRealValue

[![AddonSentry](https://addonsentry.io/api/public/repos/peavers-warcraft/PeaversRealValue/badge.svg)](https://addonsentry.io/dashboard/peavers-warcraft/PeaversRealValue)

A World of Warcraft addon that displays real-world currency values of items in tooltips, converting their gold value based on current WoW Token prices.

## Features

<!-- peavers:features -->
- Shows real-world currency value (USD, EUR, etc.) in item tooltips
- Integrates with TSM and Auctionator for auction house pricing
- Falls back to vendor prices when auction data is unavailable
- Supports multiple global currencies
- Caches prices for optimal performance
<!-- /peavers:features -->

## Usage

<!-- peavers:usage -->
The addon works automatically once installed. Hover over any item to see its real-world value in the tooltip.

### Slash Commands

- `/prv` - Open the configuration panel
- `/prv clear` - Clear the price cache
- `/prv debug` - Toggle debug mode
<!-- /peavers:usage -->

## Configuration

<!-- peavers:configuration -->
Access settings through `/prv`:

- **Price Threshold**: Only show values for items above a set gold amount
- **Target Currency**: Select your preferred currency
- **Price Source**: Choose between auction house or vendor prices
- **Cache Settings**: Configure cache expiry and clearing
<!-- /peavers:configuration -->


## Installation

### Recommended: PeaversUpdater

Download and install [PeaversUpdater](https://github.com/peavers-warcraft/PeaversUpdater/releases/latest), the desktop updater for the whole Peavers collection. It installs PeaversRealValue together with its required dependencies and delivers updates before they reach CurseForge.

### Alternative: CurseForge

1. Download from [CurseForge](https://www.curseforge.com/wow/addons/peaversrealvalue)
2. Ensure [PeaversCommons](https://www.curseforge.com/wow/addons/peaverscommons) is also installed
3. Ensure [PeaversConfig](https://www.curseforge.com/wow/addons/peaversconfig) is also installed
4. Enable the addon on the character selection screen

---

*Part of the [Peavers](https://peavers.io) addon collection · [Report an issue](https://github.com/peavers-warcraft/PeaversRealValue/issues) · [Support development on Patreon](https://www.patreon.com/Peavers)*
