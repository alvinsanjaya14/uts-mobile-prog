import 'package:flutter/material.dart';

/// A custom button widget that provides consistent styling across the app.
/// Supports primary (green) and danger (red) button types with outline and text variants.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isTextOnly;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextOnly = false,
    this.width,
  });

  const CustomButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextOnly = false,
    this.width,
  }) : type = CustomButtonType.primary;

  /// Danger button (red)
  const CustomButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isTextOnly = false,
    this.width,
  }) : type = CustomButtonType.danger;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final child = _buildButtonContent();

    Widget button;
    
    if (isTextOnly) {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    } else if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: child,
      );
    }

    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingIndicatorColor(),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle() {
    final colors = _getColors();
    
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey[300];
          }
          return colors['background'];
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey[500] ?? Colors.grey;
          }
          return colors['foreground'] ?? Colors.black;
        },
      ),
      side: WidgetStateProperty.resolveWith<BorderSide?>(
        (Set<WidgetState> states) {
          if (isOutlined) {
            return BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? Colors.grey[300] ?? Colors.grey
                  : colors['border'] ?? Colors.green,
              width: 1.5,
            );
          }
          return null;
        },
      ),
      padding: WidgetStateProperty.all(_getPadding()),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevation: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) {
          if (isTextOnly || isOutlined) {
            return 0;
          }
          if (states.contains(WidgetState.pressed)) {
            return 2;
          }
          return 1;
        },
      ),
      textStyle: WidgetStateProperty.all(_getTextStyle()),
    );
  }

  TextStyle _getTextStyle() {
    double fontSize;
    FontWeight fontWeight;

    switch (size) {
      case CustomButtonSize.small:
        fontSize = 14;
        fontWeight = FontWeight.w500;
        break;
      case CustomButtonSize.medium:
        fontSize = 16;
        fontWeight = FontWeight.w600;
        break;
      case CustomButtonSize.large:
        fontSize = 18;
        fontWeight = FontWeight.w700;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small:
        return 16;
      case CustomButtonSize.medium:
        return 20;
      case CustomButtonSize.large:
        return 24;
    }
  }

  Map<String, Color?> _getColors() {
    Color baseColor;
    
    switch (type) {
      case CustomButtonType.primary:
        baseColor = const Color.fromARGB(255, 0, 127, 95);
        break;
      case CustomButtonType.danger:
        baseColor = Colors.red;
        break;
    }

    if (isTextOnly) {
      return {
        'background': null,
        'foreground': baseColor,
        'border': null,
      };
    } else if (isOutlined) {
      return {
        'background': null,
        'foreground': baseColor,
        'border': baseColor,
      };
    } else {
      return {
        'background': baseColor,
        'foreground': Colors.white,
        'border': baseColor,
      };
    }
  }

  Color _getLoadingIndicatorColor() {
    if (isTextOnly || isOutlined) {
      return type == CustomButtonType.primary ? Colors.green[700]! : Colors.red[300]!;
    } else {
      return Colors.white;
    }
  }
}

enum CustomButtonType {
  primary,
  danger,
}

enum CustomButtonSize {
  small,
  medium,
  large,
}