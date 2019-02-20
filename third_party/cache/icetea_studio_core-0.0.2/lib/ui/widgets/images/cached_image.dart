import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/assets/assets.dart';

enum FallBackImage {USER, PLACE, EVENT}

class CachedImage extends StatefulWidget {
  final String imageUrl;
  final FallBackImage fallBackImage;
  final BoxFit fit;
  final double width;
  final double height;
  final double borderRadius;

  CachedImage(this.imageUrl, {
    Key key,
    this.fallBackImage = FallBackImage.USER,
    this.fit = BoxFit.cover,
    this.width = 100.0,
    this.height = 100.0,
    this.borderRadius = null
  })
      : super(key: key);

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  bool _imageLoadError = false;
  ImageProvider _image;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null && widget.imageUrl.isNotEmpty) {
      _image =  new CachedNetworkImageProvider(
          widget.imageUrl,
          errorListener: _onImageError
      );
    }else {
      _image = _fallbackImage;
    }
  }


  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != null && widget.imageUrl.isNotEmpty && widget.imageUrl != oldWidget.imageUrl) {
      _image =  new CachedNetworkImageProvider(
          widget.imageUrl,
          errorListener: _onImageError
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image = _image;

    if (_imageLoadError) {
      image = _fallbackImage;
    }

    return new Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius != null ? BorderRadius.all(Radius.circular(widget.borderRadius)) : null,
        image: new DecorationImage(
          image: image,
          fit: widget.fit
        )
      ),
    );
  }

  ImageProvider get _fallbackImage => widget.fallBackImage == FallBackImage.USER
        ? AssetImage(Assets.cspIcAvatarDefault)
        : widget.fallBackImage == FallBackImage.PLACE
        ? AssetImage(Assets.cspIcPlaceBanner)
        : AssetImage(Assets.cspIcEventBanner);

  void _onImageError() {
    setState(() {
      _imageLoadError = true;
    });
  }
}