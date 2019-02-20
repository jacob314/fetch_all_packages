class ImageColor {
  int backgroundColor = 0;
  int primaryColor = 0;
  int secondaryColor = 0;
  bool isLight = false;

  ImageColor.fromJson(Map<String, dynamic> json)
      : backgroundColor = json['backgroundColor'],
        primaryColor = json['primaryColor'],
        secondaryColor = json['secondaryColor'],
        isLight = json['isLight'];
}
