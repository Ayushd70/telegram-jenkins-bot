# jenkins-telegram-bot
 
This is a Telegram bot that automates rom building on jenkins and notifes about the build. Once the build is done the bot sends a message in the desired group and also  uploads the build to your Google Drive.

How to use:

1. Get your bot API key from [Telegram's BotFather](https://t.me/BotFather)

2. Assign BOT API Key in `config.conf`
```bash
        export BOT_API_KEY=ABCD12345:12345AbCDefghIJK
```
3. Create a public/private group and add the BOT
```bash
        export CHAT_ID= should @groupname or use the telegram provided chat id if the grp is private
```

4. Assign your configs for eg. to build LineageOS for xyz device
```bash
        # Configs
        ROM=""
        Device=""
```

5. The Bots can also sends extra info after the build is done
`ZIPNAME` will send package name to send
`BUILD_TYPE` can be set accordingly

### License
The MIT License (MIT)

Copyright © 2019 Ayush Dubey
