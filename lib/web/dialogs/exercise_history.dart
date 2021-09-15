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
import 'package:tendon_loader/custom/app_frame.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';

@immutable
class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({Key? key, required this.user}) : super(key: key);

  final Patient user;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(children: _buildItems(user.exports!).toList()),
      ),
    );
  }

  Iterable<Widget> _buildItems(List<Export> exports) sync* {
    if (exports.isEmpty) {
      yield const Center(child: Text('It\'s Empty!'));
      return;
    }
    for (final Export export in exports) {
      if (!export.isMVC) {
        yield ExpansionTile(
          maintainState: true,
          title: Text(export.dateTime),
          children: <Widget>[export.prescription!.toTable()],
        );
      }
    }
  }
}
