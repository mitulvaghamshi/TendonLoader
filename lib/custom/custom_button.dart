/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.left,
    this.right,
    this.color,
    this.onPressed,
    this.radius = 30,
    this.rounded = false,
    this.elevation = 16,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final Color? color;
  final bool rounded;
  final double radius;
  final Widget? left;
  final Widget? right;
  final double? elevation;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: padding,
      elevation: elevation!,
      onPressed: onPressed,
      disabledElevation: elevation!,
      fillColor: color ?? Theme.of(context).buttonColor,
      shape: rounded
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      constraints: rounded
          ? BoxConstraints.tight(Size.fromRadius(radius))
          : const BoxConstraints(minWidth: 30, minHeight: 30),
      child: rounded || left == null || right == null
          ? left ?? right
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[left!, const SizedBox(width: 5), right!],
            ),
    );
  }
}
