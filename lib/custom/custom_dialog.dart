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

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.size,
    this.title,
    this.action,
    this.content,
  }) : super(key: key);

  final Size? size;
  final String? title;
  final Widget? action;
  final Widget? content;

  static Future<T?> show<T>(
    BuildContext context, {
    Size? size,
    String? title,
    Widget? action,
    Widget? content,
  }) async {
    return showDialog<T?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        size: size ?? const Size(350, 700),
        title: title,
        action: action,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CustomButton _defaultAction = CustomButton(
      radius: 20,
      rounded: true,
      onPressed: context.pop,
      padding: EdgeInsets.zero,
      left: const Icon(Icons.clear, color: colorErrorRed),
    );
    if (kIsWeb) {
      return Center(
        child: AppFrame(
          padding: EdgeInsets.zero,
          child: SizedBox.fromSize(
            size: size,
            child: Scaffold(
              appBar: AppBar(
                leading: action,
                title: Text(title ?? 'Tendon Loader'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              body: Align(alignment: Alignment.topCenter, child: content),
            ),
          ),
        ),
      );
    }
    return AlertDialog(
      scrollable: true,
      content: content,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FittedBox(child: Text(title ?? '', style: ts18w5)),
          const SizedBox(width: 5),
          FittedBox(child: action ?? _defaultAction),
        ],
      ),
    );
  }
}
