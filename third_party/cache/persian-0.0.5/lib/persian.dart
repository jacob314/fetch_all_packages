library persian;

String toPersian(String text) {
  if (text == null || text.isEmpty) {
    return text;
  }

  final output = new StringBuffer();
  final persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < text.length; i++) {
    final char = text.codeUnitAt(i);
    if (char >= 48 && char <= 57) {
      output.write(persian[char - 48]);
    } else {
      output.write(new String.fromCharCode(char));
    }
  }

  return output.toString();
}
