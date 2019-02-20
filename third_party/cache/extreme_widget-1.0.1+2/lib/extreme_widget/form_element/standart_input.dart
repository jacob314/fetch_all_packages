import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/action_manager.dart';
import 'package:extreme_widget/extreme_widget/helper/input.dart';

class ExInput extends StatefulWidget {
  final String id;
  final String labelText;
  final IconData iconName;
  final String hintText;
  final String value;
  final bool enabled;
  final TextInputType keyboardType;
  final String onLostFocusId;
  final String onFocusId;
  final String onChangeTextId;

  final bool useOutlineBorder;
  final bool autoSelectText;
  final bool usePasswordMask;

  ExInput({
    Key key,
    @required this.id,
    @required this.labelText,
    this.iconName,
    this.hintText: "",
    this.value: "",
    this.enabled = true,
    this.keyboardType: TextInputType.text,
    this.onFocusId,
    this.onLostFocusId,
    this.onChangeTextId,
    this.useOutlineBorder = false,
    this.autoSelectText = false,
    this.usePasswordMask = false,
  }) : super(key: key);

  @override
  StandartInputWidget createState() => StandartInputWidget();
}

class StandartInputWidget extends State<ExInput> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool enableSuffixIcon;
  bool focused = false;

  @override
  void initState() {
    super.initState();
    Input.setValue(widget.id, widget.value);
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    // print("StandartInput built.. ${widget.id} => ${DateTime.now()}");

    getText() {
      return controller.text;
    }

    updateGlobalGetter() {
      Input.setValue(widget.id, getText());
    }

    onTextChanged() {
      updateGlobalGetter();
      ActionManager.callAction(widget.onChangeTextId);
    }

    onFocus() {
      this.setState(() {
        enableSuffixIcon = true;
        focused = true;
      });
      if (widget.onFocusId != null) ActionManager.callAction(widget.onFocusId);
    }

    onLostFocus() {
      this.setState(() {
        enableSuffixIcon = false;
        focused = false;
      });
      if (widget.onLostFocusId != null)
        ActionManager.callAction(widget.onLostFocusId);
    }

    onSuffixClick() {
      controller.text = "";
      Input.setValue(widget.id, "");
    }

    Widget suffixIconWidget = IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.red,
      ),
      onPressed: () {
        onSuffixClick();
      },
    );

    TextField instance = TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.usePasswordMask,
      enabled: widget.enabled,
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon: widget.iconName != null ? Icon(widget.iconName) : null,
        labelText: widget.labelText,
        suffixIcon: enableSuffixIcon == true ? suffixIconWidget : null,
        border: widget.useOutlineBorder == true
            ? OutlineInputBorder(borderSide: BorderSide())
            : null,
      ),
      onChanged: (text) {
        Input.setValue(widget.id, text);
        onTextChanged();
      },
    );

    focusNode.addListener(() {
      focusNode.hasFocus ? onFocus() : onLostFocus();
    });

    controller.text = Input.getValue(widget.id);

    if (focused) {
      if (widget.autoSelectText == true) {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      } else {
        controller.selection = TextSelection(
            baseOffset: controller.text.length,
            extentOffset: controller.text.length);
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: instance,
    );
  }
}
