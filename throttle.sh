#!/bin/bash

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
# Pipe 1 is the default, and will be limited
# Pipe 2 will not be limited
cat <<EOF | pfctl -q -a xno_limit -f -
dummynet in quick proto tcp from any to any pipe 1
dummynet in proto icmp all pipe 2
dummynet in proto tcp to any port 443 pipe 2
dummynet in proto tcp to any port 80 pipe 2
dummynet in proto tcp to any port 22 pipe 2
no dummynet quick on lo0 all
dummynet out all pipe 3
dummynet out proto icmp all pipe 4
dummynet out proto tcp to any port 443 pipe 4
dummynet out proto tcp to any port 80 pipe 4
dummynet out proto tcp to any port 22 pipe 4
EOF

# Create the dummynet queue
#dnctl pipe 1 config bw 30Kbyte/s queue 50
#dnctl pipe 2 config queue 50
dnctl pipe 1 config bw 300Kbyte/s queue 50
dnctl pipe 2 config queue 50
dnctl pipe 3 config bw 100Kbyte/s queue 50
dnctl pipe 4 config queue 50

# Activate PF
pfctl -E