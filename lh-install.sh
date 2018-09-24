#!/bin/sh
BN=`basename $0`
if [ "$BN" = "lh-install.sh" ]; then
  printf "install"
else
  printf "setup"
fi
echo " - LostHeros CLI"
echo ""
if [ "$1" = "" ]; then
  echo "usage: $BN ~/path/to/where   'lostheroes' folder will be placed, or"
  if [ "$BN" = "lh-install.sh" ]; then
    echo "       ./lh-install.sh shared [local]    in '/usr/shared' or '/usr/local/shared'"
    echo "                                         with install script for per user setup"
  fi
  echo "   eg: ./$BN ~/games"
  echo " "
  exit 0
fi
if [ ! -d ./bin-linux ]; then
  echo "error: './$BN' from archive or repo folder"
  exit 2
fi

WD="$1"
if [ "$BN" = "lh-install.sh" -a "$1" = "shared" ]; then
  WD=/usr/shared
fi
if [ "$BN" = "lh-install.sh" -a "$1" = "local" -o "$2" = "local" ]; then
  WD=/usr/local/shared
fi
if [ ! -d "$WD" ]; then
  echo "error: not found '$WD'"
  exit 1
fi

OD=`pwd`
WD="$WD/lostheros"
test -d "$WD" && rm -rf "$WD"
mkdir -p "$WD"

if [ "$BN" = "lh-install.sh" -a "$1" = "shared" -o "$1" = "local" -o "$2" = "local" ]; then
  cp -rf ./bin-linux "$WD/"
  cp -f ./lh-install.sh "$WD/lh-setup.sh"
  echo "lostheros: '$WD'"
  echo "usage: ./lh-setup.sh ~/path/to/where   'lostheroes' folder will be placed"
  echo "   eg: ./lh-setup.sh ~/games"
else
#test -d "$WD/.bin" && rm -rf "$WD/.bin"
cp -rf ./bin-linux "$WD/.bin"
cd "$WD"

ln -sf ./.bin/lh-login login
ln -sf ./.bin/lh-logout logout

ln -sf ./.bin/lh-get profile
ln -sf ./.bin/lh-get inventory
ln -sf ./.bin/lh-get resources
ln -sf ./.bin/lh-get info
ln -sf ./.bin/lh-get current
ln -sf ./.bin/lh-get stats
ln -sf ./.bin/lh-get combat
ln -sf ./.bin/lh-get damage
ln -sf ./.bin/lh-get armor
ln -sf ./.bin/lh-get skills
ln -sf ./.bin/lh-get level
ln -sf ./.bin/lh-get energy
ln -sf ./.bin/lh-get gold
ln -sf ./.bin/lh-get diamonds
ln -sf ./.bin/lh-get coins
ln -sf ./.bin/lh-get data
ln -sf ./.bin/lh-get hitpoints
ln -sf ./.bin/lh-get experience

ln -sf ./.bin/lh-xtx
ln -sf ./.bin/lh-val
ln -sf ./.bin/lh-rez

ln -sf ./.bin/lh-export
ln -sf ./.bin/lh-start

# we are done
cd "$OD"
echo "lostheros: '$WD'"
echo "usage: cd \"$WD\" && ./lh-start.sh [username] [password] [true]"
echo "         optional login, optional 'multiuser'"
echo "signup: http://webgame.losthero.com/"
echo "        http://localhost:7672/"
fi

unset OD
unset WD
exit 0

