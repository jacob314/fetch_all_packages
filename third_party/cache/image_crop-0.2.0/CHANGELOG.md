## 0.2.0

* Fit sampled images to specified maximum width/height on both iOS and Android
* Preserve exif information on Android when crop/sample image
* Updated example to illustrate higher quality cropped image production

## 0.1.3

* New widget options: Maximum scale, always show grid
* Adjusted scale to reflect original image size. If image scaled and fits in cropped area, scale is 1x
* Calculate sample size against large side of image to match smaller to preferred width/height
* Bug: ensure to display image on first frame
* Optimization: do not resample if image is smaller than preferred width/height

## 0.1.2

* Limit image to a crop area instead of view boundaries
* Don't adjust a size during scale to avoid misalignment
* After editing snap image back to a crop area. Auto scale if needed

## 0.1.1

* Fixed an exception when aspect ratio is not supplied
* Updated README with more information and screenshots

## 0.1.0

* Tools to resample by a factor, crop, and get options of images
* Display image provider
* Scale and crop image via widget
* Optional aspect ratio of crop area
