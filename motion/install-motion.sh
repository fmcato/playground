#!/bin/sh
# Somehow ubuntu package does not create /var/log/motion, so fix this
sudo apt install motion \
    && sudo systemctl stop motion \
    && sudo mkdir -p /var/log/motion \
    && sudo chown motion.motion /var/log/motion

sudo echo "# Personal settings" >> /etc/motion/motion.conf

sudo echo "# Silly Asus laptop webcam shows rotated in linux" >> /etc/motion/motion.conf
sudo echo "rotate 180" >> /etc/motion/motion.conf

# Allow access to the web control from other hosts in my private network
sudo sed -i 's/webcontrol_localhost on/webcontrol_localhost off/g' /etc/motion/motion.conf

# Send completed video files to a telegram channel, then remove them from disk
read -p "Input Telegram bot token: " BOT_TOKEN
read -p "Input Telegram channel id: " CHANNEL_ID
echo "on_movie_end curl https://api.telegram.org/bot$BOT_TOKEN/sendVideo?chat_id=$CHANNEL_ID -F \"video=@%f\" -H \"Content-Type: multipart/form-data\" && rm -f %f" |sudo tee -a /etc/motion/motion.conf

sudo systemctl start motion
