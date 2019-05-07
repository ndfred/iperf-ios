# iPerf iOS [![Build Status](https://travis-ci.com/ndfred/iperf-ios.svg?branch=master)](https://travis-ci.com/ndfred/iperf-ios/)

Run an [iPerf3](https://iperf.fr/) client on your iPhone or iPad, including reverse mode and multiple streams selection:

<img src="Screenshot.png" alt="Screenshot" width="375">

## Why?

See the [Unifi forum thread](https://community.ubnt.com/t5/UniFi-Wireless/Help-test-a-new-open-source-iPerf-3-iOS-app/td-p/2774321) for a bit of back story, basically there are quite a few iPerf 3 apps (like [iPerf](https://itunes.apple.com/us/app/iperf-speed-test-tool/id951598770), [HE.NET](https://itunes.apple.com/us/app/he-net-network-tools/id858241710), [Fleet](https://itunes.apple.com/us/app/fleet-remote/id1218309561) and [WifiPerfEndPoint](https://itunes.apple.com/us/app/wifiperf-endpoint/id909661121)) out there but:

* none of them use a recent iPerf 3 codebase which includes a fix to make results more reliable
* most of them are pretty crashy
* few of them support server mode, which can be leveraged to query a bunch of iOS devices from a wired computer when testing across a wide array of clients

What you should expect from this new iPerf app:

* **tiny**: the current app download is 126k
* **modern**: based on the latest stable iPerf 3.6 codebase
* **stable**: we'd like for it to go under heavy dogfooding / testing (see the TestFlight program below) so we can iron out most of the bugs and make this super solid
* **fast**: after instrumentation it has no memory leaks that we could see, the vast majority of the CPU is going to system calls and not the app's code, and the bandwidth test is using a high priority background thread to utilize the second CPU core while the other one drives the UI
* **simple**: see the screenshot, the UI is really simple (if not bare bones) and maps straight to iPerf parameters
* **open source**: no surprises, you can look at the source code which is what I use to build the app

## Testing

If you would like to join the beta program and test the latest version of the app before App Store release, please open [this TestFlight link](https://testflight.apple.com/join/nwHybaz8). You can leave feedback [on the Unifi forum thread](https://community.ubnt.com/t5/UniFi-Wireless/Help-test-a-new-open-source-iPerf-3-iOS-app/td-p/2774321), as an [issue on GitHub](https://github.com/ndfred/iperf-ios/issues) or over email from within the TestFlight app.

The [App Store Release](https://github.com/ndfred/iperf-ios/milestone/1) milestone tracks all the issues that are blocking, you guessed it, App Store release.

## Contributing

Please send a pull request or open an issue, we happily welcome contributions! We also try and [document issues](https://github.com/ndfred/iperf-ios/issues), feel free to pick one up and contribute there. Translations and app / icon design contributions are welcome too!

If a new version of iPerf comes out and you'd like to update the app, edit and run `sync.sh` to pull the latest changes from [upstream](https://github.com/esnet/iperf).

[Travis CI is set up](https://travis-ci.com/ndfred/iperf-ios/) to build the app continuously and run tests.

## Wishlist

These should eventually be [tracked as issues](https://github.com/ndfred/iperf-ios/issues):

* See open issues
* Add a cancel button
* Graphs and progress bar
* Indefinite test duration, stop when confidence is high enough
* Nicer UI with localization
* Server mode with UPnP to allow external access
* Public iPerf3 servers
* Report lost packets and stability
* Scan LAN for iPerf servers
* Combined send + Receive test
* Latency test, 
* Switch unit from Mbits/s to MB/s when taping on the number
* Ship to the App Store
* Public database of results by device
* Guide to run a server
* MacOS version
* [Parse iOS Wifi logs](https://community.ubnt.com/t5/UniFi-Wireless/Intermittent-Connectivity-with-Apple-Devices-amp-Fast-Roaming/m-p/2353446#M297508) to diagnose roaming and connectivity issues
* Suggest expected speed from device database (number of antennas, 2.4GHz and 5GHz tests)
* Crash and error reporting
* UDP test
