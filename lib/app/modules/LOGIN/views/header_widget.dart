import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  final double height;
  final bool showIcon;
  final IconData icon;

  const HeaderWidget(this.height, this.showIcon, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        _buildClipPath(
          context,
          [
            Offset(width / 5, height),
            Offset(width / 10 * 5, height - 60),
            Offset(width / 5 * 4, height + 20),
            Offset(width, height - 18)
          ],
          [
            Get.theme.primaryColor.withOpacity(0.4),
            Colors.grey.shade200.withOpacity(0.4)
          ],
        ),
        _buildClipPath(
          context,
          [
            Offset(width / 3, height + 20),
            Offset(width / 10 * 8, height - 60),
            Offset(width / 5 * 4, height - 60),
            Offset(width, height - 20)
          ],
          [
            Theme.of(context).primaryColor.withOpacity(0.4),
            Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          ],
        ),
        _buildClipPath(
          context,
          [
            Offset(width / 5, height),
            Offset(width / 2, height - 40),
            Offset(width / 5 * 4, height - 80),
            Offset(width, height - 20)
          ],
          [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColor,
          ],
        ),
        if (showIcon)
          SizedBox(
            height: height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 70.0),
                child: Image.asset('assets/logo003.png'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildClipPath(
      BuildContext context, List<Offset> offsets, List<Color> colors) {
    return ClipPath(
      clipper: ShapeClipper(offsets),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  final List<Offset> offsets;

  ShapeClipper(this.offsets);

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0.0, size.height - 20)
      ..quadraticBezierTo(
          offsets[0].dx, offsets[0].dy, offsets[1].dx, offsets[1].dy)
      ..quadraticBezierTo(
          offsets[2].dx, offsets[2].dy, offsets[3].dx, offsets[3].dy)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
