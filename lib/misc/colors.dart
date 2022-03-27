import 'dart:ui';

class AppColors {
  static final Color white = HexColor.fromHex('#FFFFFF');

  // Grayscale
  static final Color gray900 = HexColor.fromHex('#111827');
  static final Color gray800 = HexColor.fromHex('#1D2734');
  static final Color gray700 = HexColor.fromHex('#374151');
  static final Color gray600 = HexColor.fromHex('#4B5563');
  static final Color gray500 = HexColor.fromHex('#6B7280');
  static final Color gray400 = HexColor.fromHex('#9CA3AF');
  static final Color gray300 = HexColor.fromHex('#D1D5DB');
  static final Color gray200 = HexColor.fromHex('#E5E7EB');
  static final Color gray100 = HexColor.fromHex('#F3F4F6');
  static final Color gray50 = HexColor.fromHex('#F9FAFB');
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
