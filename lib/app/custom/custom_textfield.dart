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
  late bool _isObscure;

  Row get _buildSuffix {
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

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      readOnly: widget.isPicker,
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(fontSize: 20, fontFamily: 'Georgia'),
      inputFormatters: <TextInputFormatter>[
        if (widget.pattern != null) FilteringTextInputFormatter.allow(RegExp(widget.pattern!)),
      ],
      decoration: InputDecoration(
        isDense: true,
        hintMaxLines: 3,
        suffix: _buildSuffix,
        hintText: widget.hint,
        labelText: widget.label,
        errorStyle: const TextStyle(color: Colors.deepOrange),
        hintStyle: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.7), fontSize: 14),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.blue)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.deepOrange)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).accentColor)),
      ),
    );
  }
}
