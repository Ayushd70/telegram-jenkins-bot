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
        export CHAT_ID= should @groupname or use the telegram provided chat id if the group is private, you can find the id by adding any group managing bot and doing "/id"
```
5. Assign your configs for eg. to build for xyz device
```bash
        #Build Configs
        CLEAN=" "  #Build Type like make cleaninstall, installclean, deviceclean and if this is none of the above then it will remove the OUT dir.
        MAKE_TARGET=" "  # Build target by default it is bacon but for different rom it can be set different, for eg-if you are building aosip you can set it as kronic.
        BUILD_TYPE=" " # The Type of Build that is user,userdebug or eng

        # Device Configs
        ROM_DIR=" "  #Name of the rom dir eg-aosip,lineageos, etc
        DEVICE=" "   #Code Name of the device that you are building for eg-wt88047, raphael, etc

        # Upload
        UPLOAD= " " 
        /* Upload to gdrive or transfer.sh depending on the choice. 
        For Gdrive upload you need to setup rclone. Guides:
        - https://bit.ly/3hcFtEH  and 
        -  https://bit.ly/34aUcfS
       */
```
        
6. The Bot can also sends extra info after the build is done
```bash
       #  Extra Configs
         USERNAMES=" " # Username of the testers so that they get tagged automatically.
         DEV_USERNAME=" " # Username of the developer to notify him once the build is done
```
7. If You still have any doubts just check the `bot-canfig.config-example` file.

8. TO start build on jenkins just add 
 ```bash
        cd ~/telegram-jenkins-bot/
        chmod +x bot.sh
        ./bot.sh
```
in your build step inside the execute step in configs of the project.        

### License
The MIT License (MIT)

Copyright © 2019-2020 Ayush Dubey
