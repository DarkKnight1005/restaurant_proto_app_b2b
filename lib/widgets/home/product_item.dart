import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/Globals/appColors.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/item_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/services/API/orderer_service.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/icon_button_bg.dart';

class ProductItem extends StatelessWidget {

  final OrderElement orderElement;
  final Function(int productID) onPress;
  final Function(int productID) onEdgeTap;
  final bool isActive;

  ProductItem({
    Key? key,
    required this.orderElement,
    required this.onPress,
    required this.onEdgeTap,
    required this.isActive
    }) : super(key: key);

    OrderNotifier? orderNotifier;
    HomeNotifier? homeNotifier;

  @override
  Widget build(BuildContext context) {
    
    orderNotifier = Provider.of<OrderNotifier>(context);
    homeNotifier = Provider.of<HomeNotifier>(context);
    
    return ChangeNotifierProvider<ItemNotifier>(
      create: (context) => ItemNotifier(),
      builder: (context, wg) => Consumer<ItemNotifier>(
        builder: (context, itemNotifier, child) {
          return Container(
            height: 258,
            width: 378,
            child:
                ScaleTap(
                  enableFeedback: !isActive ? true : false,
                  scaleMinValue: !isActive ? 0.85 : 1,
                  opacityMinValue: 1,
                  onPressed: !isActive ? (){
                    onPress(orderElement.productData.id);
                  } : (){},
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 245,
                          width: 365,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(35.0)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 90.0,
                                color: Colors.grey[350]!,
                              ),
                            ]
                          ),
                          // margin: const EdgeInsets.fromLTRB(24, 100, 1040, 10), //Defining The margins of the panel where 1040 helping to define proper width of the panel
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 45,
                                    left: 6,
                                    child: Container(
                                      height: 100,
                                      width: 160,
                                      child: Text(
                                        orderElement.productData.description,
                                        style: TextStyle(fontSize: 14, color: AppColors.textGrey.withOpacity(0.75)),
                                      ),
                                    )
                                  ),
                                  Positioned(
                                    left: 6,
                                    top: 0,
                                    child: Container(
                                      child: Text(
                                        orderElement.productData.title,
                                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ),
                                  Positioned(
                                    left: 6,
                                    bottom: 0,
                                    child: Container(
                                      child: Text(
                                        "Count: " + orderElement.count.toString(),
                                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    )
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35.0),
                                      child: Container(
                                        height: 130,
                                        width: 130,
                                        child: CachedNetworkImage(
                                          imageUrl: orderElement.productData.photoUrl,
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                              )
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      Offstage(
                  offstage: !isActive,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: AnimatedOpacity(
                      opacity: isActive ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        height: 245,
                        width: 365,
                        decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.75),
                            borderRadius: BorderRadius.all(Radius.circular(35.0)),
                          ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: Container(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: (){onEdgeTap(orderElement.productData.id);},
                                    child: Container(
                                      color: Colors.transparent,
                                    )
                                  ),
                                  Center(
                                    child: FlatButtonCustom(
                                      title: "Ready",
                                      textColor: AppColors.textBlack,
                                      bg: AppColors.textWhite,
                                      innerHorizontalPadding: 20,
                                      innerVerticalPadding: 20,
                                      borderRadius: 20,
                                      onPress: (){
                                        OrderService(homeNotifier: homeNotifier!, orderNotifier: orderNotifier!).changeStatusProduct(homeNotifier!.enteredTableID!, orderElement.productData.id);
                                        homeNotifier!.updateSelectedProductID(-1);
                                      }
                                    )
                                  )
                                ],
                              ),
                            ),
                        )
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: orderElement.status == Status.READY,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryRed,
                    ),
                  ),
                )
                    ],
                  ),
                ),
          );
        }
      ),
    );
  }
}