import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/font_family_value.dart';
import 'package:figma2flutter/models/font_weight_value.dart';
import 'package:figma2flutter/models/letter_spacing_value.dart';
import 'package:figma2flutter/models/text_leading_distribution_value.dart';

class TextStyleValue {
  final FontFamilyValue? fontFamily;
  final FontWeightValue? fontWeight;
  final DimensionValue? lineHeight;
  final DimensionValue? fontSize;
  final LetterSpacingValue? letterSpacing;
  final TextLeadingDistributionValue leadingDistribution;

  TextStyleValue._({
    this.fontFamily,
    this.fontWeight,
    this.lineHeight,
    this.fontSize,
    this.letterSpacing,
    this.leadingDistribution = const TextLeadingDistributionValue(TextLeadingDistribution.even),
  });

  static TextStyleValue? maybeParse(dynamic value) {
    if (value == null) return null;

    final fontFamily = FontFamilyValue.maybeParse(value['fontFamily']);
    final fontWeight = FontWeightValue.maybeParse(value['fontWeight']);
    final sizeAndHeight = _FontSizeLineHeight(value);

    final letterSpacing = LetterSpacingValue.maybeParse(value['letterSpacing']);
    final leadingDistribution = TextLeadingDistributionValue.maybeParse(value['leadingDistribution']);


    return TextStyleValue._(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      lineHeight: sizeAndHeight.lineHeight,
      fontSize: sizeAndHeight.fontSize,
      letterSpacing: letterSpacing,
      leadingDistribution: leadingDistribution ?? TextLeadingDistributionValue(TextLeadingDistribution.even),
    );
  }

  @override
  String toString() {
    final parts = <String>[];

    if (fontFamily != null) parts.add("fontFamily: '$fontFamily'");
    if (fontSize != null) parts.add('fontSize: $fontSize');
    if (fontWeight != null) parts.add('fontWeight: $fontWeight');
    if (lineHeight != null) parts.add('height: $lineHeight');
    if (letterSpacing != null) parts.add('letterSpacing: $letterSpacing');
    parts.add("leadingDistribution: ${leadingDistribution}");
    if (parts.isEmpty) return 'const TextStyle()';

    return '''const TextStyle(
  ${parts.join(',\n  ')},
)''';
  }
}

class _FontSizeLineHeight {
  DimensionValue? fontSize;
  DimensionValue? lineHeight;

  _FontSizeLineHeight(dynamic value) {
    final fontSize = DimensionValue.maybeParse(value['fontSize']);
    final lineHeight = DimensionValue.maybeParse(value['lineHeight']);

    this.lineHeight = lineHeight;
    this.fontSize = fontSize;

    // Used 8px as a reasonable possible pixel line height
    if (lineHeight != null && lineHeight.value >= 8.0 && fontSize != null) {
      this.lineHeight = DimensionValue(lineHeight.value / fontSize.value);
    }
  }
}
