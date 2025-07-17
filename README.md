# RoleLayout

RoleLayout is a World of Warcraft addon that automatically selects your preferred Edit Mode layout based on your character's current role (Tank, Healer, or DPS). It also enables all action bars and autoloot for your convenience.

## Features

- Automatically switches Edit Mode layout when you change specialization or log in.
- Supports custom layouts named "TANK", "HEAL", or "DPS".
- Enables all action bars on login.
- Enables autoloot on login.
- Lightweight and easy to use.

## How It Works

1. Create your preferred Edit Mode layouts and name them exactly as "TANK", "HEAL", or "DPS".
2. When you log in or change specialization, RoleLayout will automatically activate the layout that matches your current role.
3. All action bars and autoloot will be enabled automatically.

## Installation

1. Download and extract the RoleLayout addon into your `Interface/AddOns` folder.
2. Make sure the `LibEditModeOverride` library is included in the `Libs` folder.
3. Restart World of Warcraft.

## Troubleshooting

- Make sure your layouts are named exactly "TANK", "HEAL", or "DPS".
- If the layout does not change automatically, try opening Edit Mode manually once per session.
- If you encounter errors, enable Lua errors with `/console scriptErrors 1` and report them.

## Project Status & Feedback

RoleLayout is an ongoing project and will continue to receive new features and improvements in the future. Suggestions, feedback, and contributions are welcome! If you have ideas or requests, feel free to open an issue or contact the author.

## Credits

- Addon by Jacuv.
- Uses [LibEditModeOverride](https://github.com/plusmouse/LibEditModeOverride) by plusmouse.

## License

This addon is released under the MIT License.