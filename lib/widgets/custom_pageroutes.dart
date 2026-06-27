import 'package:flutter/material.dart';

// Function for custom circular page transition
PageRouteBuilder customCircularPageRoute({
  required Widget page, // 'page' is a named parameter
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.easeInOut;
      var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

      return AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, child) {
          var radius = curvedAnimation.value * (MediaQuery.of(context).size.width * 1.5); // Adjust the radius based on screen size
          return ClipPath(
            clipper: CircleClipper(radius),
            child: child,
          );
        },
        child: child,
      );
    },
  );
}

// CircleClipper used for custom clipping of the transition
class CircleClipper extends CustomClipper<Path> {
  final double radius;

  CircleClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
