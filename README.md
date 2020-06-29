# iPerf iOS [![Build Status](https://travis-ci.com/ndfred/iperf-ios.svg?branch=master)](https://travis-ci.com/ndfred/iperf-ios/)

Run an [iPerf3](https://iperf.fr/) client on your iPhone or iPad, including reverse mode and multiple stream selection:

<img src="Screenshot.png" alt="Screenshot" width="375">

## Download
Download on the [App Store](https://apps.apple.com/us/app/iperf-3-wifi-speed-test/id1462260546).

## Why?

This [UniFi forum thread](https://community.ubnt.com/t5/UniFi-Wireless/Help-test-a-new-open-source-iPerf-3-iOS-app/td-p/2774321) explains there are quite a few iPerf 3 apps (like [iPerf](https://itunes.apple.com/us/app/iperf-speed-test-tool/id951598770), [HE.NET](https://itunes.apple.com/us/app/he-net-network-tools/id858241710), [Fleet](https://itunes.apple.com/us/app/fleet-remote/id1218309561) and [WifiPerfEndPoint](https://itunes.apple.com/us/app/wifiperf-endpoint/id909661121)) out there but:

* none of them use a recent iPerf 3 codebase which includes a fix to make results more reliable
* most of them are pretty crashy
* few of them support server mode, which can be leveraged to query a bunch of iOS devices from a wired computer when testing across a wide array of clients

What you should expect from this new iPerf app:

* **tiny**: The app is only 126 KB.
* **modern**: It is based on iPerf 3.6.
* **stable**: Albeit a new project, it does work, and the aim is to write tests for everything.
* **fast**: No memory leaks, CPU mostly doing system calls instead of app code, and the bandwidth test is in a high priority background thread, with another thread for the UI.
* **simple**: Get straight to iPerf parameters.
* **libre**: Use, study. change and share
* **copyleft**: with everyone, always.

## Testing

Join the beta program and test the latest version before App Store release, by opening [this TestFlight link](https://testflight.apple.com/join/nwHybaz8). Leave feedback [on the UniFi forum thread](https://community.ubnt.com/t5/UniFi-Wireless/Help-test-a-new-open-source-iPerf-3-iOS-app/td-p/2774321), as an [issue on GitHub](https://github.com/ndfred/iperf-ios/issues) or over e-mail from within the TestFlight app.

The [App Store release](https://github.com/ndfred/iperf-ios/milestone/1) milestone tracks all issues blocking it.

## Contributing

Pull requests and opened issues are welcomed heartily. [Documenting issues](https://github.com/ndfred/iperf-ios/issues) is also needed, feel free to pick one up. Translations and app / icon design contributions are welcome too!

To upgrade iPerf, edit and run `sync.sh` to pull the latest changes from [upstream](https://github.com/esnet/iperf) into the app.

[Travis CI is set up](https://travis-ci.com/ndfred/iperf-ios/) to build the app continuously and run tests.

## Wishlist

These should eventually be [tracked as issues](https://github.com/ndfred/iperf-ios/issues):

* See open issues.
* Add a 'Cancel' button.
* Graphs and progress bar.
* Indefinite test duration, stop when confidence is high enough.
* Nicer UI with localization.
* Server mode with UPnP to allow external access.
* Public iPerf3 servers.
* Report lost packets and stability.
* Scan LAN for iPerf servers.
* Combined sending + reception test.
* Latency test.
* Switch unit from Mbits/s to MB/s when taping on the number.
* Ship to the App Store.
* Public database of results by device.
* Guide to run a server.
* macOS version.
* [Parse iOS Wi-Fi logs](https://community.ubnt.com/t5/UniFi-Wireless/Intermittent-Connectivity-with-Apple-Devices-amp-Fast-Roaming/m-p/2353446#M297508) to diagnose roaming and connectivity issues.
* Suggest expected speed from device database (number of antennas, 2.4GHz and 5GHz tests).
* Crash and error reporting.
* UDP test.
