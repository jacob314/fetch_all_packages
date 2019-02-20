[![Pub](https://img.shields.io/pub/v/usb_serial.svg)](https://pub.dartlang.org/packages/usb_serial)

# usb_serial

An Android USB Serial Flutter Plugin

This plugin allows Flutter code to interact with USB serial devices connected to your Android device. For example an FTDI or CDC based USB device.

## Getting Started

Add a dependency to your pubspec.yaml

```dart
dependencies:
	usb_serial: ^0.1.1
```

include the usbserial package at the top of your dart file.

```dart
import 'package:usb_serial/usb_serial.dart'
```

### IMPORTANT app\build.gradle

Edit android\app\build.gradle and add 

```
    compileOptions {
        sourceCompatibility 1.8
        targetCompatibility 1.8
    }
```

to the 'android' object, see [build.grade](https://raw.githubusercontent.com/altera2015/usbserial/master/example/android/app/build.gradle) 
from the example project for a template on how to do this. Without this you'll get a bunch or Java 
errors.

### Optional

Add 
```xml
	<intent-filter>
		<action android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED" />
	</intent-filter>

	<meta-data android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED"
		android:resource="@xml/device_filter" />
```
to your AndroidManifest.xml

and place device_filter.xml 

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 0x0403 / 0x6001: FTDI FT232R UART -->
    <usb-device vendor-id="1027" product-id="24577" />
    
    <!-- 0x0403 / 0x6015: FTDI FT231X -->
    <usb-device vendor-id="1027" product-id="24597" />

    <!-- 0x2341 / Arduino -->
    <usb-device vendor-id="9025" />

    <!-- 0x16C0 / 0x0483: Teensyduino  -->
    <usb-device vendor-id="5824" product-id="1155" />

    <!-- 0x10C4 / 0xEA60: CP210x UART Bridge -->
    <usb-device vendor-id="4292" product-id="60000" />
    
    <!-- 0x067B / 0x2303: Prolific PL2303 -->
    <usb-device vendor-id="1659" product-id="8963" />
    
    <!-- 0x1366 / 0x0105: Segger JLink -->
    <usb-device vendor-id="4966" product-id="261" />
    
</resources>
```

in the res/xml directory. This will notify your app when one of the specified devices
is plugged in.

## Usage

```dart
...
onPressed: () async {
	List<UsbDevice> devices = await UsbSerial.listDevices();
	print(devices);

	UsbPort port;
	if (devices.length == 0) {
		return;
	}
	port = await devices[0].create();

	bool openResult = await _port.open();
	if ( !openResult ) {
		print("Failed to open");
		return;
	}
	
	await port.setDTR(true);
	await port.setRTS(true);

	port.setPortParameters(115200, UsbPort.DATABITS_8,
	  UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

	// print first result and close port.
	port.inputStream.listen((Uint8List event) {
		print(event);
		port.close();
	});

	await port.write(Uint8List.fromList([0x10, 0x00]));
}
...
```

## Dependencies

This library depends on:

https://github.com/felHR85/UsbSerial