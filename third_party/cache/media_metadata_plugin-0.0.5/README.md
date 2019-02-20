# media_metadata_plugin

A Flutter package that allows the user to get some of an audio files meta data.  

It also allows the user te extract the colors from an Image.  This package uses the java library com.github.mkaflowski:Media-Style-Palette:1.1 so check out https://github.com/mkaflowski/Media-Style-Palette. 

Android Support Only

## Getting Started

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />


## Methods

mediaMetaData = MediaMetadataPlugin.getMediaMetaData("PATH TO AUDIOFILE");
colors = MediaMetadataPlugin.getMediaMetaData("PATH TO IMAGE");


