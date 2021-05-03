#!/bin/bash

# Max speeds in KB/sec
OUTBOUND=100

#
# From https://superuser.com/questions/841604/limiting-upload-bandwidth-in-mac-os-x-yosemite-10-10
# and https://mop.koeln/blog/limiting-bandwidth-on-mac-os-x-yosemite/
#

# Reset dummynet to default config
dnctl -f flush
pfctl -F all

# Compose an addendum to the default config; creates a new anchor
(cat /etc/pf.conf &&
  echo 'dummynet-anchor "xno_limit"' &&
  echo 'anchor "xno_limit"') | pfctl -q -f -

# Configure the new anchor
# Pipe 3 is the default, and will be limited
# Pipe 4 will not be limited
cat <<EOF | pfctl -q -a xno_limit -f -
no dummynet quick on lo0 all
dummynet out all pipe 3
dummynet out to 192.168.0.0/16 pipe 4
dummynet out proto icmp all pipe 4
EOF

# Create the dummynet queue
dnctl pipe 3 config bw ${OUTBOUND}Kbyte/s queue 50
dnctl pipe 4 config queue 50

# Activate PF
pfctl -E