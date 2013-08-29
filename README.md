# myddns

A bash script that maintains a dynamic DNS record.

Inspired by:

http://nexus.zteo.com/blog/your-own-dynamic-dns-in-3-steps/

## Quick Setup

This assumes you have already got your name server configured for remote updates
using nsupdate.  See below for more details on how to get that part configured.

1. Clone the myddns repo:
    
    ```git clone https://github.com/rmacduff/myddns.git```
    
2. Make the myddns directory:

    ```mkdir ${HOME}/.myddns```
    
3. Copy the myddns configuration file in the myddns directory:

    ```cp myddns.conf $HOME/.myddns```

4. Update myddns.conf with the particulars of your record and domain.

5. Add a cron job to trigger this script.  Be nice to the upstream IP provider and don't run it more than once per hour. 

