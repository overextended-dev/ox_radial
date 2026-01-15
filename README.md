# ox_radial

A comprehensive radial menu system for FiveM servers using ESX Legacy, ox_lib, and ox_inventory.

## Features

This resource provides intuitive radial menus for various gameplay aspects:

### 🚗 Vehicle Controls
- Engine start/stop
- Seat changing with custom vehicle configurations
- Window controls
- Door controls
- Vehicle extras management

### 👔 Clothing Management
- Toggle various clothing items (glasses, visor, bag, bracelet, watch, gloves, ear accessories, necklace, mask, shoes, pants, shirt, hat)
- Support for bag variants

### 👮 Police Actions
- Police-specific radial menu options

### 👤 Personal Actions
- Personal menu items

### 🏢 Faction Actions
- Faction-specific menu options

## Installation

1. Ensure you have the following dependencies installed:
   - [ox_lib](https://github.com/overextended/ox_lib)
   - [es_extended](https://github.com/esx-framework/es_extended)
   - [ox_inventory](https://github.com/overextended/ox_inventory)

2. Place the `ox_radial` folder in your Server directory

3. Add `start ox_radial` to your `server.cfg`

## Configuration

### Language Settings
Edit `config.lua` to set your preferred language:
```lua
Config.Language = 'de'  -- 'de' for German, 'en' for English
```

### Vehicle Seat Configuration
Configure custom seat labels for specific vehicles in `config.lua`:
```lua
Config.VehicleSeats = {
    ['vehiclemodel'] = {
        seats = {
            { label = 'Driver', index = -1 },
            { label = 'Passenger', index = 0 },
            -- Add more seats as needed
        }
    },
}
```

### Bag Variants
Configure which bag variants are enabled:
```lua
Config.BagVariants = {[40] = true, [41] = true, [44] = true, [45] = true}
```

## Usage

The radial menus are automatically available when:
- In a vehicle (vehicle controls)
- As a police officer (police actions)
- In appropriate contexts for other menus

Access the radial menu using your configured keybind (typically F1 or similar).

## Localization

The resource supports multiple languages:
- German (`de.lua`)
- English (`en.lua`)

Add new languages by creating additional locale files and updating the `locales/init.lua`.

## Dependencies

- **ox_lib**: Core library for radial menus and notifications
- **es_extended**: ESX framework
- **ox_inventory**: Inventory system integration

## Author

overextended-dev

## Version

1.0.0

## Support

For issues or contributions, please check the repository or contact the author.