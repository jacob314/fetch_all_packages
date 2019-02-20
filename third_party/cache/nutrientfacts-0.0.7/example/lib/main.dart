import 'package:flutter/material.dart';
import 'package:nutrientfacts/nutrientfacts.dart';

final nutrientData = {
  "CA": {"amount": 37.5, "unit": "mg"},
  "CHOCDF": {"amount": 342.1, "unit": "g"},
  "CHOLE": {"amount": 16.561, "unit": "mg"},
  "ENERC_KCAL": {"amount": 2135.9, "unit": "kcal"},
  "FAT": {"amount": 67.51, "unit": "g"},
  "FE": {"amount": 18.2, "unit": "mg"},
  "FIBTG": {"amount": 12.90, "unit": "g"},
  "FOLAC": {"amount": 385.0, "unit": "mcg"},
  "K": {"amount": 676.7, "unit": "mg"},
  "MG": {"amount": 133.07, "unit": "mg"},
  "NA": {"amount": 1038.89, "unit": "mg"},
  "NIA": {"amount": 19.49, "unit": "mg"},
  "P": {"amount": 381.19, "unit": "mg"},
  "PROCNT": {"amount": 35.99, "unit": "g"},
  "RIBF": {"amount": 1.6, "unit": "mg"},
  "SE": {"amount": 84.75, "unit": "mcg"},
  "SUGAR": {"amount": 74.49, "unit": "g"},
  "THIA": {"amount": 2.74, "unit": "mg"},
  "VITA_IU": {"amount": 5.0, "unit": "IU"},
  "VITB6A": {"amount": 0.11, "unit": "mg"},
  "VITD": {"amount": 28.39, "unit": "IU"},
  "VITK1": {"amount": 0.75, "unit": "mcg"},
  "ZN": {"amount": 2.93, "unit": "mg"},
  "SATFAT": {"amount": 4.2, "unit": "g"},
  "TRANSFAT": {"amount": 4.2, "unit": "g"},
  "FIBER": {"amount": 4.23456, "unit": "g"},
};

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    title: "Nutritional Facts!",
    home: NutritionFacts(nutrientData: nutrientData),
  ));
}
