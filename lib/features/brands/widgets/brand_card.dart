import 'package:flutter/material.dart';
import 'package:kupha/app/core/dimensions.dart';
import 'package:kupha/components/custom_network_image.dart';
import 'package:kupha/features/categories/model/categories_model.dart';
import '../../../app/core/styles.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../model/brands_model.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.model});
  final BrandModel model;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: CustomNetworkImage.containerNewWorkImage(
        image: model.image ?? "",
        width: 80.w,
        height: 80.w,
        radius: 20.w,
        borderColor: Styles.LIGHT_BORDER_COLOR,
        onTap: () {},
      ),
    );
  }
}
