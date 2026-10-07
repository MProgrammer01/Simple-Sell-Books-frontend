import 'package:flutter/material.dart';

class TypographyApp extends ThemeExtension<TypographyApp> {
  final TextStyle headlineXL;
  final TextStyle headlineLG;
  final TextStyle headlineMD;
  final TextStyle bodyLG;
  final TextStyle bodyMD;
  final TextStyle labelSM;
  final TextStyle monoSM;

  const TypographyApp({
    required this.headlineXL,
    required this.headlineLG,
    required this.headlineMD,
    required this.bodyLG,
    required this.bodyMD,
    required this.labelSM,
    required this.monoSM,
  });

  static const instance = TypographyApp(
    headlineXL: TextStyle(
      fontFamily: 'Geist',
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 36 / 30,
    ),
    headlineLG: TextStyle(
      fontFamily: 'Geist',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 32 / 24,
    ),
    headlineMD: TextStyle(
      fontFamily: 'Geist',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 28 / 18,
    ),
    bodyLG: TextStyle(
      fontFamily: 'Geist',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
    ),
    bodyMD: TextStyle(
      fontFamily: 'Geist',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    ),
    labelSM: TextStyle(
      fontFamily: 'Geist',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    ),
    monoSM: TextStyle(
      fontFamily: 'Geist Mono',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    ),
  );

  @override
  ThemeExtension<TypographyApp> copyWith({
    TextStyle? headlineXL,
    TextStyle? headlineLG,
    TextStyle? headlineMD,
    TextStyle? bodyLG,
    TextStyle? bodyMD,
    TextStyle? labelSM,
    TextStyle? monoSM,
  }) {
    return TypographyApp(
      headlineXL: headlineXL ?? this.headlineXL,
      headlineLG: headlineLG ?? this.headlineLG,
      headlineMD: headlineMD ?? this.headlineMD,
      bodyLG: bodyLG ?? this.bodyLG,
      bodyMD: bodyMD ?? this.bodyMD,
      labelSM: labelSM ?? this.labelSM,
      monoSM: monoSM ?? this.monoSM,
    );
  }

  @override
  ThemeExtension<TypographyApp> lerp(
    covariant ThemeExtension<TypographyApp>? other,
    double t,
  ) {
    if (other is! TypographyApp) return this;
    return TypographyApp(
      headlineXL: TextStyle.lerp(headlineXL, other.headlineXL, t)!,
      headlineLG: TextStyle.lerp(headlineLG, other.headlineLG, t)!,
      headlineMD: TextStyle.lerp(headlineMD, other.headlineMD, t)!,
      bodyLG: TextStyle.lerp(bodyLG, other.bodyLG, t)!,
      bodyMD: TextStyle.lerp(bodyMD, other.bodyMD, t)!,
      labelSM: TextStyle.lerp(labelSM, other.labelSM, t)!,
      monoSM: TextStyle.lerp(monoSM, other.monoSM, t)!,
    );
  }
}
