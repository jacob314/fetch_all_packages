var debug = true;

void flog(String str, [String str2, String str3, String str4]) {
  if (!debug) return;

  final fmt = [str, str2, str3, str4].where((s) => s != null).join(' ');

  print(fmt);
}
