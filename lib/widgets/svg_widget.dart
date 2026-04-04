import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String path;
  final String? semanticsLabel;
  final bool isNetwork;
  final double percentage;
  final BoxFit fit;

  const SvgWidget({
    super.key,
    required this.path,
    this.semanticsLabel,
    this.isNetwork = false,
    this.percentage = 0.1,
    this.fit = BoxFit.scaleDown,
  }) : assert(
          percentage > 0 && percentage <= 1,
          'percentage must be between 0 and 1',
        );

  double _resolveSize(BuildContext context) {
    final mq = MediaQuery.of(context);
    final base =
        mq.orientation == Orientation.portrait ? mq.size.width : mq.size.height;
    return (base * percentage).clamp(16, 200); // min 16, max 200
  }

  @override
  Widget build(BuildContext context) {
    final size = _resolveSize(context);

    if (isNetwork) {
      return SvgPicture.network(
        path,
        width: size,
        height: size,
        fit: fit,
        semanticsLabel: semanticsLabel,
        placeholderBuilder: (_) => SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    }

    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );
  }
}
