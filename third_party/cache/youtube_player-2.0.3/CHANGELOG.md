## [2.0.3] - February 4, 2019.

* controlsBackground property now sets background overlay for play and pause. 
* [Fixed] Crashing on defining width.

## [2.0.2] - February 3, 2019.

* **Breaking change**. [context] property is required now.
* Redesigned controls to match original YouTube experience.
* Fast forward and Rewind feature added, on double tap.
* Can now adjust video quality through player.
* Can now share videos with other apps.
* Size of player can be adjusted.
* [FIXED] Stretching portrait videos.


## [1.0.0] - February 1, 2019.

* **Breaking change**. Migrate from the deprecated original Android Support Library to AndroidX. This shouldn't result in any functional changes, but it requires any Android apps using this plugin to [also migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.
* AutoPlay property added.

## [0.8.1] - January 29, 2019.

* Minor bug fixes.

## [0.8.0] - January 29, 2019.

* (Fixed) Defining controller is optional now.
* (Fixed) Video not disposing issue. Thanks to [@Y-ndm] for raising the [issue](https://github.com/sarbagyastha/youtube_player/issues/7).

## [0.7.2] & [0.7.1] - January 26, 2019.

* Minor Fixes.

## [0.7.0] - January 26, 2019.

* Video loads and plays lot more faster than in previous versions.
* Availability of controller outside the player, for in-depth customizations and events access [See Example](https://github.com/sarbagyastha/youtube_player/blob/master/example/lib/main.dart)
* (FIXED) Aspect ratio and orientation problem in videos.
* (UNDER THE HOOD) Optimized Youtube Stream Link generation.
* (UNDER THE HOOD) Reduced dependencies. Significant reduction in code reference.
* Added controls customization.

## [0.6.1] - January 11, 2019.

* (FIXED) Video continuing to play on background. Thanks to [@ParthAggarwal1996] for raising the [issue](https://github.com/sarbagyastha/youtube_player/issues/3).
* Dependency Update

## [0.6.0] - January 5, 2019.

* Videos play faster now.
* Shows video thumbnail on loading.
* Changed dependency to 'http' in place of 'dio' in order to reduce amount of code reference.
* Automatic Fallback to lower quality if higher qualities are not available.
* (FIXED) 'Default Interface Methods are only supported...' error. 
* (FIXED) Control bar not showing on single tap(after loading).
* (FIXED) Depreciated Warnings
* Support for Live Stream Video Playback Added (but not playing yet, will be fixed in next update on finding workaround).

## [0.5.0] - January 5, 2019.

* Minor Changes.

## [0.4.0] - January 4, 2019.

* Fixed some bugs with controls and orientation change.

## [0.3.0] - January 4, 2019.

* ReadMe File Updated. Fixed some bugs.

## [0.2.0] - January 3, 2019.

* Updated Controls.

## [0.1.0] - January 2, 2019.

* Initial Release.
