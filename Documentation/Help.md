# How fast and reliable is your Wifi?

Performance tests like Speedtest.net will tell you how fast your Internet connection is, but Wifi can significantly affect speed, latency and reliability. With broadband Internet connections getting faster and faster, Wifi usually already is the bottleneck.

This app will help you test your Wifi connection in isolation of your Internet connection across your home or office and tell your exactly what you can expect in every room. You can then adjust your settings and move access points around or decide to upgrade your equipment until you achieve super solid Wifi.

# How does the performance test work?

The app embeds the [iPerf 3](https://iperf.fr/) library which is the standard way to test bandwidth across servers. You need to install and set up an iPerf 3 server for this app to connect to. It will then send test data across the network and tell you what your top Wifi connection speed is, and how consistent it is.

# Running an iPerf 3 server

To run an iPerf 3 server you will need a computer connected to your home network / router over a network cable. Laptops work, though you will want to make sure the Ethernet adapter is capable of Gigabit speeds if you use one. Running the server over Wifi might interfere with the app sending data and make the test show much slower results.

I will cover how to install iPerf 3 on a Mac, [guides are available on the iperf.fr website](https://iperf.fr/iperf-download.php) to install it on Linux and Windows as well. Installing an iPerf 3 server requires being familiar with the command line and installing Homebrew. If I haven't scared you off yet, let's get started:

* open the Terminal app
* if you haven't already done so, install the standard Mac package manager called [Homebrew](https://brew.sh/), by copying the command mentioned under *Install Homebrew* on the [https://brew.sh/](https://brew.sh/) website and running it in the terminal
* if you have installed Homebrew before, update it by running `brew update` in the terminal
* if you haven't installed iPerf 3 yet, run `brew install iperf3` in the terminal
* finally run iPerf 3 in server mode by running `iperf3 -s -D`
* write down your computer's IP address, which you can see in the Network System Preferences panel (where you can also confirm that you are connected over Ethernet)
* try it out by running `iperf3 -c your.ip.address` (the test results will be insanely high because it isn't actually going through the network, but going to your server directly on your machine)
* if you would like to stop the server just open the terminal and run `killall iperf3`

Congratulations! The server will now run until you restart your computer or log out of your account. If your server is unavailable, you can run it again by opening the terminal and running `iperf3 -s -D`.

Now you can run the app, enter your server's IP address and run a test

# Advanced settings

# Where can I get help?
