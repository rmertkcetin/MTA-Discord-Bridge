# MTA & Discord Bridge

A bidirectional communication bridge between a Multi Theft Auto (MTA) server and a Discord server. This project allows for real-time chat synchronization and secure account linking between the game and Discord.

## Features

* **Bidirectional Chat:** Synchronizes messages from Discord to the game and from the game to Discord using webhooks and HTTP exports.
* **Account Linking:** Players can link their in-game accounts to Discord using a secure code system (`/register` in-game and `!register` on Discord).
* **Automated Permissions:** Supports automatic ACL group assignment based on database permissions.
* **Data Synchronization:** Automatically updates player nicknames and session data in the database during login, logout, or quit events.

## Prerequisites

* **Node.js:** To run the Discord bot.
* **MySQL Server:** To store account and registration data.
* **MTA Server:** Version 1.5.9 or higher.
* **Discord Bot Token:** Obtained from the Discord Developer Portal.

## Installation

### 1. Database Setup
1.  Access your MySQL database manager.
2.  Import the `mta_server.sql` file to create the necessary tables: `accounts`, `account_codes`, and `account_permissions`.

### 2. MTA Server Configuration
1.  Move the following files to your MTA resources folder (e.g., `resources/[tools]/discord-bridge`):
    * `meta.xml`, `mysql.lua`, `server.lua`, `register.lua`.
2.  **Database Connection:** Open `mysql.lua` and update the `dbIp`, `dbPort`, `dcUser`, `dbPass`, and `dbName` variables with your MySQL credentials.
3.  **Discord Webhook:** Open `server.lua` and paste your Discord channel webhook URL into the `webhookURL` variable.
4.  **ACL Permissions:** Ensure the resource has `General.HTTP` access in your `acl.xml` to allow the `sendToGame` function to be called via the web.

### 3. Discord Bot Setup
1.  Open a terminal in the bot's directory and install dependencies:
    npm install discord.js mysql2 moment express

2.  **Configuration:** Edit `config.js` with your specific details:
    * `IP` and `PORT`: Your MTA server's IP and HTTP port.
    * `DBCONF`: Your MySQL database connection details.
    * `TOKEN`: Your Discord Bot Token.

3.  **Channel & Auth:** In `index.js`:
    * Update `channelID` to the ID of the Discord channel where chat should be synced.
    * Update `botlogin` with the credentials (username:password) of the account created in MTA's ACL for HTTP requests.

## Usage

1.  **Run the Bot:** Use `start.bat` or run `node index.js` in your terminal.
2.  **Link Accounts:**
    * In-game: Type `/register` to generate a 4-digit code.
    * Discord: Type `!register <code>` in the designated channel to link your account.
3.  **Chat:** Once linked, messages sent in the Discord channel will appear in-game with your player name, and game chat will be forwarded to Discord via the webhook.

## License

This project is licensed under the **WTFPL – Do What The Fuck You Want To Public License**.