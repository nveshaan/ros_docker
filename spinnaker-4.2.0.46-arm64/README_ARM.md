//=============================================================================  
// Copyright (c) 2024 FLIR Integrated Imaging Solutions, Inc. All Rights Reserved.  
//  
// This software is the confidential and proprietary information of FLIR  
// Integrated Imaging Solutions, Inc. ("Confidential Information"). You  
// shall not disclose such Confidential Information and shall use it only in  
// accordance with the terms of the license agreement you entered into  
// with FLIR Integrated Imaging Solutions, Inc. (FLIR).  
//  
// FLIR MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE  
// SOFTWARE, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE  
// IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR  
// PURPOSE, OR NON-INFRINGEMENT. FLIR SHALL NOT BE LIABLE FOR ANY DAMAGES  
// SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING  
// THIS SOFTWARE OR ITS DERIVATIVES.  
//  =============================================================================

# README

# TABLE OF CONTENTS

- [1. DEPENDENCIES]
  - [1.1. UBUNTU 22.04 DEPENDENCIES]
    - [1.1.1. UBUNTU 22.04 DEPENDENCY INSTALLATION]
  - [1.2. UBUNTU 20.04 DEPENDENCIES]
    - [1.2.1. UBUNTU 20.04 DEPENDENCY INSTALLATION]
- [2. SPINNAKER INSTALLATION]
- [3. USB CAMERA SETUP]
- [4. GIGE CAMERA SETUP]
  - [4.1. DISABLE REVERSE PATH FILTERING (RPF)]
  - [4.2. INCREASE RECEIVE BUFFER SIZE]
  - [4.3. ENABLE JUMBO PACKET]
  - [4.4. SET 5G LINK SPEED]
  - [4.5. TUNING JETSON FOR OPTIMAL GIGE PERFORMANCE]
  - [4.6. NETWORKING BEST PRACTICES]
- [5. GENICAM GENTL PRODUCER SETUP]
  - [5.1. GENTL LOGGING]
- [6. SPINNAKER REMOVAL]
- [7. RUNNING PREBUILT UTILITIES]
  - [7.1. SpinView QT]
  - [7.2. SpinUpdateConsole]
- [8. TELEDYNE-MV SPINNAKER EXAMPLES]
- [9. FREQUENTLY ASKED QUESTIONS]
  - [9.1. FLICKERING OF THE DISPLAY]


===============================================================================
## 1. DEPENDENCIES  
===============================================================================

To install Spinnaker on Linux a few prerequisite libraries will need to be installed.

-------------------------------------------------------------------------------
### 1.1. UBUNTU 22.04 DEPENDENCIES
-------------------------------------------------------------------------------

For Ubuntu 22.04 LTS, below is a list of libraries that Spinnaker and other
components depend on:

1) Core Image Acquisition Library
The core library includes Spinnaker and Spinnaker-C

- libusb-1.0-0 (version 1.0.17 or greater recommended)

2) SpinView_QT

- qtbase5-dev
- qtchooser
- qt5-qmake
- qtbase5-dev-tools

Strongly recommended:
Ubuntu 22.04 LTS:   Linux kernel version 5.15 or later.

-------------------------------------------------------------------------------
#### 1.1.1. UBUNTU 22.04 DEPENDENCY INSTALLATION
-------------------------------------------------------------------------------

To install these dependencies, the most straightforward approach is to use the
system's built-in package management utility. In the case of Ubuntu, the utility
is named "apt".  
Below is a one-line command that can be used to install all the required 
dependencies for Ubuntu 20.04 Long Term Support (LTS):

    $ sudo apt-get install libusb-1.0-0 qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

-------------------------------------------------------------------------------
### 1.2. UBUNTU 20.04 DEPENDENCIES
-------------------------------------------------------------------------------

For Ubuntu 20.04 LTS, below is a list of libraries that Spinnaker and other
components depend on:

1) Core Image Acquisition Library
The core library includes Spinnaker and Spinnaker-C

- libusb-1.0-0 (version 1.0.17 or greater recommended)

2) SpinView_QT

- qt5-default

Strongly recommended:  
- Ubuntu 20.04 LTS
- Linux kernel version 5.4 or later

-------------------------------------------------------------------------------
#### 1.2.1. UBUNTU 20.04 DEPENDENCY INSTALLATION
-------------------------------------------------------------------------------

To install these dependencies, the most straightforward approach is to use your
system's built-in package management utility.  
In the case of Ubuntu, the utility is named "apt".  
Below is a set of one-line commands that can be used to install all the required 
dependencies for various releases of 20.04 Ubuntu Long Term Support (LTS).

    $ sudo apt-get install libusb-1.0-0

===============================================================================
## 2. SPINNAKER INSTALLATION
===============================================================================

Once all the dependencies are installed, install the Spinnaker deb files, using
the install script 'install_spinnaker_arm.sh' provided in the directory spinnaker
was extracted into.

    $ sudo sh install_spinnaker_arm.sh

This script will install all the Spinnaker libraries, example code, example
apps and documentation.  
The Spinnaker install script will also ask you to configure udev so that a user
will be able to use the USB devices.  
If you choose to configure the USB devices, this script will change permissions
on the nodes to give this particular user full read and write access to the 
device nodes.  
It will overwrite the default Ubuntu permissions.    
After running this script everything should be installed and set up for use.

Unfortunately restarting udev doesn't seem to set the permissions on the device
nodes immediately.  
The machine may need to be rebooted before the user can access the device nodes.

The Spinnaker packages are:
- libgentl_<version>_<platform>.deb
- libspinnaker_<version>_<platform>.deb
- libspinnaker-dev_<version>_<platform>.deb
- libspinnaker-c_<version>_<platform>.deb
- libspinnaker-c-dev_<version>_<platform>.deb
- libspinvideo_<version>_<platform>.deb
- libspinvideo-dev_<version>_<platform>.deb
- libspinvideo-c_<version>_<platform>.deb
- libspinvideo-c-dev_<version>_<platform>.deb
- spinnaker_<version>_<platform>.deb
- spinnaker-doc_<version>_<platform>.deb
- spinupdate_<version>_<platform>.deb
- spinupdate-dev_<version>_<platform>.deb
- spinview-qt_<version>_<platform>.deb
- spinview-qt-dev_<version>_<platform>.deb

The packages with a preceding 'lib' are all the shared objects and their
respective dev packages.  
The spinnaker package installs the capture application which can be launched by
typing 'spinview' in a terminal or through the Applications menu.  
The spinnaker-doc package contains our documentation in pdf format (located in /opt/spinnaker/doc).

===============================================================================
## 3. USB CAMERA SETUP
===============================================================================

By default, USB-FS on Linux systems only allows 16 MB of buffer memory for all
USB devices.  
This may result in image acquisition issues from high-resolution cameras or
multiple-camera set ups.  
This limit must be increased to make use of the imaging hardware's full capabilities.

This method applies to Ubuntu standard installations.  
For ARM boards running other distributions, see our article on Using Spinnaker on ARM and Embedded Systems:  
<https://www.flir.com/support-center/iis/machine-vision/application-note/using-spinnaker-on-arm-and-embedded-systems/>

The Spinnaker installer asks to automatically set the appropriate USB-FS memory
settings, but you can also run the configuration script at any time:

    $ sudo sh configure_usbfs.sh

To manually configure the USB-FS memory:

1. If the /etc/rc.local file does NOT already exist on your system, run the
   following commands to create and make it executable

       $ sudo touch /etc/rc.local
       $ sudo chmod 744 /etc/rc.local

2. Open the /etc/rc.local file in any text editor,

       $ sudo nano /etc/rc.local

    and paste the following command at the end of the file:

       $ sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'

3. Save your changes and close the file.

4. Restart the machine.

To confirm that the memory limit has been updated, run the command:

    $ cat /sys/module/usbcore/parameters/usbfs_memory_mb

If this fails to set the memory limit, one can TEMPORARILY modify the
USB-FS memory until the next restart by running the following command:

    $ sudo sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'

If using multiple USB3 cameras, the USB-FS memory limit may need to exceed 1000.  
More information on these changes can be found at:  
<https://www.flir.com/support-center/iis/machine-vision/application-note/understanding-usbfs-on-linux>

On some ARM platforms, the number of buffers that can be submitted to libusb
is further limited by the following two kernel settings.

1. coherent_pool

   If Spinnaker fails to begin acquisition and you find messages in dmesg similar to  
    - "xhci_hcd 0000:01:00.0: Ring expansion failed" or  
    - "usb 2-1: usbfs: usb_submit_urb returned -12",

   you may want to increase the coherent atomic allocation pool by:

       1.1 Opening /boot/firmware/cmdline.txt with elevated permission in any text editor.

       1.2 Add the following line at the end of the file or modify the existing entry if it exists:

           coherent_pool=5M

       1.3 Restart the machine.

2. swiotlb

   If Spinnaker fails to begin acquisition and you find messages in dmesg similar to  
   - "xhci_hcd 0000:01:00.0: swiotlb buffer is full (sz: 16384 bytes), total 32768 (slots), used 32414 (slots)" or
   - "usb 2-1: usbfs: usb_submit_urb returned -11",
    
   you may want to increase the swiotlb buffer by:

       1.1 Opening /boot/firmware/cmdline.txt with elevated permission in any text editor.

       1.2 Add the following line at the end of the file or modify the existing entry if it exists:

           swiotlb=32768

       1.3 Restart the machine.

===============================================================================
## 4. GIGE CAMERA SETUP
===============================================================================

To avoid packet loss on the network interface, a number of parameters may be
adjusted by the user.  
Important parameters to maximize are the MTU (maximum transmission unit) size 
and the number of receive buffers available to the NIC driver.  
This helps reduce the number of packets to process and therefore minimizes CPU
overhead and interrupts.

A network tuning script provided with the SDK can maximize the MTU (enabling
Jumbo frames) and optimize certain network settings, including the number of
receive buffers, using a standard tool named "ethtool".  
Note that depending on the type of network interface and architecture, not all 
parameters set by the script are supported.  
Also note that the changes applied by the tuning script will not persist when 
system is rebooted, so the user will need to re-run the script after a reboot 
or have the script setup to run automatically at start-up (via /etc/rc.local).

To install ethtool, run the following command:

    $ sudo apt install ethtool

The gev_nettweak tuning script is located in the following directory:

    /opt/spinnaker/bin/

For example, to adjust network interface eth0, use the following terminal
command to run the script (administrator privileges are required):

    $ sudo ./gev_nettweak eth0

The "gev_nettweak" script adjusts the following parameters to assist the standard
network stack in buffering more image data:

MTU : Maximizes the MTU (Maximal Transmission Unit) size on the NIC. This
      corresponds to the maximum packet size for image data. The use of NIC
      hardware whose drivers support "Jumbo frames" aids in making this value as
      large as possible (typically maximum is around 9K bytes (9216 bytes)).

net.ipv4.udp_rmem_min : Adjust the receive memory allocation size in the network
                        stack.

net.core.netdev_max_backlog : Adjust the network packet backlog queue size.

net.unix.max_dgram_qlen : Adjust the network queue length for UDP packets.
                          Computes the amount of memory for UDP packets - a
                          maximum image size and the number of cameras expected
                          provide a hint for this setting.

net.core.rmem_default :  
net.core.rmem_max     : Adjust the default (and maximum) memory for receiving
                        network packets.

rx_value :  
rx_jumbo : Use "ethtool" utility (if present) to adjust the setting of the
           network device drivers to optimize the rx_ring and the rx jumbo
           packet queue for maximum throughput and to disable the rx pause
           operation. This improves reception of image data packets from the
           cameras. (Sending to the camera is not as critical)

-------------------------------------------------------------------------------
### 4.1. DISABLE REVERSE PATH FILTERING (RPF)
-------------------------------------------------------------------------------

RPF is a security feature that limits the effect of DDOS attacks.  
To ensure that GigE cameras enumerate properly, RPF needs to be disabled.

To PERMANENTLY disable reverse path filtering:  
1. Run the following command:

       $ sudo gedit /etc/sysctl.d/10-network-security.conf

   Comment out the lines below in /etc/sysctl.d/10-network-security.conf:

       # Turn on Source Address Verification in all interfaces to
       # in order to prevent some spoofing attacks.
       ## net.ipv4.conf.default.rp_filter=1
       ## net.ipv4.conf.all.rp_filter=1

2. Restart the computer.

-------------------------------------------------------------------------------

To TEMPORARILY disable reverse path filtering for a specific network adapter
until the next reboot, eg. eth1, run the following commands:

    $ sudo sysctl -w net.ipv4.conf.all.rp_filter=0
    $ sudo sysctl -w net.ipv4.conf.eth1.rp_filter=0

Once RPF is disabled, the GigE camera should show up in SpinView Devices panel.  
If the camera's subnet mismatches the subnet of the network adapter (with
an exclamation mark), right-click GEV Interface and click "Auto Force IP".

To configure the IP address / subnet mask, or set a persisent IP, more
information can be found at:  
<https://www.flir.com/support-center/iis/machine-vision/knowledge-base/setting-an-ip-address-for-a-gige-camera-to-be-recognized-in-linux/>

-------------------------------------------------------------------------------
### 4.2. INCREASE RECEIVE BUFFER SIZE
-------------------------------------------------------------------------------

The receive buffer size is strongly recommended to be increased, in order to
greatly improve streaming results.  
This can be done via the gev_nettweak script method mentioned above or by 
following the manual instructions below.

To PERMANENTLY update the receive buffer size:
1. Run the following command:

       $ sudo gedit /etc/sysctl.conf

2. Add the following lines to the bottom of the /etc/sysctl.conf file:

       net.core.rmem_max=10485760  
       net.core.rmem_default=10485760

3. Once changes are persisted, they can be reloaded at any time by running the
   following command in sysctl:

       $ sudo sysctl -p

-------------------------------------------------------------------------------

To TEMPORARILY update the receive buffer size until the next reboot, run the
following commands:

    $ sudo sysctl -w net.core.rmem_max=10485760
    $ sudo sysctl -w net.core.rmem_default=10485760

More information can be found at:  
<https://www.flir.com/support-center/iis/machine-vision/knowledge-base/lost-ethernet-data-packets-on-linux-systems-using-flycapture2/>

-------------------------------------------------------------------------------
### 4.3. ENABLE JUMBO PACKET
-------------------------------------------------------------------------------

Jumbo Packet is strongly recommended to be enabled for the network adapter and
the camera, in order to greatly improve streaming results.  
This can be done via the gev_nettweak script method mentioned above or by 
following the manual instructions below to persist the configuration across reboots.

Run ifconfig and find the network adapter that the cameras are connected to
(eg. enp15s0):

    $ ifconfig

It might be necessary to disconnect the camera and run ifconfig again to find
the output difference, in order to find the network adapter name.

To PERMANENTLY enable Jumbo Packet for a specific network adapter (eg. enp15s0), follow
one of the methods below.

Note that when the following methods are used in conjunction with each other on Ubuntu 20.04 or newer,
your interface may sometimes be assigned 2 IP addresses, thus showing up twice in Spinnaker.

Netplan (Ubuntu 20.04 or newer)  
1. Open up your netplan YAML configuration in /etc/netplan/ in a text editor (as sudo):
   (eg. 01-network-manager-all.yaml)

       $ sudo gedit /etc/netplan/01-network-manager-all.yaml

2. Set the Maximum Transfer Unit (MTU) of the network adapter to the maximum allowable
   value for your interface (eg. 9000):  
   (change enp15s0 to match the name of the adapter connected to the camera,
   the address and netmask of the network adapter can also be configured here):

       network:
          ethernets:
             enp15s0:
                mtu: 9000
                addresses: [169.254.0.64/16]
                dhcp4: no

3. Restart the network by entering the command in the terminal

       $ sudo netplan apply

-------------------------------------------------------------------------------

To TEMPORARILY update enable Jumbo Packet until the next reboot, for a specific
network adapter, eg. enp15s0, run the following commands:

    $ sudo ifconfig enp15s0 mtu 9000

To enable Jumbo Packet for the GigE camera, change SCPS Packet Size
(GevSCPSPacketSize) to 9000 in SpinView or via Spinnaker API.

If using multiple interfaces, ensure that the addresses used are on different
subnets (eg. 169.254.0.64/255.255.0.0 and 169.253.0.64/255.255.0.0).  
More information can be found at:  
<https://www.flir.com/support-center/iis/machine-vision/application-note/setting-up-multiple-gige-cameras/>

-------------------------------------------------------------------------------
### 4.4. SET 5G LINK SPEED
-------------------------------------------------------------------------------

To use the full potential of the Forge 5GigE, it is highly recommended to set
the auto-negotiation speed and duplex of your network adapter to 5GBASE-T.

We recommend using ethtool, a standard Linux utility for controlling Ethernet
devices, to do so.

To install ethtool, run the following command:

    $ sudo apt install ethtool

With ethtool installed, you can check the supported link modes:

    $ sudo ethtool enp15s0  

(change enp15s0 to match the name of the adapter connected to the camera)

If you are using a network adapter that supports 5GBASE-T and full duplex, you can
TEMPORARILY set the speed and duplex advertised by auto-negotiation by running the command:

    $ sudo ethtool -s enp15s0 advertise 0x1000000000000

To PERMANENTLY set it, navigate to /etc/rc.local and edit that file with a text editor.

Copy in the following:

    $ sudo ethtool -s enp15s0 advertise 0x1000000000000

where "0x1000000000000" is the hexadecimal value that specifies 5000baseT and
full duplex.

To check the hexadecimal values for other link modes, run <man ethtool>.

More information can be found at:
<https://www.flir.ca/products/forge-5gige/>

-------------------------------------------------------------------------------
### 4.5. TUNING JETSON FOR OPTIMAL GIGE PERFORMANCE
-------------------------------------------------------------------------------

For best success, the following tuning steps should be considered.

1) Use the Linux Capabilities interface:

   The examples "Acquisition" and "Enumeration" have this demonstrated in
   their makefiles.

   After building "Acquisition" or "Enumeration" ... do,

     $ sudo make rtcap
 
   This enables CAP_SYS_NICE, CAP_SYS_RESOURCE, and CAP_NET_RAW for the program.

   This can be added to other examples' Makefiles by appending:

   Set Linux capabilities for final binary

       rtcap:
           sudo setcap CAP_SYS_NICE,CAP_SYS_RESOURCE,CAP_NET_RAW+eip $(OUTDIR)/$(OUTPUTNAME)

   For more information on these capabilities, see here:  
   https://man7.org/linux/man-pages/man7/capabilities.7.html

2) Use the Power Mode with the most CPUs enabled:

    Usually this is via /usr/sbin/nvpmodel or the GUI based Power Mode control.

        $ sudo nvpmodel -m 0
    
    will enable full power to the module.

3) Just before running the application, wake up all "idle" CPUs - i.e. CPUs that
   are enabled but in a low power idle state.

       $ sudo jetson_clocks
    
    (depending on the platform, the cooling fan may start)

4) Disable Real-time limits on runtime scheduling usage. If not running a real-time 
   kernel, there is a limit on the ability to set real-time priorities for threads.
   
   As the "root" user,  

       $ echo -1 /proc/sys/kernel/sched_rt_runtime_us

   It can be difficult to get access as the root user.  
   If you encounter problems try,
   
       $ sudo -i
       $ echo -1 /proc/sys/kernel/sched_rt_runtime_us
       $ exit

Note: 
   For cameras with a 1Gbps interface, steps 1, 2, and 3 are sufficient.
   For cameras with NBaseT (2.5/5 Gbps) or 10Gbps interfaces, step 4 will be needed.
   
-------------------------------------------------------------------------------
### 4.6. NETWORKING BEST PRACTICES
-------------------------------------------------------------------------------

Using a subnet mask of 255.255.255.0 (or /24 in CIDR). 
This is a common practice in many network setups and is
preferred for the following reasons:

1) Network Size: Subnet masks of 255.255.255.0 allows for 256 possible IP addresses.
This is suitable for small to medium size networks where you need to
accommodate less than 256 devices.

2) IP Address Allocation: Plan your IP address allocation carefully to ensure
efficient use of the available addresses within the subnet.

3) Performance: Smaller subnets can reduce broadcast traffic and
improve network performance, since we don't need a lot of space for 256 
cameras we might as well take advantage of this.

It is also a good practice to avoid LLA (169.254.x.x) as the
Network Interface Cards statically assigned IP.  
In short we don't want to do this because it causes address conflicts,
incompatibilities, and unpredictable behaviours.  
For an in depth explanation look at the following link under subsection
"Guidelines for Configuring Multi-NIC Systems":  
<https://www.ni.com/en/support/documentation/supplemental/11/best-practices-for-using-multiple-network-interfaces--nics--with.html>

Two additional parameters should be set on the camera for reduced packet loss:  

1) DeviceLinkThroughputLimit:  
   after setting the camera frame rate, image size, stream settings (for 
   multi-stream cameras), the device link throughput limit should be set
   to match the current throughput (DeviceLinkCurrentThroughput).

2) GevSCPSPacketSize:  
   the GEV stream channel packet size should be set to the maximum packet size
   supported by the interface it is connected to. Refer to beginning of 
   section 4 on how to enable jumbo packet on the interface.

The example StereoAcquisition demonstrates how to set these parameters.

===============================================================================
## 5. GENICAM GENTL PRODUCER SETUP
===============================================================================

In order to use the Spinnaker GenTL producer with applications that support consuming
the Spinnaker GenTL producer, the location of Spinnaker_GenTL.cti must be added to the
"GENICAM_GENTL32_PATH" or "GENICAM_GENTL64_PATH" environment variables for 32-bit
and 64-bit producers.

The Spinnaker installer asks to automatically set these environment variables,
but you can also run the configuration script at any time:

The appropriate environment variable can be updated by running:
- for 32-bit installed library versions:

      $ sudo sh configure_gentl_paths.sh 32

- for 64-bit installed library versions:

      $ sudo sh configure_gentl_paths.sh 64

-------------------------------------------------------------------------------
### 5.1. GENTL LOGGING
-------------------------------------------------------------------------------

To enable Spinnaker GenTL logging, copy the logging configuration file "log4cpp.gentl.property"
from /opt/spinnaker/lib/spinnaker-gentl to the location that the consumer application
executes from.  
The logging configuration file can be modified for specific levels of logging.

===============================================================================
## 6. SPINNAKER REMOVAL
===============================================================================

To remove Spinnaker, run the uninstall script that is provided.  
The removal script will also remove the udev rules therefore restoring the original ubuntu
permissions on the device nodes.

code e.g.:

    $ sudo sh remove_spinnaker_arm.sh

===============================================================================
## 7. RUNNING PREBUILT UTILITIES
===============================================================================

In addition to prebuilt examples (eg: Acquisition, ChunkData, etc),
along with the source code for these examples, Spinnaker SDK ships with a
a number of prebuilt tools for evaluating cameras (i.e. SpinView), upgrading
firmware (i.e. SpinUpdateConsole), and so on.

To make using these tools more convenient, Spinnaker SDK ships with a few
command-line scripts used to automatically set the appropriate environment
variables so these tools can be run from any PWD via the command-line, or when
launching the tools via a custom icon/shortcut.

The Spinnaker installer asks to automatically set these environment variables,
but you can also run the configuration script at any time:

The appropriate environment variable can be updated by running:

    $ sudo sh configure_spinnaker_paths.sh

After environment variables are setup, you can then run the tools by simply
invoking their "launcher" command via the command line, and it is not
required to change the PWD to "/opt/spinnaker/bin" or modify environment variables
in order to launch them.  
Note that to run an example from a non-login shell (e.g. by using sudo),
you will need to pass the user environment variables.
This can be done with the "-E" parameter, e.g.

    $ sudo -E /opt/spinnaker/bin/Enumeration

-------------------------------------------------------------------------------
### 7.1. SpinView QT
-------------------------------------------------------------------------------

SpinView_QT: A graphical application for testing cameras and viewing live
             streaming of image data from all supported Teledyne cameras.

Location:   /opt/spinnaker/bin/SpinView_QT

Short Name: SpinView

Launcher:   spinview

-------------------------------------------------------------------------------
### 7.2. SpinUpdateConsole
-------------------------------------------------------------------------------

SpinUpdateConsole: A console application for updating the firmware on Teledyne cameras.

Location: /opt/spinnaker/bin/SpinUpdateConsole

Short Name: SpinUpdateConsole

Launcher: SpinUpdateConsole

===============================================================================
## 8. TELEDYNE-MV SPINNAKER EXAMPLES
===============================================================================

Please visit our Github repository for examples you can refer to at:  
<https://github.com/Teledyne-MV/Spinnaker-Examples>

===============================================================================
## 9. FREQUENTLY ASKED QUESTIONS
===============================================================================

-------------------------------------------------------------------------------
### 9.1. FLICKERING OF THE DISPLAY
-------------------------------------------------------------------------------

On some ARM boards the GUI Viewer utility SpinView_QT flickers.  
The flickering occurs due to the graphics driver, and can be resolved by using a different graphics driver.  
For example, on the Jetson Orin / XAVIER boards, installing the package xserver-xephyr and executing SpinView_QT via the Xep7hyr xserver resolves the flickering.  

    $ Xep7hyr -br -ac -noreset -screen 1920x1080 :1& DISPLAY=:1 SpinView_QT
