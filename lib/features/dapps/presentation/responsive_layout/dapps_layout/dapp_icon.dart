import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mxc_ui/mxc_ui.dart';

class DappIcon extends StatelessWidget {
  final String? image;
  final double iconSize;
  final Color? iconColor;
  const DappIcon(
      {super.key, required this.image, required this.iconSize, this.iconColor});

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Icon(
        Icons.image_not_supported_rounded,
        color: ColorsTheme.of(context).textPrimary,
      );
    }

    ColorFilter? iconColorFilter;
    if (iconColor != null) {
      iconColorFilter = ColorFilter.mode(iconColor!, BlendMode.srcIn);
    }

    final isNetworkImage = image!.contains(
          'https',
        ) ||
        image!.contains(
          'http',
        );

    if (isNetworkImage) {
      if (image!.contains('svg')) {
        return SvgPicture.network(
          image!,
          height: iconSize,
          width: iconSize,
          colorFilter: iconColorFilter,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: image!,
          height: iconSize,
          width: iconSize,
          fit: BoxFit.fitHeight,
          // scale: iconSize,
          errorWidget: (context, url, error) {
            return Column(
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: ColorsTheme.of(context).textError,
                ),
              ],
            );
          },
        );
      }
    } else {
      if (image!.contains('svg')) {
        return SvgPicture.asset(
          image!,
          fit: BoxFit.fill,
          colorFilter: iconColorFilter,
          height: iconSize,
          width: iconSize,
        );
      } else {
        return Image.asset(
          image!,
          fit: BoxFit.fill,
          height: iconSize,
          width: iconSize,
        );
      }
    }
  }
}
