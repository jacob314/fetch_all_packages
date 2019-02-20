import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/loading/extreme_loading.dart';

class FutureHandler {
  Widget handle(AsyncSnapshot snapshot) {
    try {
      if (!snapshot.hasData) return ExLoading.tetrisLoading();
      if (snapshot.hasError) return Center(child: Text("Connection Error"));

      return Text("Undetected Error");
    } catch (e) {
      return Text("Exception Error");
    }
  }
}