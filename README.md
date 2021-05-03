# macos-throttle
A script to limit the bandwidth used in macOS

This script can be used to limit the inbound or outbound bandwidth on macOS.  
One particular reason to limit outbound traffic is to avoid the very bad ping 
times that one can get with some routers when the outbound traffic is too high.

- `$ sudo ./throttle.sh` will turn the limitations on.
- `$ sudo ./no-limit.sh` will remove the limitations
