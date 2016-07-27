# wifiwarn

Wifiwarn keeps a status bar icon and changes it for certain hard-coded wifi ssids.

The SSID is hardcoded in `wifiwarn/AppDelegate.swift`.

This currently polls the SSID every 10 seconds because I can't figure out how to properly listen to the SSID Change events. (See https://github.com/colemickens/wifiwarn/issues/2)
