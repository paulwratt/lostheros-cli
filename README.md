# lostheros-cli
Old School "text adventure" access to http://webgame.losthero.com/ or a LostHeros LAN server (when its finished).


## Background
Lost Hero is a nice and fast PHP, JavaScript & AJAX powered RPG _dungeon crawler_. Although still active, there are only 2 regular players, myself for the last 12 months (2018), and the top XP player (for a few years now). I could not find my orginal character from the early 2000's so I started again. It is much easier than it used to be, because of the less players, but it is still one of the _most grinding_ RPG games I have ever played, even after I spent more than a few dollars on diamonds.

But its such a lovely, quick game to play, especially solo (it does have _clans_ thoand a _market_), that I always wanted to build my own so I could bring it to LAN partys, have some custom _1 hour blast_ sessions, and maybe make custom maps.

In order to be able to test a server like that I decided to write a CLI access for the official online Lost Hero server, and that way I could also output compatible HTML, Javascript and AJAX content. This makes it easier to _convert_ Lost Hero to platforms that dont have good (or any) JavaScript or web browser support, but still have access to a usable POSIX compliant shell environment (like Atari ST, Falcon or Amiga).

Besides being an _old skool text adventure_, this CLI layer would then allow me to develop a custom frontend for systems that dont support PNG image formats, or have 1024x768 resolutions, like a plain Atari ST 520 at 320x200 with only 16 colors, but still has an internet network connection. At the same time I would be able to check my energy levels without running a web browser (thats the only X-Windows app I have on this Raspbian Jessie based PipaOS v5).

And so LostHeros-CLI was born to go with the eventual LostHeros-LAN server.


## Installation
Either clone the repo, or unzip the archive, and change into the 'lostheros-cli' directory. The install script in the root, `./lh-install.sh` can only be run from a folder that also contains `bin-linux`, and it also doubles as a setup script when not used as a system package installer. When installed to a `shared` folder, the install gets renamed to `lh-setup.sh` which wont allow shared installation again.

In the future there will be a `bin-dos` and/or `bin-windows` installation, but with _CygWin or MinGW_ istalled, you can use the `bin-linux` install script. With a BSD installation, there may be a need to install GNU SED (`gsed`) and alias it to `sed`, as one specific process requires `:upper:` which is not present in any BSD `sed`. An option is to use `awk`, but this is not installed on every system by default. The process is in used in `lh-get` if you are willing to edit that rather that install the (non-standard) SED replacement. This is the main reason for the `bin-linux` name.

Running the install script (or setup script) will create a `lostheros` folder in the destination path of choice. For a single user it will then copy `bin-linux` to the destinaton as `.bin` which will be hidden, then it creates soft links to specific files in the `.bin` folder, creating all the _long command_ specified in `./bin-linux/lh-help`. _All_ the other 1, 2 and 3 letter _short commands_ are installed as aliases when `lh-start` is executed to actually start "playing the game".


## Starting
You _MUST_ already have a signup username and password either from the Lost Hero webserver, or a LostHeros-LAN server (not available yet). You will be able to _export_ user data from any server, but you will only be able to upload to a LAN server.

Although all testing is done from a regular terminal shell, `lh-start` is used to install all the alias's that could otherwise interfere with a regular shell environment. We use `/bin/sh` as it is cross platform, and usually only 10% size of a regular _full blown shell_ (bash, at least). All the individual aliases can be found in `shinit` or with a plain `help` if a user installation (setup) was done.

The `lh-start` also locks the `cd` command, and allows optionally to login. It also adds `./` to the `PATH` environment variable (missing on most systems). This allows for the use of _regular shell commands_ to access LostHeros-CLI XTX, VAL and REZ files which are plain text files. There _extention_ is place first in the filename to seperate commands from data when using `ls`, but they are still just plain text files.

The last option of `lh-start` is used to over-ride `multiuser` in `auto.set` and can be forced with `true` or `false` explicitly. You can edit `auto.set` with your favourite editor, or use `lh-set` to change what will be the defaults when no options are specified during gameplay.

When `multiuser=true`, after a successful login, a sub-folder with that `username` will be created and used for all processing, including its own `auto.set` default options. This allows multiple users and multiple servers to be used, and allows command line browsing of information and values of each seperate user, even when not playing the game itself.

As a precaution, if no `server` is specified in `auto.set`, the `http://webgame.losthero.com/` official online server will be used. You do not _have_ to `logout` before using `login` again. You can still use most commands that dont affect your location or inventory (like fighting does) even when logged out, or when you have logged in with a web browser (which will require you to use `login` again for LostHeros-CLI).


## Localhost
A local server address can be used, the default is `http://localhost:7672/` (76=l, 72=h, in ASCII character codes). Any server address can be used, as long as it ends with `/` where `login.php`, `logout.php` and `index.php` can be found.

The LostHeros-LAN server is not finished at this time. Note also that the name of these projects is `LostHeros` _not Lost Heroes_ as you might expect.


## Playing
You need to signup first before you can login with LostHeros-CLI. Register at: http://webgame.losthero.com/

You need to login first, either with `lh-start _username_ _password_` or with `login _username_ _password_`. If successful it will create a file called `cookie.jar` that is then used by some of the other scripts. 

If you dont use the `multiuser=true` option, all the data for you character is available in the same directory as the symbolic links, organised so the most common text information is list last (xtx.*) in a regular directory linsting (using `ls`). A couple of tools are supplied to make is more obvious as to how to view the contents of detailed breakdown components as text files. `lh-show` for text values (xtx.*), `lh-value` for numeric values, and `lh-rez` for numeric resource values.

If you only ever use the _long command_ names, and are in the habit of typing `./` first to use them, you do not need to use `lh-start` whic opens a new `sh` shell modified with the locked `cd` command and a _lot_ or aliases (some of which would interfere with a system using an unmodified shell).

Again, you do not need to use `logout`, `login` does it automatically for the current username. You dont need to login to see unchanged information, but you will have to be logged in to update the `energy` and `val.nrg` information with the `profile` command. In the future you can use `lh-check-energy _username_ _password_` if that is all you wish to check, otherwise `profile` will do the job as long as you have are the current login user.

Processing is only done when the main commands are used (not the `lh-` helper command mentioned above for reading values). The `profile` command will update the most information, including energy, coin and diamond values. The actual downloading of a new HTML text page that is cut for futher processing, is controlled by the contents of `.update` which is a hidden file. You can therefore force an update of the main information and values using `echo "now" > .update && profile` to modify it first.

In normal gameplay `.update` is only modified after actions that affect your location or inventory (like fighting).

## Diamonds
With Lostheros-CLI, you will never be able to do ingame purchases of diamonds outside of exchanging 1400 gold for 1 diamond which the browser interface supports.

However, with the PayPal transactions, there is a quirk when using the web browser to purchase diamonds, in that the final address has moved from its original location (www.losthero.com/game/) to its current location (webgame.losthero.com/). The transaction still works, but you have to manually modify the final url, the one that gives you a 404 error page. Only then will you actually be credited with the exact amount of diamonds you purchased through PayPal.

This is due to the fact that the developer has evolved Lost Hero to a completely different game, with a standalone 3D engine, not brower based game.


## Developing
You can test and develop the LostHeros-CLI, starting with the info available from `./bin-linux/lh-help --dev`, which tells you what each script does. Look at the source to see the soft links in `lh-install.sh`. The alias's are in `./bin-linux/shinit`.

You can set a TST variable in some scripts that would normally download a new HTML text file for processing by other scripts. This helps a lot while developing complex extraction algorythims. It is quicker to use `head` and `tail` together to limit the amount of data you (and `grep`) are working with, piping the result out to a `_file_.cut` file.

Only some commands require newly download content for various processing updates and that is controlled by both the content and the timestamp of the hidden file `.update`, the contents of which is cleared after a new download action. Any text can be used, but the unix timestamp (%Y) is easy to get from `stat`, and can easily verified at the command line as well (`date --date='@2147483647'`).

This project was developed on a Raspberry Pi using a Raspbian Jessie based OS (http://pipaos.mitako.eu), and should be quick even on a single core ARMv6 processor, even when running Wheezy or older.


## Requirements
(Package names to come as I figure them out)

The following binaries are used in LostHeros-CLI shell scripts:

```
sh
expr
test
grep
cut
paste
tr
dirname
basename
sed
ls
cat
curl
wget
```

On this system `/bin/sh` is linked to `/bin/dash`, not `/bin/bash` or `/bin/busybox`. On some systems a minimal `sh` (8K-25K) is even smaller that `dash` (50K), but `dash` is not in its minimal form. Both are less that a minimal `bash` (80K), but most systems have a full blown `bash` (800K).

The scripts will use cURL over Wget, and will print an error message if neither exists. `curl` is prefered because not every url processed requires a page to be written to disk, which is what `wget` always does.

