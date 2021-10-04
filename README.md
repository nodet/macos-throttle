# macos-throttle
A script to limit the bandwidth used in macOS

This script can be used to limit outbound bandwidth on macOS.
One particular reason to limit outbound traffic is to avoid the very bad ping 
times that one can get with some routers when the outbound traffic is too high.

- `sudo ./throttle.sh [rate]` will turn the limitation on.  The `rate` is the max speed
of the outbound traffic in KB/s. Default value is 100 KB/s.
- `sudo ./no-limit.sh` will remove the limitation.

If using a VPN, you should run `throttle.sh` *after* you've established the 
VPN connection.
