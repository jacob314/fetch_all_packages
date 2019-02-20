library easy_camera;

import 'dart:async';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
CameraController lastCamera;
Map<CameraDescription, CameraController> controllers = new Map<CameraDescription, CameraController>();
/* TODO: We need to dispose these controllers when the app is closed (or paused?) */

Future<CameraController> getCamera(CameraLensDirection camera) async {
  if (cameras == null)
    cameras = await availableCameras();

  CameraDescription chosenCamera;

  try {
    chosenCamera = cameras.firstWhere((current) => current.lensDirection == camera);
  }
  on StateError catch (e) {
    throw '${camera.toString()} camera not found on phone.';
  }

  if (controllers[chosenCamera] == null) {
    var controller = new CameraController(chosenCamera, ResolutionPreset.high);
      
    controllers[chosenCamera] = controller;
  }

  if (controllers[chosenCamera] != lastCamera)
    await controllers[chosenCamera].initialize();

  lastCamera = controllers[chosenCamera];

  return lastCamera;
}
