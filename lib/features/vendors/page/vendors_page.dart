import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kupha/app/core/extensions.dart';
import 'package:kupha/app/localization/language_constant.dart';
import 'package:kupha/components/custom_app_bar.dart';
import 'package:kupha/features/categories/model/categories_model.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/grid_list_animator.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/search_engine.dart';
import '../bloc/vendors_bloc.dart';
import '../model/vendors_model.dart';
import '../repo/vendors_repo.dart';
import '../widgets/vendor_card.dart';

class VendorsPage extends StatelessWidget {
  const VendorsPage({super.key, this.model});
  final CategoryModel? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("vendors")),
      body: BlocProvider(
        create: (context) => VendorsBloc(
            repo: sl<VendorsRepo>(),
            internetConnection: sl<InternetConnection>())
          ..add(
            Click(
              arguments: SearchEngine(
                query: {
                  if (model?.id != null) "${model?.type}": model?.id,
                  if (model?.isVendor == false) "brand_id": model?.vendorId,
                },
              ),
            ),
          ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
              Expanded(
                child: BlocBuilder<VendorsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return GridListAnimatorWidget(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        aspectRatio: 1.1,
                        controller: context.read<VendorsBloc>().controller,
                        items: List.generate(
                          12,
                          (i) => CustomShimmerContainer(
                            height: 130.h,
                            width: context.width,
                            radius: 20.w,
                          ),
                        ),
                      );
                    }
                    if (state is Done) {
                      List<VendorModel> list = state.list as List<VendorModel>;
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context.read<VendorsBloc>().add(Click(
                                  arguments: SearchEngine(
                                query: {
                                  if (model != null)
                                    "${model?.type}": model?.id,
                                },
                              )));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: GridListAnimatorWidget(
                                controller:
                                    context.read<VendorsBloc>().controller,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                aspectRatio: 1.1,
                                items: List.generate(
                                  list.length,
                                  (i) => VendorCard(
                                    model: list[i],
                                  ),
                                ),
                              ),
                            ),
                            CustomLoadingText(loading: state.loading),
                          ],
                        ),
                      );
                    }
                    if (state is Error || state is Empty) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context.read<VendorsBloc>().add(Click(
                                  arguments: SearchEngine(
                                query: {
                                  if (model != null)
                                    "${model?.type}": model?.id,
                                },
                              )));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                controller:
                                    context.read<VendorsBloc>().controller,
                                customPadding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_DEFAULT.h),
                                data: [
                                  SizedBox(height: 50.h),
                                  EmptyState(
                                      txt: state is Error
                                          ? getTranslated(
                                              "something_went_wrong")
                                          : null),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {},
                        child: Column(
                          children: [
                            Expanded(
                              child: GridListAnimatorWidget(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                aspectRatio: 1.1,
                                controller:
                                    context.read<VendorsBloc>().controller,
                                items: List.generate(
                                  15,
                                  (i) => VendorCard(
                                    model: VendorModel(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
