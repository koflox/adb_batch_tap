**Description**

The main script purpose is the batch tap on multiple Android devices via ADB. The general idea is taking photos simultaneously. Tap events are sent asynchronously. Devices wake up synchronously if such option is specified.

Can be run as bash batch_tap.sh with the next arguments:

`a` - a - awake option, `0` or `1`, if `1` - turn on and unlock device if necessary, otherwise sent events to devices with such check

`p` - list of passwords, values are used when awake option is specified

`v` - is single password argument, `0` or `1`, if `1` - the same password will be used for all devices, otherwise passwords are used sequentially for each device

`c` - list of relative coordinates for tap in range between 0 and 100, e.g `“50 50“` means screen center for the first device

`u` - is single coordinate argument, `0` or `1`, if `1` - first pair of coordinates will be used for all devices, otherwise pair of coordinates are used sequentially for each device


**Sample usage**

 - `bash batch_tap.sh -a 1 -p 0000 -v 1 -c "50 50 10 10 80 80"`  - awakes devices using password 0000 for all devices and sends tap events for three devices on different screen position

 - `bash batch_tap.sh -c "50 50" -u 1` - sends tap events to all devices on their screen centers

**Sample output**

Output contains device name, tap position in pixels, device screen size

```
Pixel 2 XL tap on (700, 1400), screen size is 1440x2880
MI 8 tap on (500, 1100), screen size is 1080x2248
T780H tap on (500, 1150), screen size is 1080x2340
```

**Suggestions**

 - Enable TCP/IP debug mode
 - Enable USB Debugging for Security settings on devices which have such developer option (e.g. Xiaomi MI8, Android 10). Otherwise tap events won’t be executed.


**In progress**

 - Script running from another Android device via [Termux Terminal](https://github.com/MasterDevX/Termux-ADB) or own client side app
