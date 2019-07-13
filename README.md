# jenkins-telegram-bot

This is a Telegram bot that automates rom building on jenkins and notifes about the build. Once the build is done the bot sends a message in the desired group and also  uploads the build to your Google Drive.

How to use:

1. Get your bot API key from [Telegram's BotFather](https://t.me/BotFather)

2. Assign BOT API Key in `bot_config.conf`
```bash
        export BOT_API_KEY=ABCD12345:12345AbCDefghIJK
```
3. Create a public/private group and add the BOT
```bash
        export CHAT_ID= should @groupname or use the telegram provided chat id if the grp is private
```

4. Assign your configs for eg. to build for xyz device
```bash
        # Configs
        ROM_DIR="" #Name of the rom dir eg-aosip,lineageos
        DEVICE="" #Code Name of the device that you are building for eg-wt88047
```

5. The Bots can also sends extra info after the build is done
```bash
       #Extra Configs
       USERNAMES="" #Username of the testers so that they get tagged automatically
       DEV_USERNAME="" #Username of the developer to notify him once the build is done
```
6. If You still have any doubts just check the `bot-canfig.config-example` file.

### License
The MIT License (MIT)

Copyright © 2019 Ayush Dubey
