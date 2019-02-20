import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transformer/src/intro_page_item.dart';
import 'package:page_transformer/src/page_transformer.dart';


class SliderView extends StatelessWidget {

  SliderView({
    @required this.slideItems,
    this.viewportFraction = 0.85,
    this.height = 500.0,
  });

  final double viewportFraction;
  final double height;
  final List<SlideItem> slideItems ;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SizedBox.fromSize(
          size: new Size.fromHeight(height),
          child: new PageTransformer(
            pageViewBuilder: (context, visibilityResolver) {
              return new PageView.builder(
                controller: new PageController(viewportFraction: viewportFraction),
                itemCount: slideItems.length,
                itemBuilder: (context, index) {
                  final item = slideItems[index];
                  final pageVisibility =
                      visibilityResolver.resolvePageVisibility(index);

                  return new SlidePageItem(
                    item: item,
                    pageVisibility: pageVisibility,
                    handleOnTap: ()=>print("on tap working"),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}
