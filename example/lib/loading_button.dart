import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    this.width,
    this.height,
    this.radius,
    this.child,
  });

  final Future<void> Function() onPressed;
  final double? width;
  final double? height;
  final double? radius;
  final Widget? child;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 48,
      child: FilledButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          await widget.onPressed.call();
          setState(() {
            _isLoading = false;
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.primary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 12),
            ),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: colorScheme.surface,
            strokeWidth: 3,
          ),
        )
            : widget.child,
      ),
    );
  }
}