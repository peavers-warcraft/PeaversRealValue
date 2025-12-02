# PeaversRealValue

A World of Warcraft addon that displays real-world currency values of items in tooltips, converting their gold value based on current WoW Token prices.

**Website:** [peavers.io](https://peavers.io) | **Addon Backup:** [vault.peavers.io](https://vault.peavers.io) | **Issues:** [GitHub](https://github.com/peavers-warcraft/PeaversRealValue/issues)

## Features

- Shows real-world currency value (USD, EUR, etc.) in item tooltips
- Integrates with TSM and Auctionator for auction house pricing
- Falls back to vendor prices when auction data is unavailable
- Supports multiple global currencies
- Caches prices for optimal performance

## Installation

1. Download from [CurseForge](https://www.curseforge.com/wow/addons/peaversrealvalue)
2. Ensure PeaversCommons and PeaversCurrencyData are also installed
3. Enable the addon on the character selection screen

## Usage

The addon works automatically once installed. Hover over any item to see its real-world value in the tooltip.

### Slash Commands

- `/prv` - Open the configuration panel
- `/prv clear` - Clear the price cache
- `/prv debug` - Toggle debug mode

## Configuration

Access settings through `/prv`:

- **Price Threshold**: Only show values for items above a set gold amount
- **Target Currency**: Select your preferred currency
- **Price Source**: Choose between auction house or vendor prices
- **Cache Settings**: Configure cache expiry and clearing

## Dependencies

- PeaversCommons (required)
- PeaversCurrencyData (required)
