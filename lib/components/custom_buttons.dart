import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.color,
    required this.label,
    this.disabled = false,
    this.textColor,
    this.showLoading = false,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final String label;
  final bool disabled;
  final Color? textColor;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onPressed,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: disabled
              ? const Color(0xFFB1B1B1)
              : color ?? Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (showLoading) ...{
                SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor ?? Colors.white,
                    )),
                const SizedBox(
                  width: 10,
                )
              },
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: disabled
                          ? const Color(0xFFF5F5F5)
                          : textColor ?? Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.onPressed,
    this.color,
    required this.label,
    this.disabled = false,
    this.textColor,
    this.showLoading = false,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final String label;
  final bool disabled;
  final Color? textColor;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onPressed,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: disabled ? const Color(0xFFF5F5F5) : color ?? Colors.grey,
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (showLoading) ...{
                SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor ?? Colors.white,
                    )),
                const SizedBox(
                  width: 10,
                )
              },
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: disabled
                          ? const Color(0xFFC8C8C8)
                          : textColor ?? Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EateryOutlinedButton extends StatelessWidget {
  const EateryOutlinedButton(
      {super.key,
      this.onPressed,
      this.color,
      required this.child,
      this.disabled = false,
      this.size = 40,
      this.showOutline = true});
  final VoidCallback? onPressed;
  final Color? color;
  final Widget child;
  final bool disabled;
  final int size;
  final bool showOutline;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: size.toDouble(),
          height: size.toDouble(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: showOutline
                      ? const Color(0xFFF5F5F5)
                      : Theme.of(context).scaffoldBackgroundColor)),
          child: Center(child: child),
        ),
      ),
    );
  }
}
