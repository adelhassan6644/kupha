import 'package:flutter/material.dart';
import 'package:kupha/app/core/dimensions.dart';
import 'package:kupha/app/core/extensions.dart';
import '../app/core/styles.dart';
import '../components/custom_images.dart';

class CustomTabButton extends StatelessWidget {
  const CustomTabButton({
    required this.label,
    this.fontSize = 16,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.svgIcon,
  });
  final double fontSize;
  final String label;
  final bool isSelected;
  final Function() onTap;
  final String? svgIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL.w,
        ),
        decoration: const BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 1, color: Styles.LIGHT_BORDER_COLOR))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (svgIcon != null) ...[
                  customImageIconSVG(
                    imageName: svgIcon!,
                    color: isSelected
                        ? Styles.WHITE_COLOR
                        : Styles.WHITE_COLOR.withOpacity(.5),
                  ),
                  SizedBox(width: 4.w),
                ],
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Styles.PRIMARY_COLOR
                        : Styles.DETAILS_COLOR,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.zero,
              width: context.width,
              height: 4,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: isSelected ? Styles.PRIMARY_COLOR : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
