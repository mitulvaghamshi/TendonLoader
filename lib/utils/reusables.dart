import 'package:flutter/material.dart';

TextStyle mTextStyle1 = TextStyle(color: Colors.white);
TextStyle mTextStyle2 = TextStyle(color: Colors.black);

RoundedRectangleBorder mRoundedRectangleBorder =
RoundedRectangleBorder(borderRadius: mBorderRadiusTlBl);

RoundedRectangleBorder mRoundedRectangleBorder1 =
RoundedRectangleBorder(borderRadius: mBorderRadiusTl);

BorderRadius mBorderRadiusTlBl = BorderRadius.only(
    topLeft: Radius.circular(100.0), bottomLeft: Radius.circular(100.0));

BorderRadius mBorderRadiusTl =
BorderRadius.only(topLeft: Radius.circular(100.0));

BorderRadius mBorderRadiusBlBr = BorderRadius.only(
    bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0));

BorderRadius mBorderRadiusTlTr = BorderRadius.only(
    topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0));

// Colors.primaries[_counter % Colors.primaries.length];

/* AppBar _buildAppBar() => AppBar(
      backgroundColor: Colors.white,
      title: Text('Krishna Ent. Pvt. Ltd.'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.clear), onPressed: () => exit(0))
      ],
      leading: IconButton(icon: Icon(Icons.apps), onPressed: () {})); */

