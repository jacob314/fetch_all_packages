#import "IosHealthKitPlugin.h"
#import <HealthKit/HealthKit.h>

@interface NSError (FlutterError)
@property(readonly, nonatomic) FlutterError *flutterError;
@end

@implementation NSError (FlutterError)
- (FlutterError *)flutterError {
  return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", self.code]
                             message:self.domain
                             details:self.localizedDescription];
}
@end

@interface IosHealthKitPlugin ()
@property (nonatomic, strong) HKHealthStore* store;
@end

@implementation IosHealthKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"ios_health_kit"
                                   binaryMessenger:[registrar messenger]];
  IosHealthKitPlugin* instance = [[IosHealthKitPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (HKHealthStore*) store {
  if (!_store) {
    _store = [[HKHealthStore alloc] init];
  }
  return _store;
}

+ (NSDictionary*)getDataTypes {
  static NSMutableDictionary* dataTypes = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dataTypes = [[NSMutableDictionary alloc] initWithCapacity:100];
    [dataTypes addEntriesFromDictionary:@{
                                          @"biologicalSex": [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                          @"bloodType": [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBloodType],
                                          @"dateOfBirth": [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                          @"sleepAnalysis": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                                          @"bloodPressure": [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure],
                                          @"food": [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierFood],
                                          @"activeEnergyBurned": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                          @"basalEnergyBurned": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
                                          @"bloodAlcoholContent": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodAlcoholContent],
                                          @"bloodGlucose": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                          @"bloodPressureDiastolic": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],
                                          @"bloodPressureSystolic": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],
                                          @"bodyFatPercentage": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage],
                                          @"bodyMass": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                          @"bodyMassIndex": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                          @"bodyTemperature": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature],
                                          @"dietaryBiotin": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryBiotin],
                                          @"dietaryCaffeine": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine],
                                          @"dietaryCalcium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCalcium],
                                          @"dietaryCarbohydrates": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates],
                                          @"dietaryChloride": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryChloride],
                                          @"dietaryCholesterol": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol],
                                          @"dietaryChromium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryChromium],
                                          @"dietaryCopper": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCopper],
                                          @"dietaryEnergyConsumed": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                          @"dietaryFatMonounsaturated": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatMonounsaturated],
                                          @"dietaryFatPolyunsaturated": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatPolyunsaturated],
                                          @"dietaryFatSaturated": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatSaturated],
                                          @"dietaryFatTotal": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal],
                                          @"dietaryFiber": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFiber],
                                          @"dietaryFolate": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFolate],
                                          @"dietaryIodine": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryIodine],
                                          @"dietaryIron": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryIron],
                                          @"dietaryMagnesium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryMagnesium],
                                          @"dietaryManganese": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryManganese],
                                          @"dietaryMolybdenum": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryMolybdenum],
                                          @"dietaryNiacin": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryNiacin],
                                          @"dietaryPantothenicAcid": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPantothenicAcid],
                                          @"dietaryPhosphorus": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPhosphorus],
                                          @"dietaryPotassium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPotassium],
                                          @"dietaryProtein": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein],
                                          @"dietaryRiboflavin": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryRiboflavin],
                                          @"dietarySelenium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySelenium],
                                          @"dietarySodium": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySodium],
                                          @"dietarySugar": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySugar],
                                          @"dietaryThiamin": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryThiamin],
                                          @"dietaryVitaminA": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminA],
                                          @"dietaryVitaminB12": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminB12],
                                          @"dietaryVitaminB6": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminB6],
                                          @"dietaryVitaminC": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminC],
                                          @"dietaryVitaminD": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminD],
                                          @"dietaryVitaminE": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminE],
                                          @"dietaryVitaminK": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminK],
                                          @"dietaryZinc": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryZinc],
                                          @"distanceCycling": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                          @"distanceWalkingRunning": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                          @"electrodermalActivity": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierElectrodermalActivity],
                                          @"flightsClimbed": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                          @"forcedExpiratoryVolume1": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierForcedExpiratoryVolume1],
                                          @"forcedVitalCapacity": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierForcedVitalCapacity],
                                          @"heartRate": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                          @"height": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                          @"inhalerUsage": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierInhalerUsage],
                                          @"leanBodyMass": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass],
                                          @"nikeFuel": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierNikeFuel],
                                          @"numberOfTimesFallen": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierNumberOfTimesFallen],
                                          @"oxygenSaturation": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation],
                                          @"peakExpiratoryFlowRate": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierPeakExpiratoryFlowRate],
                                          @"peripheralPerfusionIndex": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierPeripheralPerfusionIndex],
                                          @"respiratoryRate": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate],
                                          @"stepCount": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                          }];
    if (@available(iOS 9.0, *)) {
      [dataTypes addEntriesFromDictionary:@{
                                            @"fitzpatrickSkinType": [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierFitzpatrickSkinType],
                                            @"appleStandHour": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierAppleStandHour],
                                            @"cervicalMucusQuality": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierCervicalMucusQuality],
                                            @"intermenstrualBleeding": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierIntermenstrualBleeding],
                                            @"menstrualFlow": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierMenstrualFlow],
                                            @"ovulationTestResult": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierOvulationTestResult],
                                            @"sexualActivity": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity],
                                            @"basalBodyTemperature": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalBodyTemperature],
                                            @"dietaryWater": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryWater],
                                            @"uvExposure": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierUVExposure],
                                            }];
    }
    if (@available(iOS 9.3, *)) {
      [dataTypes addEntriesFromDictionary:@{
                                            @"appleExerciseTime": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierAppleExerciseTime],
                                            }];
    }
    if (@available(iOS 10.0, *)) {
      [dataTypes addEntriesFromDictionary:@{
                                            @"wheelchairUse": [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierWheelchairUse],
                                            @"mindfulSession": [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierMindfulSession],
                                            @"distanceSwimming": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming],
                                            @"distanceWheelchair": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWheelchair],
                                            @"swimmingStrokeCount": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierSwimmingStrokeCount],
                                            @"pushCount": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierPushCount],
                                            }];
    }
    if (@available(iOS 11.0, *)) {
      [dataTypes addEntriesFromDictionary:@{
                                            @"heartRateVariabilitySDNN": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRateVariabilitySDNN],
                                            @"insulinDelivery": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierInsulinDelivery],
                                            @"restingHeartRate": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRestingHeartRate],
                                            @"vo2Max": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierVO2Max],
                                            @"waistCircumference": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierWaistCircumference],
                                            @"walkingHeartRateAverage": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierWalkingHeartRateAverage],
                                            }];
    }
    if (@available(iOS 11.2, *)) {
      [dataTypes addEntriesFromDictionary:@{
                                            @"distanceDownhillSnowSports": [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceDownhillSnowSports],
                                            }];
    }
  });
  return dataTypes;
}

+ (NSSet*)objectTypesForStrings:(NSArray *)strings {
  NSMutableSet* objectTypes = [NSMutableSet setWithCapacity:strings.count];
  NSDictionary* dataTypes = [IosHealthKitPlugin getDataTypes];
  for (int i = 0; i < strings.count; i++) {
    NSString* string = strings[i];
    HKObjectType* objectType = [dataTypes objectForKey:string];
    if (objectType != nil) {
      [objectTypes addObject:objectType];
    }
  }
  return objectTypes;
}

+ (NSString*)stringForAuthorizationStatus:(HKAuthorizationStatus)status {
  switch (status) {
    case HKAuthorizationStatusNotDetermined:
      return @"notDetermined";
    case HKAuthorizationStatusSharingDenied:
      return @"sharingDenied";
    case HKAuthorizationStatusSharingAuthorized:
      return @"sharingAuthorized";
  }
}

+ (NSString*)stringForBiologicalSex:(HKBiologicalSex)biologicalSex {
  switch (biologicalSex) {
    case HKBiologicalSexNotSet:
      return @"notSet";
    case HKBiologicalSexFemale:
      return @"female";
    case HKBiologicalSexMale:
      return @"male";
    case HKBiologicalSexOther:
      return @"other";
  }
}

+ (NSString*)stringForBloodType:(HKBloodType)bloodType {
  switch (bloodType) {
    case HKBloodTypeNotSet:
      return @"notSet";
    case HKBloodTypeANegative:
      return @"aNegative";
    case HKBloodTypeAPositive:
      return @"aPositive";
    case HKBloodTypeBNegative:
      return @"bNegative";
    case HKBloodTypeBPositive:
      return @"bPositive";
    case HKBloodTypeABNegative:
      return @"abNegative";
    case HKBloodTypeABPositive:
      return @"abPositive";
    case HKBloodTypeONegative:
      return @"oNegative";
    case HKBloodTypeOPositive:
      return @"oPositive";
  }
}

+ (NSString*)stringForFitzpatrickSkinType:(HKFitzpatrickSkinType)fitzpatrickSkinType API_AVAILABLE(ios(9.0)){
  switch (fitzpatrickSkinType) {
    case HKFitzpatrickSkinTypeNotSet:
      return @"notSet";
    case HKFitzpatrickSkinTypeI:
      return @"I";
    case HKFitzpatrickSkinTypeII:
      return @"II";
    case HKFitzpatrickSkinTypeIII:
      return @"III";
    case HKFitzpatrickSkinTypeIV:
      return @"IV";
    case HKFitzpatrickSkinTypeV:
      return @"V";
    case HKFitzpatrickSkinTypeVI:
      return @"VI";
  }
}

+ (NSString*)stringForWheelchairUse:(HKWheelchairUse)wheelchairUse API_AVAILABLE(ios(10.0)){
  switch (wheelchairUse) {
    case HKWheelchairUseNotSet:
      return @"notSet";
    case HKWheelchairUseNo:
      return @"no";
    case HKWheelchairUseYes:
      return @"yes";
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* method = [call method];
  NSDictionary* arguments = [call arguments];
  if ([@"isHealthDataAvailable" isEqualToString:method]) {
    result(@([HKHealthStore isHealthDataAvailable]));
  } else if ([@"authorizationStatus" isEqualToString:method]) {
    HKObjectType* objectType = [[IosHealthKitPlugin getDataTypes] objectForKey:arguments[@"type"]];
    HKAuthorizationStatus status = [self.store authorizationStatusForType:objectType];
    result([IosHealthKitPlugin stringForAuthorizationStatus:status]);
  } else if ([@"requestAuthorization" isEqualToString:method]) {
    NSSet* typesToShare = [IosHealthKitPlugin objectTypesForStrings:arguments[@"share"]];
    NSSet* typesToRead = [IosHealthKitPlugin objectTypesForStrings:arguments[@"read"]];
    [self.store requestAuthorizationToShareTypes:typesToShare readTypes:typesToRead completion:^(BOOL success, NSError* error) {
      if (!error) {
        result([error flutterError]);
      } else {
        result(@(success));
      }
    }];
  } else if ([@"biologicalSex" isEqualToString:method]) {
    NSError* error;
    HKBiologicalSexObject* biologicalSexObject = [self.store biologicalSexWithError:&error];
    if (!error) {
      result([error flutterError]);
    } else {
      result([IosHealthKitPlugin stringForBiologicalSex:biologicalSexObject.biologicalSex]);
    }
  } else if ([@"bloodType" isEqualToString:method]) {
    NSError* error;
    HKBloodTypeObject* bloodTypeObject = [self.store bloodTypeWithError:&error];
    if (!error) {
      result([error flutterError]);
    } else {
      result([IosHealthKitPlugin stringForBloodType:bloodTypeObject.bloodType]);
    }
  } else if ([@"dateOfBirth" isEqualToString:method]) {
    if (@available(iOS 10.0, *)) {
      NSError* error;
      NSDateComponents* dateComponents = [self.store dateOfBirthComponentsWithError:&error];
      if (!error) {
        result([error flutterError]);
      } else {
        result([NSString stringWithFormat:@"%ld-%ld-%ld", dateComponents.year, dateComponents.month, dateComponents.day]);
      }
    } else {
      // TODO: result with unavailable error
      result([FlutterError errorWithCode:@""
                                 message:@""
                                 details:@""]);
    }
  } else if ([@"fitzpatrickSkinType" isEqualToString:method]) {
    if (@available(iOS 9.0, *)) {
      NSError* error;
      HKFitzpatrickSkinTypeObject* fitzpatrickSkinTypeObject = [self.store fitzpatrickSkinTypeWithError:&error];
      if (!error) {
        result([error flutterError]);
      } else {
        result([IosHealthKitPlugin stringForFitzpatrickSkinType:fitzpatrickSkinTypeObject.skinType]);
      }
    } else {
      // TODO: result with unavailable error
      result([FlutterError errorWithCode:@""
                                 message:@""
                                 details:@""]);
    }
  } else if ([@"wheelchairUse" isEqualToString:method]) {
    if (@available(iOS 11.0, *)) {
      NSError* error;
      HKWheelchairUseObject* wheelchairUseObject = [self.store wheelchairUseWithError:&error];
      if (!error) {
        result([error flutterError]);
      } else {
        result([IosHealthKitPlugin stringForWheelchairUse:wheelchairUseObject.wheelchairUse]);
      }
    } else {
      // TODO: result with unavailable error
      result([FlutterError errorWithCode:@""
                                 message:@""
                                 details:@""]);
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
