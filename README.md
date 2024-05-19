This repository is for compiling firmware (openwrt) for a specific IPQ60xx device: JDC-AX1800-Pro by JD Cloud. 
It is forked from jiay-shi's repo, merged with some patches and regulations from https://github.com/aiamadeus/openwrt.git:ipq-gl as well as https://github.com/openwrt/openwrt.git:main as upstream.

Currently, the ipq60xx-devel branch is working.
Both Ethernet and WIFI (ath11k) are **working** fine, but **w/out nss**.
The small (no LUCI) build is a minimal-sized build, suitable for recovery use.
The "full" build comes with LUCI, dnsmasq-full, ip-full, wpad(full), openssl, strongswan, some netfilter, and USB kmods.

========================================================================
RootFS space problem:

**It is suggested to use a mounted fs as *overlay* for opkg packages.** This can be done by using p27 (storage) or replacing it with 2 partitions and using the latter one (p28) as overlay.
Some fdisk command seqence for reference (please note: factory fdisk will not output uuids, use openwrt fdisk (opkg install fdisk)):
```
fdisk /dev/mmcblk0
x
p
>backup/save the output to some text file is recommended.
>you'll find something like this at the end of the output: /dev/mmcblk0p27 2187298 240615390 238428093 [type] [uuid] [name]
r
d
[press enter, 27]
n
[press enter, 27]
[press enter, 2187298 or a number a little bigger than this such as the defaulted 2189312]
+100G 
>or +50G for 64GB device
n
[press enter, 28]
[press enter]
[press enter]
t
27
>enter or paste [type] string here
x
u
27
>enter or paste [uuid] string here
n
27
>enter or paste [name] string (shall be storage) here
r
w
>fdisk shall exit here, so we should be back to system shell prompt
mkfs.ext4 /dev/mmcblk0p27
>wait until done, expect 30~100 sec
mkfs.ext4 /dev/mmcblk0p28
>wait until done
```
Then you can use the *mount points* menu in the luci interface to mount p28 as overlay. You may have to refresh (Generate Config) first and reboot for the configuration to take effect.

However,  if you do want to replace the partition table (for a larger rootfs partition).
*02_mmcblk0_GPT_128g_2Grootfs_28parts.bin* is a GPT partition table (34 sectors at the beginning of the mmcblk0 device) for a 128G device. It has a 2GB rootfs partition instead of the original 60MB.

**Please DO BACKUP all your emmc partition content except p26+ before flashing/modifying your partition table, and flash (dd) the backed-up content back into modified partitions before reboot!**

**You should have uboot replaced (such as with *00_jdc-ax1800pro-u-boot.mbn*).** But as you are reading this and flashing openwrt, I'll consider it has been done.
p1-p17 should be the same as the factory settings. p18 is the rootfs for the os (openwrt). This can be flashed with the uboot. **remember to have p18 *named* rootfs if modified!** p19 is the factory backof of rootfs, p22 is the rootfs_data partition. Therefore, at least the contents of p19, p21, and p23 shall be restored (by dd). You can do that by using a USB drive or using /tmp (ram).

========================================================================
Pre-compiled files:

All released pre-compiled files contain **No bullshit**, no 3rd party (besides sources from openwrt/openwrt and necessary hardware drivers) packages.
*No customized style*, no nothing *customized* comparing to openwrt snapshots packages, including bugs.

Please find them [here in the releases](https://github.com/sunshinejnjn/openwrt-jiayshi/releases/).

--
An opkg source for an almost full list of kmods can be found [here](http://openwrt.717455.xyz/jdc_ax1800-pro_no-nss/targets/qualcommax/ipq60xx/packages/).

The mentioned *uboot* and the *partition table* file can be found in [the very first release](https://github.com/sunshinejnjn/openwrt-jiayshi/releases/tag/20240518_jdc_ax1800-pro) of this repo. 

========================================================================

![OpenWrt logo](include/logo.png)

OpenWrt Project is a Linux operating system targeting embedded devices. Instead
of trying to create a single, static firmware, OpenWrt provides a fully
writable filesystem with package management. This frees you from the
application selection and configuration provided by the vendor and allows you
to customize the device through the use of packages to suit any application.
For developers, OpenWrt is the framework to build an application without having
to build a complete firmware around it; for users this means the ability for
full customization, to use the device in ways never envisioned.

Sunshine!

## Download

Built firmware images are available for many architectures and come with a
package selection to be used as WiFi home router. To quickly find a factory
image usable to migrate from a vendor stock firmware to OpenWrt, try the
*Firmware Selector*.

* [OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/)

If your device is supported, please follow the **Info** link to see install
instructions or consult the support resources listed below.

## 

An advanced user may require additional or specific package. (Toolchain, SDK, ...) For everything else than simple firmware download, try the wiki download page:

* [OpenWrt Wiki Download](https://openwrt.org/downloads)

## Development

To build your own firmware you need a GNU/Linux, BSD or macOS system (case
sensitive filesystem required). Cygwin is unsupported because of the lack of a
case sensitive file system.

### Requirements

You need the following tools to compile OpenWrt, the package names vary between
distributions. A complete list with distribution specific packages is found in
the [Build System Setup](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)
documentation.

```
binutils bzip2 diff find flex gawk gcc-6+ getopt grep install libc-dev libz-dev
make4.1+ perl python3.7+ rsync subversion unzip which
```

### Quickstart

1. Run `./scripts/feeds update -a` to obtain all the latest package definitions
   defined in feeds.conf / feeds.conf.default

2. Run `./scripts/feeds install -a` to install symlinks for all obtained
   packages into package/feeds/

3. Run `make menuconfig` to select your preferred configuration for the
   toolchain, target system & firmware packages.

4. Run `make` to build your firmware. This will download all sources, build the
   cross-compile toolchain and then cross-compile the GNU/Linux kernel & all chosen
   applications for your target system.

### Related Repositories

The main repository uses multiple sub-repositories to manage packages of
different categories. All packages are installed via the OpenWrt package
manager called `opkg`. If you're looking to develop the web interface or port
packages to OpenWrt, please find the fitting repository below.

* [LuCI Web Interface](https://github.com/openwrt/luci): Modern and modular
  interface to control the device via a web browser.

* [OpenWrt Packages](https://github.com/openwrt/packages): Community repository
  of ported packages.

* [OpenWrt Routing](https://github.com/openwrt/routing): Packages specifically
  focused on (mesh) routing.

* [OpenWrt Video](https://github.com/openwrt/video): Packages specifically
  focused on display servers and clients (Xorg and Wayland).

## Support Information

For a list of supported devices see the [OpenWrt Hardware Database](https://openwrt.org/supported_devices)

### Documentation

* [Quick Start Guide](https://openwrt.org/docs/guide-quick-start/start)
* [User Guide](https://openwrt.org/docs/guide-user/start)
* [Developer Documentation](https://openwrt.org/docs/guide-developer/start)
* [Technical Reference](https://openwrt.org/docs/techref/start)

### Support Community

* [Forum](https://forum.openwrt.org): For usage, projects, discussions and hardware advise.
* [Support Chat](https://webchat.oftc.net/#openwrt): Channel `#openwrt` on **oftc.net**.

### Developer Community

* [Bug Reports](https://bugs.openwrt.org): Report bugs in OpenWrt
* [Dev Mailing List](https://lists.openwrt.org/mailman/listinfo/openwrt-devel): Send patches
* [Dev Chat](https://webchat.oftc.net/#openwrt-devel): Channel `#openwrt-devel` on **oftc.net**.

## License

OpenWrt is licensed under GPL-2.0
