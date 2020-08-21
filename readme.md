# What the heck is this lbc.sh?
This is a simple shell script I created to automate the tedious process of moving my LBRY Credits from my vidoes into my wallet. This is meant for creators who publish their videos on [LBRY](https://lbry.com) and want a quick, simple way to move the LBC they earn from views/tips/etc into their wallet.

## Why is this?
Beacuse I'm lazy and I export credits a lot... and the manual process I used to follow used to take literal hours.

# How do I use this?
Run `lbc.sh` from your terminal. The script will ask if you want to export your credits (defaults to YES). From there it should do the rest on its own.

# What do I need to use this?
First, need a bash command line (read: not Windows). You'll need to have LBRY installed with your wallet in place.

You need to have the `lbrynet` command available. If you installed LBRY through the AUR, you'll probably want to link `/opt/LBRY/resources/static/daemon/lbrynet` to `/usr/local/bin/` or something before running this script.

## What happens if something goes wrong?
Use of this script is **entirely on you**. You are responsible for its responsible usage and you should inspect the script before executing it. I wrote this script for my own purposes, but it comes with **ABSOLUTELY NO WARRANTY**. I can't be held responsible for lost credits or anything else that could possibly go wrong with this process.
