// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class RoundedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final Color backgroundColor;
//   final Color textColor;
//   final double height;
//   final double width;
//   final double borderRadius;

//   const RoundedButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.backgroundColor = Colors.grey,
//     this.textColor = Colors.black,
//     this.height = 92,
//     this.width = double.infinity,
//     this.borderRadius = 91.27,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: TextButton(
//         onPressed: onPressed,
//         style: TextButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//           padding: EdgeInsets.zero,
//           minimumSize: Size.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: textColor,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.height = 92,
    this.width = double.infinity,
    this.borderRadius = 91.27,
    this.borderColor,
    this.borderWidth = 1.4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
