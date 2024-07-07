# B2_AFKSystem
 
# AFK System for FiveM

This script manages AFK (Away From Keyboard) players in a FiveM server. It includes features such as automatic AFK detection, kicking AFK players, making AFK players invincible, and displaying an AFK icon above AFK players' heads.

## Features

- **AFK Detection**: Automatically detect players who are AFK based on idle time.
- **AFK State Management**: Players can be set to AFK mode manually or automatically.
- **AFK Consequences**: Optionally kick AFK players after a configurable amount of time.
- **Invincibility**: Make AFK players invincible to prevent them from taking damage.
- **AFK Icon**: Display a 3D AFK icon above AFK players.
- **Highly Customizable**: Easily configure all features via the `config.lua` file.

## Installation

1. **Download the script**:
   - Clone this repository or download the ZIP file and extract it.

2. **Place the script in your resources folder**:
   - Move the extracted folder to your `resources` directory in your FiveM server.

3. **Add the script to your server configuration**:
   - Open your `server.cfg` file and add the following line:
     ```
     ensure your_folder_name
     ```
     Replace `your_folder_name` with the name of the folder you placed in the `resources` directory.

4. **Start your server**:
   - Restart your FiveM server or start it if it was not running.

## Configuration

The script is highly customizable via the `config.lua` file. Below are the available configuration options:

- **Enable/disable AFK system**:
  ```lua
  Config.AFKSystemEnabled = true 

  Config.IdleTimeThreshold = 300 -- 5 minutes

  Config.KickTime = 600 -- 10 minutes

  Config.InvincibilityEnabled = true
  
  Config.AFKIconEnabled = true ```

## File Structure

fxmanifest.lua: Defines the resource metadata.
config.lua: Contains configuration options for the script.
client.lua: Main client-side script with the logic to detect AFK players, manage AFK state, and display AFK icon.
server.lua: Main server-side script to handle AFK player management and consequences.

## Usage
Once the script is installed and configured, it will automatically detect AFK players and manage their state according to the configuration. The AFK icon will be displayed above AFK players, and they will be kicked if they exceed the kick time.

## Author
B2DevUK - [GitHub Profile](https://github.com/B2DevUK)

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## Support
If you have any issues or suggestions, please open an issue on the GitHub repository, or in my script [discord](https://discord.gg/KZRBA6H5kR)

