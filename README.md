# Telegram-Jenkins-Bot

This is a Telegram bot that automates rom building on jenkins and notifes about the build. Once the build is done the bot sends a message in the desired group and also  uploads the build to your Google Drive or transfer.sh.

How to use:

1. Get your bot API key from [Telegram's BotFather](https://t.me/BotFather)

2. Clone this repo into your prefered dir by coping the below command
```bash
         git clone https://github.com/Ayushd70/telegram-jenkins-bot
```         

3. Assign BOT API Key in `bot_config.conf`
```bash
        export BOT_API_KEY=ABCD12345:12345AbCDefghIJK
```
4. Create a public/private group and add the BOT
```bash
        export CHAT_ID= should @groupname or use the telegram provided chat id if the group is private
```
5. Assign your configs for eg. to build for xyz device
```bash
        # Configs
        ROM_DIR="" #Name of the rom dir eg-aosip,lineageos
        DEVICE="" #Code Name of the device that you are building for eg-wt88047
        MAKE_TARGET="" #Build target by default it is bacon but for different rom it can be set different, for eg-if you are building aosip you can set it as kronic.
```

6. The Bots can also sends extra info after the build is done
```bash
       #Extra Configs
       USERNAMES="" #Username of the testers so that they get tagged automatically
       DEV_USERNAME="" #Username of the developer to notify him once the build is done
```
7. If You still have any doubts just check the `bot-canfig.config-example` file.

8. TO start build on jenkins just use
 ```bash
        ./bot.sh
```
in your build step inside the execute step in configs of the project.        
### License
The MIT License (MIT)

Copyright © 2019 Ayush Dubey
