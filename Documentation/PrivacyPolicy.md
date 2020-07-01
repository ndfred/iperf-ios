# Privacy Policy

This policy applies to all info collected or submitted from the iPerf apps for iPhone and any other devices and platforms.

## Collected info

No data is collected through the app. The only exchange data is between the app and the iPerf 3 server it connects to. The help section is embedded in the app and does not connect to a server. It is recommended to [run your own iPerf 3 server](https://github.com/ndfred/iperf-ios/blob/master/Documentation/Help.md).

When running a test:

* The app connects to an iPerf 3 server and sends [the test's parameters](https://github.com/ndfred/iperf-ios/blob/master/Source/iperf3/iperf_api.c#L1526).
* Random test data is sent to / and from the server.
* Finally the [test results](https://github.com/ndfred/iperf-ios/blob/master/Source/iperf3/iperf_api.c#L1690) are sent to the server.

## Analytics

The app itself does not collect any info, and its operation does not exchange any info with the server that is considered personal data as per [article 4 of the EU-GDPR](https://gdpr-info.eu/art-4-gdpr/). The app does not collect or send anything beyond what is described in "Collected info".
The Apple App Store has its own privacy policy, which becomes effective if you get the app from there. Your Apple device also has its own privacy policy governance that is outside the realm of the iPerf app. See https://www.apple.com/privacy/control/

## Your Consent

By using this app, you consent to exchange info as described above with the server you are using it with.

## Contacting Us

Question this privacy policy by [opening an issue on GitHub](https://github.com/ndfred/iperf-ios/issues).

## Credits

This privacy policy is inspired by the [Overcast privacy policy](https://overcast.fm/privacy).

## Changes to this privacy policy

Changes to our privacy policy so far:

May 15, 2019: First published.
