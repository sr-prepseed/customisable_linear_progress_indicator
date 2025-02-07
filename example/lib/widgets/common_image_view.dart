import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CommonImageView extends StatefulWidget {
  ///[url] is required parameter for fetching network image
  final String? url;
  final double? radius;

  final String? imagePath;
  final String? svgPath;
  final File? file;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final String placeHolder;

  ///a [CommonNetworkImageView] it can be used for showing any network images
  /// it will shows the placeholder image if image is not found on network
  const CommonImageView({
    super.key,
    this.url,
    this.imagePath,
    this.radius,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.fill,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  @override
  State<CommonImageView> createState() => _CommonImageViewState();
}

class _CommonImageViewState extends State<CommonImageView> {
  // var theImage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius ?? 0),
        child: _buildImageView());
  }

  Widget _buildImageView() {
    if (widget.svgPath != null && widget.svgPath!.isNotEmpty) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: SvgPicture.asset(
          widget.svgPath!,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          color: widget.color,
        ),
      );
    } else if (widget.file != null && widget.file!.path.isNotEmpty) {
      return Image.file(
        widget.file!,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        color: widget.color,
      );
    } else if (widget.url != null && widget.url!.isNotEmpty) {
      if (widget.url?.endsWith(".svg") == true) {
        return SvgPicture.network(
          widget.url!,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          color: widget.color,
        );
      }
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: CachedNetworkImage(
          imageUrl: widget.url!,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
        ),
      );
    } else if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      return Image.asset(
        widget.imagePath!,
        height: widget.height,
        width: widget.width,
        color: widget.color,
        fit: widget.fit,
      );
    }
    return const SizedBox();
  }
}
