import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.menu_book_rounded,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final image = url.isEmpty
        ? _Placeholder(
            width: width,
            height: height,
            icon: placeholderIcon,
          )
        : Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return _Placeholder(
                width: width,
                height: height,
                icon: placeholderIcon,
                showSpinner: true,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _Placeholder(
                width: width,
                height: height,
                icon: placeholderIcon,
              );
            },
          );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    this.width,
    this.height,
    required this.icon,
    this.showSpinner = false,
  });

  final double? width;
  final double? height;
  final IconData icon;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: AppTheme.card,
      alignment: Alignment.center,
      child: showSpinner
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, color: Colors.white54, size: 36),
    );
  }
}
