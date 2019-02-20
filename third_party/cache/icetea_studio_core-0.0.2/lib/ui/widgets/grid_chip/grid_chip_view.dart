import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/widgets/chip/custom_chip.dart';

///
/// This widget display multiple chip item, display as grid view with 2 columns
///

class GridChipView extends StatefulWidget {

  final List<ChipEntity> dataSet;
  final bool isAllowRemove;
  final ValueChanged<ChipEntity> onItemRemove;

  GridChipView({@required this.dataSet, @required this.isAllowRemove, this.onItemRemove})
      :assert(dataSet != null),
        assert(isAllowRemove);

  @override
  State createState() => _GridChipViewState();
}

class _GridChipViewState extends State<GridChipView> {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        child: new GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            shrinkWrap: true,
            primary: false,
            childAspectRatio: 4.0,
            children: List.generate(widget.dataSet.length, (index) {
              return new CustomChip(
                data: widget.dataSet[index],
                isAllowRemove: widget.isAllowRemove,
                onItemRemoved: (ChipEntity item) {
                  widget.onItemRemove(item);
                },);
            })
        ),
      ),
    );
  }
}
