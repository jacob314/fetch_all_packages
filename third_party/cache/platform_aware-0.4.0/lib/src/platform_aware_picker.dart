import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_aware/src/platform_aware_flat_button.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwarePicker<T> extends PlatformAwareWidget {
  final Widget Function(BuildContext context, T item) itemWidgetBuilder;
  final Iterable<T> items;
  final int initialItemIndex;
  final FixedExtentScrollController scrollController;
  final ValueChanged<T> onChanged;

  PlatformAwarePicker(
      {@required this.initialItemIndex,
      @required this.itemWidgetBuilder,
      @required this.items,
      @required this.onChanged})
      : scrollController =
            new FixedExtentScrollController(initialItem: initialItemIndex);

  WidgetBuilder _buildBottomPicker(
      {@required ValueChanged<T> selectionChanged}) {
    return (BuildContext context) => new Container(
          height: 216.0,
          color: CupertinoColors.white,
          child: new DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.black,
              fontSize: 22.0,
            ),
            child: new GestureDetector(
              // Blocks taps from propagating to the modal sheet and popping.
              onTap: () {},
              child: new SafeArea(
                child: new CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: 32.0,
                    backgroundColor: CupertinoColors.white,
                    onSelectedItemChanged: (int index) =>
                        selectionChanged(items.elementAt(index)),
                    children: items
                        .map((T item) => itemWidgetBuilder(context, item))
                        .toList()),
              ),
            ),
          ),
        );
  }

  @override
  Widget buildCupertino(BuildContext context) => new PlatformAwareFlatButton(
      child: itemWidgetBuilder(context, items.elementAt(initialItemIndex)),
      onPressed: () async {
        T lastSelection = items.elementAt(initialItemIndex);
        ValueChanged<T> selectionChanged =
            (T newSelection) => lastSelection = newSelection;

        await showModalBottomSheet(
            context: context,
            builder: _buildBottomPicker(selectionChanged: selectionChanged));

        onChanged(lastSelection);
      });

  @override
  Widget buildAndroid(BuildContext context) => new Row(
        children: <Widget>[
          new Expanded(
              child: new Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: new DropdownButton<T>(
                isDense: true,
                value: items.elementAt(initialItemIndex),
                items: items
                    .map((T item) => new DropdownMenuItem<T>(
                          child: itemWidgetBuilder(context, item),
                          value: item,
                        ))
                    .toList(growable: false),
                onChanged: onChanged),
            alignment: Alignment.center,
          ))
        ],
      );
}
