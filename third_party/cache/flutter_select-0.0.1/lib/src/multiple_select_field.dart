import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class ItemsSelectingValue {
  List<Map<String, dynamic>> selected;

  ItemsSelectingValue({selected}) {
    this.selected = selected != null &&
      (selected is List<Map<String, dynamic>> && selected.isNotEmpty)
      ? List<Map<String, dynamic>>.from(selected)
      : List<Map<String, dynamic>>();
  }

  static ItemsSelectingValue get empty => ItemsSelectingValue();

  ItemsSelectingValue copyWith({List<Map<String, dynamic>> selected}) {
    return ItemsSelectingValue(
      selected: selected != null &&
        (selected is List<Map<String, dynamic>> && selected.isNotEmpty)
        ? List<Map<String, dynamic>>.from(selected)
      : List<Map<String, dynamic>>.from(this.selected),
    );
    }

  @override
  String toString() => '$runtimeType(selected: $hashCode)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! ItemsSelectingValue)
      return false;
    final ItemsSelectingValue typedOther = other;
    return DeepCollectionEquality().equals(typedOther.selected, selected);
  }

  @override
  int get hashCode => selected.hashCode;
}

class ItemsSelectingController extends ValueNotifier<ItemsSelectingValue> {
  ItemsSelectingController({List<Map<String, dynamic>> selected}) : super(
    selected == null ?
    ItemsSelectingValue.empty :
    ItemsSelectingValue(selected: selected)
  );

  ItemsSelectingController.fromValue(ItemsSelectingValue value)
    : super(value ?? ItemsSelectingValue.empty);

  List<Map<String, dynamic>> get selected => value.selected;
  set selected(List<Map<String, dynamic>> newItems) {
    value = value.copyWith(selected: newItems);
  }

  void clear() {
    value = ItemsSelectingValue.empty;
  }
}

class MultipleSelectField extends StatefulWidget {
  final Key fieldKey;
  final List<Map<String, dynamic>> initialValue;
  final String hintText;
  final String labelText;
  final String helperText;
  final String errorText;
  final FormFieldSetter<List<Map<String, dynamic>>> onChanged;
  final ValueChanged<List<Map<String, dynamic>>> onSubmitted;
  final ItemsSelectingController controller;
  final bool enabled;
  final List<Map<String, dynamic>> options;

  const MultipleSelectField({
    this.fieldKey,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.enabled = true,
    this.options,
  });

  @override
  _MultipleOptionSelectFieldState createState() =>
    _MultipleOptionSelectFieldState();
}

abstract class _MultipleSelectFieldState extends State<MultipleSelectField> {
  Widget subtitle;

  void openPicker();

  Widget getSubtitle() {
    if (widget.controller.selected.isEmpty) {
      return Text(
        widget.hintText ?? 'Please select...',
        style: TextStyle(fontSize: 14.0, color: Colors.grey),
      );
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.controller.selected.map((Map<String, dynamic> item) => (
        Chip(
          label: Text(
            item['label'],
            style: TextStyle(fontSize: 14.0),
          ),
        )
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            minHeight: 80.0,
            minWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            border: widget.errorText == null ? null : Border.all(
              width: 2.0,
              color: Theme.of(context).errorColor,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => (
              GestureDetector(
                onTap: openPicker,
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.labelText,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: constraints.maxWidth * 0.8,
                              margin: EdgeInsets.only(top: 10.0),
                              child: subtitle ?? getSubtitle(),
                            )
                          ],
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    )
                  ),
                ),
              )
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text(
            widget.errorText ?? '',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _MultipleOptionSelectFieldState extends _MultipleSelectFieldState {

  void setSubtitle() {
    setState(() {
      subtitle = getSubtitle();
    });
  }

  @override
  openPicker() {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _MultipleSelectPicker(
          controller: widget.controller,
          subtitle: subtitle,
          setSubtitle: setSubtitle,
          labelText: widget.labelText,
          options: widget.options,
        );
      }
    );
  }
}

class _MultipleSelectPicker extends StatefulWidget {
  final ItemsSelectingController controller;
  final Widget subtitle;
  final Function setSubtitle;
  final String labelText;
  final List<Map<String, dynamic>> options;

  _MultipleSelectPicker({
    @required this.controller,
    @required this.subtitle,
    @required this.setSubtitle,
    @required this.labelText,
    @required this.options,
  });

  @override
  _MultipleSelectPickerState createState() => _MultipleSelectPickerState(
    controller: controller,
    subtitle: subtitle,
    setSubtitle: setSubtitle,
    labelText: labelText,
    options: options,
  );
}

class _MultipleSelectPickerState extends State<_MultipleSelectPicker> {
  final ItemsSelectingController controller;
  final Widget subtitle;
  final Function setSubtitle;
  final String labelText;
  final List<Map<String, dynamic>> options;
  List<Map<String, dynamic>> tmpValue;
  Set<dynamic> tmpValueSet;

  _MultipleSelectPickerState({
    @required this.controller,
    @required this.subtitle,
    @required this.setSubtitle,
    @required this.labelText,
    @required this.options,
  }) {
    tmpValue = List<Map<String, dynamic>>.from(controller.selected);
    tmpValueSet = Set.from(
    controller.selected
      .map((Map<String, dynamic> item) => item['value'])
    );
  }

  void _toggleItemSelection(Map<String, dynamic> item) {
    setState(() {
      if (tmpValueSet.contains(item['value'])) {
        tmpValue.removeWhere((Map<String, dynamic> selectedItem) =>
        selectedItem['value'] == item['value']
        );
        tmpValueSet.remove(item['value']);
      } else {
        tmpValue.add(item);
        tmpValueSet.add(item['value']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  labelText,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: tmpValue.isEmpty ? Colors.grey : Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    if (tmpValue.isEmpty) {
                      return null;
                    }
                    controller.selected = List<Map<String, dynamic>>.from(tmpValue);
                    setSubtitle();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 60.0 - 2 * kToolbarHeight,
            child: ListView(
              children: List.from([
                Container(
                  margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                  child: tmpValue.isEmpty
                    ? Center(
                    child: Text(
                      'No item selected yet',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                    : Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: tmpValue
                      .map((Map<String, dynamic> item) => (
                      Chip(
                        label: Text(
                          item['label'],
                          style: TextStyle(fontSize: 14.0),
                        ),
                        onDeleted: () => _toggleItemSelection(item),
                        deleteIcon: Icon(Icons.highlight_off),
                      )
                    )).toList(growable: false),
                  ),
                )
              ])
                ..addAll(
                  options.map((Map<String, dynamic> option) => (
                    InkWell(
                      onTap: () => _toggleItemSelection(option),
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: tmpValueSet.contains(option['value']),
                              onChanged: (_) => _toggleItemSelection(option),
                            ),
                            Text(
                              option['label'],
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ))
                ),
            ),
          ),
        ],
      )
    );
  }
}

class MultipleSelectFormField extends FormField<List<Map<String, dynamic>>> {
  final ItemsSelectingController controller;

  MultipleSelectFormField({
    Key key,
    this.controller,
    List<Map<String, dynamic>> initialValue,
    String hintText,
    String labelText,
    String helperText,
    List<Map<String, dynamic>> options,
    ValueChanged<List<Map<String, dynamic>>> onFieldSubmitted,
    FormFieldSetter<List<Map<String, dynamic>>> onSaved,
    FormFieldValidator<List<Map<String, dynamic>>> validator,
    bool enabled,
  }) :
      assert(initialValue == null || controller == null),
      super(
      key: key,
      initialValue: getInitialValue(controller, initialValue),
      onSaved: onSaved,
      validator: validator,
      builder: (FormFieldState<List<Map<String, dynamic>>> field) {
        final _MultipleSelectFormFieldState state = field;
        return MultipleSelectField(
          controller: state._effectiveController,
          initialValue: getInitialValue(controller, initialValue),
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          errorText: field.errorText,
          onChanged: field.didChange,
          onSubmitted: onFieldSubmitted,
          enabled: enabled,
          options: options,
        );
      },
    );

  static List<Map<String, dynamic>> getInitialValue(
    ItemsSelectingController controller,
    List<Map<String, dynamic>> initialValue,
    ) {
    return controller != null ?
    controller.selected : (
      initialValue
        ?? List<Map<String, dynamic>>.from(ItemsSelectingValue.empty.selected
    ));
  }

  @override
  _MultipleSelectFormFieldState createState() => _MultipleSelectFormFieldState();
}

class _MultipleSelectFormFieldState
  extends FormFieldState<List<Map<String, dynamic>>> {
  ItemsSelectingController _controller;

  ItemsSelectingController get _effectiveController =>
    widget.controller ?? _controller;

  @override
  MultipleSelectFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = ItemsSelectingController(selected: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(MultipleSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = ItemsSelectingController.fromValue(
          oldWidget.controller.value,
        );
      if (widget.controller != null) {
        setValue(widget.controller.selected);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.selected = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController.selected != value)
      didChange(_effectiveController.selected);
  }
}
