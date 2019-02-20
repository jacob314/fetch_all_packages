import 'package:flutter/material.dart';

TextStyle buildDialogTextStyle(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);
}