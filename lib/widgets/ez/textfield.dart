import 'package:flutter/material.dart';
import 'package:ollama_app/globals.dart';
import 'package:ollama_app/widgets/icons/arrowup.dart';

typedef OnSubmittedCallback = void Function(String text);

class EzTextField extends StatefulWidget {
  const EzTextField(
      {super.key, this.onSubmitted, this.disableSubmitButton, this.hintText});
  final OnSubmittedCallback? onSubmitted;
  final bool? disableSubmitButton;
  final String? hintText;

  @override
  State<EzTextField> createState() => _EzTextFieldState();
}

class _EzTextFieldState extends State<EzTextField> {
  bool _sendButtonDisabled = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      if (_controller.text.trim().isNotEmpty) {
        _sendButtonDisabled = false;
        return;
      }

      _sendButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(9999),
        right: Radius.circular(9999),
      ),
    );

    return SizedBox(
      height: 48,
      child: TextField(
        controller: _controller,
        style: TextStyle(color: Globals.ctp.text, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: Globals.ctp.surface2,
          border: border,
          focusedBorder: border,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Globals.ctp.overlay2,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: (widget.disableSubmitButton ?? false)
              ? null
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconButton.filled(
                    icon: ArrowUp(
                        color: _sendButtonDisabled
                            ? Globals.ctp.text
                            : Globals.ctp.base),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _sendButtonDisabled
                            ? Globals.ctp.surface0
                            : Globals.ctp.green,
                      ),
                    ),
                    onPressed: _sendButtonDisabled
                        ? null
                        : () => (widget.onSubmitted ??
                            (String text) {})(_controller.text),
                  ),
                ),
        ),
        cursorColor: Globals.ctp.lavender,
      ),
    );
  }
}
