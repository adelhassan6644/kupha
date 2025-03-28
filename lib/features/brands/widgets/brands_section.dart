import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kupha/features/brands/bloc/brands_bloc.dart';
import 'package:kupha/features/brands/model/brands_model.dart';
import 'package:kupha/features/brands/repo/brands_repo.dart';
import 'package:kupha/main_widgets/section_title.dart';
import 'package:kupha/navigation/custom_navigation.dart';
import 'package:kupha/navigation/routes.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';

import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import 'brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: title,
          withView: true,
          onViewTap: () => CustomNavigator.push(Routes.brands),
        ),
        BlocProvider(
          create: (context) => BrandsBloc(
              repo: sl<BrandsRepo>(),
              internetConnection: sl<InternetConnection>())
            ..add(Click(arguments: SearchEngine())),
          child: BlocBuilder<BrandsBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                List<BrandModel> list = state.list as List<BrandModel>;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        list.length,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: BrandCard(
                            model: list[i],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              if (state is Loading) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_SMALL.h),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CustomShimmerContainer(
                            height: 130.w,
                            width: 160.w,
                            radius: 20.w,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
                      ...List.generate(
                        5,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: BrandCard(
                            model: BrandModel(),
                          ),
                        ),
                      )
                    ],
                  ),
                );
                return SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
