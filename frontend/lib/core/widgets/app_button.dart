import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: _getLoadingSize(),
              height: _getLoadingSize(),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
              ),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, size: _getIconSize()),
          ),
        Text(text, style: textStyle),
      ],
    );

    if (width != null) {
      child = SizedBox(width: width, child: Center(child: child));
    }

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = switch (type) {
      AppButtonType.primary => ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      AppButtonType.secondary => ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
      AppButtonType.outline => OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
        ),
    };

    return baseStyle.copyWith(
      padding: MaterialStateProperty.all(_getPadding()),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
    };
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (size) {
      AppButtonSize.small => AppTextStyles.buttonSmall,
      AppButtonSize.medium => AppTextStyles.buttonMedium,
      AppButtonSize.large => AppTextStyles.buttonLarge,
    };

    return type == AppButtonType.outline
        ? baseStyle.copyWith(color: AppColors.primary)
        : baseStyle;
  }

  double _getLoadingSize() {
    return switch (size) {
      AppButtonSize.small => 14,
      AppButtonSize.medium => 16,
      AppButtonSize.large => 20,
    };
  }

  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => 16,
      AppButtonSize.medium => 20,
      AppButtonSize.large => 24,
    };
  }

  Color _getLoadingColor() {
    return type == AppButtonType.outline ? AppColors.primary : Colors.white;
  }
}
