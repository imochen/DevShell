#!/bin/bash

NODE_VERSION=10.16.0
NPM_VERSION=6.9.0
PM2_VERSION=3.5.1
PM2_LOGROTATE_VERSION=2.6.0
 
NODE_PKG_NAME=node-v${NODE_VERSION}-linux-x64
TAR=${NODE_PKG_NAME}.tar.gz
NODE_TAR_URL=https://nodejs.org/dist/v${NODE_VERSION}/${TAR}
  
cd ~/
test -f $TAR && rm -rf $TAR
test -d $NODE_PKG_NAME/ && rm -rf $NODE_PKG_NAME/
wget $NODE_TAR_URL
tar -xvf $TAR
 
test -d /usr/local/$NODE_PKG_NAME && sudo rm -rf /usr/local/$NODE_PKG_NAME
sudo mv $NODE_PKG_NAME /usr/local
sudo chown -R root:root /usr/local/$NODE_PKG_NAME
sudo rm -rf /usr/local/node
sudo ln -s /usr/local/$NODE_PKG_NAME /usr/local/node
sudo ln -s /usr/local/node/bin/* /usr/bin
 
sudo npm install -g npm@$NPM_VERSION
sudo npm install -g pm2@$PM2_VERSION
sudo pm2 update
pm2 update

sudo pm2 install pm2-logrotate@$PM2_LOGROTATE_VERSION
sudo pm2 set pm2-logrotate:max_size 10M
sudo pm2 set pm2-logrotate:dateFormat 'YYYY-MM-DD_HH-mm-ss'
sudo pm2 set pm2-logrotate:rotateInterval '0 */1 * * *'
sudo pm2 set pm2-logrotate:compress true
sudo pm2 --update-env restart all