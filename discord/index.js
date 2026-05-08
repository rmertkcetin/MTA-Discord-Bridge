const { Client, GatewayIntentBits, Partials, Collection } = require("discord.js");
const { DBCONF, PREFIX, TOKEN, IP, PORT } = require("./config");
const mysql = require("mysql2/promise");
const moment = require("moment");
const express = require("express");
const fs = require("fs");

const bot = new Client({disableMentions:"everyone",intents:[GatewayIntentBits.Guilds,GatewayIntentBits.GuildMessages,GatewayIntentBits.MessageContent,GatewayIntentBits.GuildMembers]});
const app = express();

// you should create account on game for discord bot
            // username:password
const botlogin = "dcbot:12345"

// Send messages to game from Discord
bot.on("messageCreate", async (message) => {
    const channelID = "1498807032235556935";
    if (message.author.bot || message.channel.id !== channelID) return;

    if (message.content.startsWith("!")) return;

    connection = await mysql.createConnection(DBCONF);
    const [rows] = await connection.execute("SELECT playername FROM accounts WHERE discordid = ?", [message.author.id]);

    if (rows.length === 0) {
        await message.delete().catch(() => {});
        const uyari = await message.channel.send(`<@${message.author.id}>, you should register first!`);
        setTimeout(() => uyari.delete().catch(() => {}), 5000);
        return;
    };

    const playername = rows[0].playername;
    const mtaUrl = `http://${IP}:${PORT}/core/call/sendToGame`; //call function from game
    const authData = Buffer.from(botlogin).toString("base64");

    try {
        await fetch(mtaUrl, {
            method: "POST",
            headers: {
                "Authorization": `Basic ${authData}`,
                "Content-Type": "application/json"
            },
            
            body: JSON.stringify([playername, message.content])
        });
    } catch (error) {
        console.error("error", error.message);
    };
});

// /register
bot.on("messageCreate", async (message) => {
    let args = message.content.slice(PREFIX.length).trim().split(/ +/g);
    let cmd = args.shift().toLowerCase();

    let code = args[0];

    if (cmd != "register") return;
    if (!code) return message.reply("`!register 1234`");

    let connection;
    try {
        connection = await mysql.createConnection(DBCONF);

        const [rows] = await connection.execute(`SELECT c.accountid, a.loginname FROM account_codes c JOIN accounts a ON c.accountid = a.id WHERE c.code = ?`, [code]);

        if (rows.length === 0) return context.reply("wrong code!");

        const data = rows[0];

        await connection.execute('UPDATE accounts SET discordid = ? WHERE id = ?', [discordId, data.accountid]);
        await connection.execute('DELETE FROM account_codes WHERE accountid = ?', [data.accountid]);

        // context.guild.members.cache.get(discordId)
        
        context.reply(`your accounts are linked via **${data.loginname}**.`);

    } catch (error) {
        console.error("error", error);
    } finally {
        if (connection) await connection.end();
    }
});

const listener = app.listen(process.env.PORT, () => {
  console.log(`[${moment().format("DD-MM-YYYY HH:mm:ss")}] ${listener.address().port}`);
});

bot.login(TOKEN);