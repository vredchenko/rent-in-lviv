# Rent in Lviv


A series of phantomjs scrapers to aggregate long-term flat rental offers in Lviv
This is very much a prototype and my first try with a new stack. This code may not be safe for the faint-hearted.


## Installation:


### 1. install node and npm:

```
sudo apt-get update
sudo apt-get install git-core curl build-essential openssl libssl-dev
git clone https://github.com/joyent/node.git
cd node
git tag # Gives you a list of released versions
git checkout v0.4.12
./configure
make
sudo make install
node -v
curl https://npmjs.org/install.sh | sudo sh
npm -v
```

### 2. install phantomjs
====

```
sudo apt-get update
sudo apt-get install build-essential chrpath git-core libssl-dev libfontconfig1-dev
git clone git://github.com/ariya/phantomjs.git
cd phantomjs
git checkout 1.9
./build.sh
```

### 3. install casperjs

```
npm install -g casperjs
```
or
```
git clone git://github.com/n1k0/casperjs.git
cd casperjs
ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs
phantomjs --version
casperjs
```

### 4. Install grunt

```
npm install -g grunt-cli
```

### 5. Having checked out the project:

```
cd crawlers
npm install
grunt sherlock
```
with grunt sherlock hanging in the terminal, open and save (with or without modifications) any coffee file. This will trigger the build, ensuring you have the latest js files in dest/

vashmagazin crawler can be launched using:

```
casperjs dest/001-vashmagazin.js 
```

### This script relies on a package called easyxml.
However, at the time of writing the version available in the npm repo is buggy, you want this fix or later:
(https://github.com/QuickenLoans/node-easyxml/commit/ac39596d3a5f990aebc789ac44e1f3fece7931f5)  
For now do the following:

```
cd node_modules
mkdir easyxml
git clone https://github.com/QuickenLoans/node-easyxml.git easyxml
cd easyxml
npm install
```

and remember to keep you fingers crossed at all times :)

## Tested with the following versions:

```
node --version
v0.10.13
npm --version
1.3.2
phantomjs --version
1.9.2
casperjs --version
1.1.0-DEV
```