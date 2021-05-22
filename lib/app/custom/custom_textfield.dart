import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/app/custom/custom_picker.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.hint,
    this.label,
    this.pattern,
    this.validator,
    this.controller,
    this.isPicker = false,
    this.isObscure = false,
    this.keyboardType = TextInputType.number,
  }) : super(key: key);

  final String? hint;
  final String? label;
  final bool isPicker;
  final bool isObscure;
  final String? pattern;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  Row _buildSuffix(BuildContext context) {
    final List<IconButton> buttons = <IconButton>[];
    if (widget.isPicker) {
      buttons.add(IconButton(
        icon: const Icon(Icons.timer_rounded),
        onPressed: () async {
          final String? result = await TimePicker.selectTime(context);
          if (result != null) widget.controller!.text = result;
        },
      ));
    } else if (widget.isObscure) {
      buttons.add(IconButton(
        onPressed: () => setState(() => _isObscure = !_isObscure),
        icon: Icon(_isObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons
        ..add(IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => widget.controller!.clear(),
        )),
    );
  }

  UnderlineInputBorder _buildBorder({double width = 2, required Color color}) {
    return UnderlineInputBorder(borderSide: BorderSide(width: width, color: color));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isPicker,
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscure ? _isObscure : false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      inputFormatters: <TextInputFormatter>[
        if (widget.pattern != null) FilteringTextInputFormatter.allow(RegExp(widget.pattern!)),
      ],
      decoration: InputDecoration(
        isDense: true,
        hintMaxLines: 2,
        hintText: widget.hint,
        labelText: widget.label,
        suffix: _buildSuffix(context),
        focusedBorder: _buildBorder(color: Colors.blue),
        errorBorder: _buildBorder(color: Colors.deepOrange),
        errorStyle: const TextStyle(color: Colors.deepOrange),
        enabledBorder: _buildBorder(color: Theme.of(context).accentColor),
        hintStyle: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.7), fontSize: 14),
      ),
    );
  }
}
