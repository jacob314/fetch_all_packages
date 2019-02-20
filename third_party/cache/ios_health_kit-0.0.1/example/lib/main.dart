import 'package:flutter/material.dart';
import 'package:ios_health_kit/ios_health_kit.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final HKHealthStore store = HKHealthStore();

  _requestAuthorization() {
    Set<String> allDataTypes = new Set.from([
      'biologicalSex',
      'bloodType',
      'dateOfBirth',
      'sleepAnalysis',
      'bloodPressure',
      'food',
      'activeEnergyBurned',
      'basalEnergyBurned',
      'bloodAlcoholContent',
      'bloodGlucose',
      'bloodPressureDiastolic',
      'bloodPressureSystolic',
      'bodyFatPercentage',
      'bodyMass',
      'bodyMassIndex',
      'bodyTemperature',
      'dietaryBiotin',
      'dietaryCaffeine',
      'dietaryCalcium',
      'dietaryCarbohydrates',
      'dietaryChloride',
      'dietaryCholesterol',
      'dietaryChromium',
      'dietaryCopper',
      'dietaryEnergyConsumed',
      'dietaryFatMonounsaturated',
      'dietaryFatPolyunsaturated',
      'dietaryFatSaturated',
      'dietaryFatTotal',
      'dietaryFiber',
      'dietaryFolate',
      'dietaryIodine',
      'dietaryIron',
      'dietaryMagnesium',
      'dietaryManganese',
      'dietaryMolybdenum',
      'dietaryNiacin',
      'dietaryPantothenicAcid',
      'dietaryPhosphorus',
      'dietaryPotassium',
      'dietaryProtein',
      'dietaryRiboflavin',
      'dietarySelenium',
      'dietarySodium',
      'dietarySugar',
      'dietaryThiamin',
      'dietaryVitaminA',
      'dietaryVitaminB12',
      'dietaryVitaminB6',
      'dietaryVitaminC',
      'dietaryVitaminD',
      'dietaryVitaminE',
      'dietaryVitaminK',
      'dietaryZinc',
      'distanceCycling',
      'distanceWalkingRunning',
      'electrodermalActivity',
      'flightsClimbed',
      'forcedExpiratoryVolume1',
      'forcedVitalCapacity',
      'heartRate',
      'height',
      'inhalerUsage',
      'leanBodyMass',
      'nikeFuel',
      'numberOfTimesFallen',
      'oxygenSaturation',
      'peakExpiratoryFlowRate',
      'peripheralPerfusionIndex',
      'respiratoryRate',
      'stepCount',
      'distanceDownhillSnowSports',
      'fitzpatrickSkinType',
      'appleStandHour',
      'cervicalMucusQuality',
      'intermenstrualBleeding',
      'menstrualFlow',
      'ovulationTestResult',
      'sexualActivity',
      'basalBodyTemperature',
      'dietaryWater',
      'uvExposure',
      'appleExerciseTime',
      'wheelchairUse',
      'mindfulSession',
      'distanceSwimming',
      'distanceWheelchair',
      'swimmingStrokeCount',
      'pushCount',
      'heartRateVariabilitySDNN',
      'insulinDelivery',
      'restingHeartRate',
      'vo2Max',
      'waistCircumference',
      'walkingHeartRateAverage',
      'distanceDownhillSnowSports',
    ]);
    store.requestAuthorization(
      allDataTypes.difference(new Set.from([
        'biologicalSex',
        'bloodType',
        'dateOfBirth',
        'bloodPressure',
        'food',
        'nikeFuel',
        'fitzpatrickSkinType',
        'appleStandHour',
        'appleExerciseTime',
        'wheelchairUse',
        'walkingHeartRateAverage',
      ])),
      allDataTypes.difference(new Set.from([
        'bloodPressure',
        'food',
      ]))
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(onPressed: _requestAuthorization, child: new Text('requestAuthorization'))
            ],
          ),
        ),
      ),
    );
  }
}
