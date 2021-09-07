/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';

@immutable
class AnchorElement {
  const AnchorElement({this.href});
  final String? href;
  void click() {}
  void setAttribute(String attr, String value) {}
}
