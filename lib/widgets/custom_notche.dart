// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
//
// class CustomNotchedShape extends NotchedShape {
//   CustomNotchedShape();
//
//   @override
//   Path getOuterPath(Rect host, Rect? guest) {
//     if (guest == null || !host.overlaps(guest)) {
//       return Path()..addRect(host);
//     }
//
//     // The guest's shape is a circle bounded by the guest rectangle.
//     // So the guest's radius is half the guest width.
//     final double notchRadius = guest.width / 2.0;
//
//     // Scale the notch radius by a factor of 1.5 (or any other value to increase size)
//     final double scaledNotchRadius = notchRadius * 1.2;
//
//     final double a = -1.0 * scaledNotchRadius - 1.0;
//     final double b = host.top - guest.center.dy;
//
//     final double n2 = math.sqrt(b *
//         b *
//         scaledNotchRadius *
//         scaledNotchRadius *
//         (a * a + b * b - scaledNotchRadius * scaledNotchRadius));
//     final double p2xA =
//         ((a * scaledNotchRadius * scaledNotchRadius) - n2) / (a * a + b * b);
//     final double p2xB =
//         ((a * scaledNotchRadius * scaledNotchRadius) + n2) / (a * a + b * b);
//     final double p2yA =
//         math.sqrt(scaledNotchRadius * scaledNotchRadius - p2xA * p2xA);
//     final double p2yB =
//         math.sqrt(scaledNotchRadius * scaledNotchRadius - p2xB * p2xB);
//
//     final List<Offset?> p = List<Offset?>.filled(6, null);
//
//     // p0, p1, and p2 are the control points for segment A.
//     p[0] = Offset(a - 15.0, b);
//     p[1] = Offset(a, b);
//     final double cmp = b < 0 ? -1.0 : 1.0;
//     p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);
//
//     // p3, p4, and p5 are the control points for segment B, which is a mirror
//     // of segment A around the y axis.
//     p[3] = Offset(-1.0 * p[2]!.dx, p[2]!.dy);
//     p[4] = Offset(-1.0 * p[1]!.dx, p[1]!.dy);
//     p[5] = Offset(-1.0 * p[0]!.dx, p[0]!.dy);
//
//     // Translate all points back to the absolute coordinate system.
//     for (int i = 0; i < p.length; i += 1) {
//       p[i] = p[i]! + guest.center;
//     }
//
//     return Path()
//       ..moveTo(host.left, host.top)
//       ..lineTo(p[0]!.dx, p[0]!.dy)
//       ..quadraticBezierTo(p[1]!.dx, p[1]!.dy, p[2]!.dx, p[2]!.dy)
//       ..arcToPoint(
//         p[3]!,
//         radius: Radius.circular(scaledNotchRadius),
//         clockwise: false,
//       )
//       ..quadraticBezierTo(p[4]!.dx, p[4]!.dy, p[5]!.dx, p[5]!.dy)
//       ..lineTo(host.right, host.top)
//       ..lineTo(host.right, host.bottom)
//       ..lineTo(host.left, host.bottom)
//       ..close();
//   }
// }
//
// Widget CustomWidget({required Widget child}) => Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(color: Colors.blue),
//     );
