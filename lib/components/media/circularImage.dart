import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/colors.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetwork;
  final double opacity;
  final bool hasOverlay;

  CircularImage({ required this.imageUrl, required this.size, this.isNetwork = true, this.opacity = 0.4, this.hasOverlay = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size/2)),
        child: Stack(
          children: [
            isNetwork ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: size,
              width: size,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame == 0) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      height: size,
                      width: size,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                    height: size,
                    width: size,
                    child: Center(child: Icon(Icons.error, color: Colors.red)),
                  ),
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return Container(
                      child: child
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      height: size,
                      width: size,
                      child: Center(child: Icon(Icons.error, color: Colors.red)),
                    ),
                  );
                }
              },
            ) :
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: size,
              width: size,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame == 0) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              },
            ),
            hasOverlay? Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: CustomColors.black.withOpacity(opacity),
              ),
            ) : SizedBox()
          ],
        ),
      ),
    );
  }
}