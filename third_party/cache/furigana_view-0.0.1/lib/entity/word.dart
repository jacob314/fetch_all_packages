class Word {
  final String text;
  final String baseForm;
  final String hiragana;
  final String katakana;
  final String romaji;
  final bool hasFurigana;
  final bool isBreak;
  final bool hasMeaning;
  final int style;

  Word(this.text, this.baseForm, this.hiragana, this.katakana, this.romaji,
      this.hasFurigana, this.hasMeaning, this.isBreak, this.style);

  Word.fromJson(Map<String, dynamic> json) : text = json['text'],
        baseForm = json['base_form'], hiragana = json['hiragana'],
        katakana = json['katakana'], romaji = json['romaji'],
        hasFurigana = json['has_furi'], isBreak = json['is_break'],
        hasMeaning = json['is_meaning'], style = json['style'];
}