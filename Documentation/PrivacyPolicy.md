# Privacy Policy

This policy applies to all information collected or submitted on the iPerf apps for iPhone and any other devices and platforms.

## Information we collect

We do not collect any data through the app, the only data that is exchanged is between the app and the iPerf 3 server you are connecting to. The help section is embedded in the app and does not connect to a server. We recommend [running your own iPerf 3 server](https://github.com/ndfred/iperf-ios/blob/master/Documentation/Help.md).

When running a test:

* the app connects to an iPerf 3 server and sends [the test's parameters](https://github.com/ndfred/iperf-ios/blob/master/Source/iperf3/iperf_api.c#L1526)
* it then sends or receives random test data to / from the server
* finally the [test results](https://github.com/ndfred/iperf-ios/blob/master/Source/iperf3/iperf_api.c#L1690) are sent to the server

## Analytics

The app does not collect any analytics beyond what is needed to run an iPerf 3 test as described in the prior section.

## Your Consent

By using this app, you consent to our privacy policy.

## Contacting Us

If you have questions regarding this privacy policy, you may [open an issue on github](https://github.com/ndfred/iperf-ios/issues).

## Credits

This privacy policy is inspired by the [Overcast privacy policy](https://overcast.fm/privacy).

## Changes to this policy

If we decide to change our privacy policy, we will post those changes on this page. Summary of changes so far:

May 15, 2019: First published.
