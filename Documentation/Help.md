## How fast and reliable is your Wifi?

Online tests like [Speedtest](https://www.speedtest.net/), Netflix's [FAST](https://fast.com/) and [DSLReports](https://www.dslreports.com/speedtest) will tell you how fast your Internet connection is overall, but your service provider's speed is not the only factor: Wifi itself can significantly affect speed, latency and reliability. And with broadband Internet connections getting faster and faster, Wifi usually already is the bottleneck.

This app will help you test your Wifi connection in isolation of your Internet connection across your home or office and tell your exactly what you can expect in every room. You can then adjust your settings and move access points around or decide to upgrade your equipment until you achieve super solid Wifi.

## How does the performance test work?

The app embeds the [iPerf 3](https://iperf.fr/) library which is the standard way to test bandwidth across servers. You need to install and set up an iPerf 3 server for this app to connect to. It will then send test data across the network and tell you what your fast and consistent your Wifi connection is.

## Running an iPerf 3 server

To run an iPerf 3 server you will need a computer connected to your home network / router over a network cable. Laptops work, though you will want to make sure the Ethernet adapter is capable of Gigabit speeds if you use one. Running the server over Wifi might interfere with the app sending data and make the test show much slower results.

We will cover how to install iPerf 3 on a Mac, [guides are available on the iperf.fr website](https://iperf.fr/iperf-download.php) to install it on Linux and Windows as well. Installing an iPerf 3 server requires being familiar with the command line and installing Homebrew. If we haven't scared you off yet, let's get started:

* open the Terminal app
* if you haven't already done so, install the standard Mac package manager called [Homebrew](https://brew.sh/), by copying the command mentioned under *Install Homebrew* on the [https://brew.sh/](https://brew.sh/) website and running it in the terminal
* if you have installed Homebrew before, update it by running `brew update` in the terminal
* if you haven't installed iPerf 3 yet, run `brew install iperf3` in the terminal
* finally run iPerf 3 in server mode by running `iperf3 -s -D`
* write down your computer's IP address, which you can see in the Network System Preferences panel (where you can also confirm that you are connected over Ethernet)
* try it out by running `iperf3 -c your.ip.address` (the test results will be insanely high because it isn't actually going through the network, but going to your server directly on your machine)
* if you would like to stop the server just open the terminal and run `killall iperf3`

Congratulations! The server will now run until you restart your computer or log out of your account. If your server is unavailable, you can run it again by opening the terminal and running `iperf3 -s -D`.

Now you can run the app, enter your server's IP address and run a test. If you try to run two tests simultaneously you will see a "Server is busy" error: this is by design, as the tests would interfere with each other. Just wait for the other test to finish and run yours again.

## Analyzing test results

When running performance tests with the app you should look at:

* **Average bandwidth**: if your iOS device gets 300 Mbits/s or more, you are doing really great (that translates to about 40 MB/s). That means it is connecting over 5 GHz and is plenty for great surfing, gaming and streaming.

* **Bandwidth fluctuation**: as the test runs, pay attention to how consistently the bandwidth number is. If you see important fluctuations, Wifi reliability might be an issue.

Make sure you run the test in all the rooms that matter to you, as performance can differ. If you identify issues or blind spots, there are many ways to improve Wifi performance, among which:

* **Location**: get your access points closer to where you spend most of your time (in the living room and the kitchen for instance). This might mean moving your service provider's router / Wifi combo, or getting separate access points that you can run network cable to.

* **Settings**: make sure 5 GHz is enabled, and use the same network name for both 2.4 GHz and 5 GHz, your iOS device will automatically figure out which to connect to

* **Interference**: picking your Wifi bands manually will allow you to pick the least crowded bands and have a faster, more reliable connection

We have found that having multiple access points is the key to reliable Wifi if your home or office has more than two walls between you and your access point, and running network cable across these access points (rather than using mesh networking) to provide the best performance and reliability. In that case, make sure you set the same network name and password across all access points and avoid overlapping channels, and the iOS devices will figure out how to connect to the closest access point automatically. If running network cable is not an option, using a mesh networking system is usually best.

## Advanced settings

There are a few settings you can tweak in the UI, here is what they mean:

* **Transmit mode**: select whether you want to test uploading or downloading data from / to your iOS device, download is usually faster and what you want but upload will help you understand how fast your iOS device really is (it is less affected by the access point's power level and antenna design)

* **Streams**: select how many parallel streams of data should be used during the test, 1 is not enough for devices that have more than one Wifi antenna so 2 and up are recommended

* **Test duration**: select how long you'd like to run the test, 30 seconds is a good amount of time to get stable data but feel free to set more and walk around your home or office to see how the bandwidth changes. Tests can be stopped at any time so feel free to set a high duration and stop it when you are happy.

The app is currently using the iPerf 3.6 code, though using a server with a different version will be fine. We aim to keep it up to date, if you think the app needs an update please get in touch by looking at the *Where can I get help?* section.

## Where can I get help?

If the app is not working as intended, please [create an issue on github](https://github.com/ndfred/iperf-ios/issues), post in the [Unifi forum](https://community.ubnt.com/t5/UniFi-Wireless/Help-test-a-new-open-source-iPerf-3-iOS-app/td-p/2774321) or [ping me on Twitter](https://twitter.com/ndfred). You can also join the [TestFlight public beta](https://github.com/ndfred/iperf-ios#testing) and report issues over email there. Finally this project is open source and [contributions are welcome](https://github.com/ndfred/iperf-ios#contributing), and positive feedback and stories on how you use the app is also appreciated!

## Privacy policy

See our [privacy policy page](https://github.com/ndfred/iperf-ios/blob/master/Documentation/PrivacyPolicy.md).

## License

The app and the iPerf 3 library it embeds is licensed under the BSD license:

    "iperf, Copyright (c) 2014-2018, The Regents of the University of California,
    through Lawrence Berkeley National Laboratory (subject to receipt of any 
    required approvals from the U.S. Dept. of Energy).  All rights reserved."

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    (1) Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    (2) Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation and/
    or other materials provided with the distribution.

    (3) Neither the name of the University of California, Lawrence Berkeley
    National Laboratory, U.S. Dept. of Energy nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
    ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    You are under no obligation whatsoever to provide any bug fixes, patches, or
    upgrades to the features, functionality or performance of the source code
    ("Enhancements") to anyone; however, if you choose to make your Enhancements
    available either publicly, or directly to Lawrence Berkeley National
    Laboratory, without imposing a separate written license agreement for such
    Enhancements, then you hereby grant the following license: a  non-exclusive,
    royalty-free perpetual license to install, use, modify, prepare derivative
    works, incorporate into other computer software, distribute, and sublicense
    such enhancements or derivative works thereof, in binary and source code form.

    =====

    This software contains source code (src/cjson.{c,h}) that is:

      Copyright (c) 2009 Dave Gamble

      Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the "Software"), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:

      The above copyright notice and this permission notice shall be included in
      all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      THE SOFTWARE.

    =====

    This software contains source code (src/net.{c,h}) that is:

      This software was developed as part of a project at MIT.

      Copyright (c) 2005-2007 Russ Cox,
    		     Massachusetts Institute of Technology

      Permission is hereby granted, free of charge, to any person obtaining
      a copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:

      The above copyright notice and this permission notice shall be
      included in all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
      LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
      OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
      WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

      ===

      Contains parts of an earlier library that has:

      /*
       * The authors of this software are Rob Pike, Sape Mullender, and Russ Cox
       *              Copyright (c) 2003 by Lucent Technologies.
       * Permission to use, copy, modify, and distribute this software for any
       * purpose without fee is hereby granted, provided that this entire notice
       * is included in all copies of any software which is or includes a copy
       * or modification of this software and in all copies of the supporting
       * documentation for such software.
       * THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
       * WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR LUCENT TECHNOLOGIES MAKE ANY
       * REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
       * OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
      */

    =====

    This software contains source code (src/net.c) that is:

    /*
     * Copyright (c) 2001 Eric Jackson <ericj@monkey.org>
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *   notice, this list of conditions and the following disclaimer.
     * 2. Redistributions in binary form must reproduce the above copyright
     *   notice, this list of conditions and the following disclaimer in the
     *   documentation and/or other materials provided with the distribution.
     * 3. The name of the author may not be used to endorse or promote products
     *   derived from this software without specific prior written permission.
     *
     * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
     * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
     * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
     * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
     * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
     * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
     * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
     * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
     * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
     */

    =====

    This software contains source code (src/queue.h) that is:

      /*
       * Copyright (c) 1991, 1993
       *      The Regents of the University of California.  All rights reserved.
       *
       * Redistribution and use in source and binary forms, with or without
       * modification, are permitted provided that the following conditions
       * are met:
       * 1. Redistributions of source code must retain the above copyright
       *    notice, this list of conditions and the following disclaimer.
       * 2. Redistributions in binary form must reproduce the above copyright
       *    notice, this list of conditions and the following disclaimer in the
       *    documentation and/or other materials provided with the distribution.
       * 3. Neither the name of the University nor the names of its contributors
       *    may be used to endorse or promote products derived from this software
       *    without specific prior written permission.
       *
       * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
       * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
       * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
       * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
       * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
       * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
       * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
       * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
       * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
       * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
       * SUCH DAMAGE.
       *
       *      @(#)queue.h     8.5 (Berkeley) 8/20/94
       */

    =====

    This software contains source code (src/units.{c.h}) that is:

      /*---------------------------------------------------------------
       * Copyright (c) 1999,2000,2001,2002,2003
       * The Board of Trustees of the University of Illinois
       * All Rights Reserved.
       *---------------------------------------------------------------
       * Permission is hereby granted, free of charge, to any person
       * obtaining a copy of this software (Iperf) and associated
       * documentation files (the "Software"), to deal in the Software
       * without restriction, including without limitation the
       * rights to use, copy, modify, merge, publish, distribute,
       * sublicense, and/or sell copies of the Software, and to permit
       * persons to whom the Software is furnished to do
       * so, subject to the following conditions:
       *
       *
       * Redistributions of source code must retain the above
       * copyright notice, this list of conditions and
       * the following disclaimers.
       *
       *
       * Redistributions in binary form must reproduce the above
       * copyright notice, this list of conditions and the following
       * disclaimers in the documentation and/or other materials
       * provided with the distribution.
       *
       *
       * Neither the names of the University of Illinois, NCSA,
       * nor the names of its contributors may be used to endorse
       * or promote products derived from this Software without
       * specific prior written permission.
       *
       * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
       * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
       * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
       * NONINFRINGEMENT. IN NO EVENT SHALL THE CONTIBUTORS OR COPYRIGHT
       * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
       * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
       * ARISING FROM, OUT OF OR IN CONNECTION WITH THE
       * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
       * ________________________________________________________________
       * National Laboratory for Applied Network Research
       * National Center for Supercomputing Applications
       * University of Illinois at Urbana-Champaign
       * http://www.ncsa.uiuc.edu
       * ________________________________________________________________
       *
       * stdio.c
       * by Mark Gates <mgates@nlanr.net>
       * and Ajay Tirumalla <tirumala@ncsa.uiuc.edu>
       * -------------------------------------------------------------------
       * input and output numbers, converting with kilo, mega, giga
       * ------------------------------------------------------------------- */

    =====

    This software contains source code (src/portable_endian.h) that is:

    // "License": Public Domain
    // I, Mathias Panzenböck, place this file hereby into the public domain. Use it at your own risk for whatever you like.

    =====
