import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@immutable
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  const factory AppLogo.sized({
    final double? dimention,
  }) = _AppLogoPadded;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .primary
        .value
        .toRadixString(16)
        .substring(2);
    final circle =
        '<circle cx="200" cy="200" r="197" fill="none" stroke="#$color" stroke-width="7"/>';
    final logo = '<path fill="#$color" d="$pathData"/></svg>';
    return SvgPicture.string('$svgXmlns$circle$logo');
  }

  static const svgXmlns =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">';
  static const pathData = '''
m212 35-2 8c-3 13-8 19-19 22-9 2-9 2-10 5 0 2 1 3 7 5 14 3 19 8 22 24 2 7 8 10
8 3 0-14 9-25 24-28 7-1 8-7 0-8-14-2-21-9-23-24-1-6-4-9-7-7m10 30 5 4c2 1 2 2 0
2-3 2-8 6-10 10-3 5-3 5-5 1-1-3-7-9-10-10s-3-2 1-4l10-10 1-4 2 4 6 7M91 89c-3 3
0 7 28 30 35 30 46 35 108 52l42 12c37 13 43 13 59 8 14-5 16-4 11 8-9 17-25 26-46
25-51-3-59-1-91 20-14 9-17 10-26 11-13 0-18-4-33-30-18-33-21-36-68-64-22-13-25-14-24-8
0 3 4 6 38 26 25 15 31 21 42 40l11 19c17 29 33 32 65 12 28-18 40-21 78-19 21 1
25 1 37-5 15-7 27-24 27-37 0-10-5-12-22-6-15 5-20 5-55-7l-41-12c-71-19-77-23-129-70-7-6-9-7-11-5m179
17-2 2c-2 12-4 15-11 17l-6 1-1 3 1 3 5 1c3 1 6 2 7 4 2 2 3 3 5 11 1 4 5 5 6
1l5-12 11-5c5 0 3-6-3-7-8-2-10-5-12-16-1-2-3-3-5-3m4 20 3 3-3 3-3 3-3-3-3-3 3-3
3-3 3 3m-119 71c-2 3 0 7 6 13 11 9 34 10 30 1-1-2-2-2-8-2-11 0-17-3-21-10-2-3-5-4-7-2m92
85a1118 1118 0 0 0-79 23c-10 5-11 20-1 26 5 3 7 3 33-1 23-3 24-3 25-1 2 2 6 0
6-3s-4-6-7-6l-26 3c-28 4-30 4-30-4 0-6 3-7 15-11l40-11c44-12 41-13 79 16 6 4 8
4 9 2 2-3 1-5-8-12l-18-12a42 42 0 0 0-38-9m-151 2c-8 4-11 15-6 22 2 4 3 5 65 48
19 14 20 14 68 5 41-8 41-8 48-3s14 3 9-3c-11-10-12-10-58-2-50 9-44 10-72-10l-36-25c-20-15-22-18-16-24
5-4 4-4 30 12l20 12c4 0 5-6 2-8-43-26-46-28-54-24''';
}

@immutable
final class _AppLogoPadded extends AppLogo {
  const _AppLogoPadded({this.dimention});

  final double? dimention;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox.square(
        dimension: dimention ?? 300,
        child: const AppLogo(),
      ),
    );
  }
}