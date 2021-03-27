import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/components/custom_picker.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    @required this.label,
    @required this.validator,
    @required this.controller,
    this.desc = '',
    this.isPicker = false,
    this.isObscure = false,
    this.hint = 'Enter value',
    this.keyboardType = TextInputType.text,
    Key key,
  }) : super(key: key);

  final String hint;
  final String desc;
  final String label;
  final bool isPicker;
  final bool isObscure;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final TextEditingController controller;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isPicker,
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscure ? _isObscure : false,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        helperText: widget.desc,
        suffix: _buildSuffix(context),
        focusedBorder: _buildBorder(color: Colors.blue),
        contentPadding: const EdgeInsets.only(left: 10),
        focusedErrorBorder: _buildBorder(color: Colors.red),
        border: _buildBorder(color: Theme.of(context).accentColor),
        hintStyle: TextStyle(color: Theme.of(context).accentColor),
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        errorBorder: _buildBorder(width: 3, color: Colors.redAccent),
        helperStyle: TextStyle(color: Theme.of(context).accentColor),
        enabledBorder: _buildBorder(color: Theme.of(context).accentColor),
        errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _buildSuffix(BuildContext context) {
    final List<IconButton> buttons = <IconButton>[];
    if (widget.isPicker) {
      buttons.add(IconButton(
        icon: const Icon(Icons.timer_rounded),
        onPressed: () async => widget.controller.text = await TimePicker.selectTime(context),
      ));
    } else if (widget.isObscure) {
      buttons.add(IconButton(
        onPressed: () => setState(() => _isObscure = !_isObscure),
        icon: Icon(_isObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons..add(IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () => widget.controller.clear())),
    );
  }

  UnderlineInputBorder _buildBorder({double width = 2, Color color}) {
    return UnderlineInputBorder(borderSide: BorderSide(width: width, color: color));
  }
}
