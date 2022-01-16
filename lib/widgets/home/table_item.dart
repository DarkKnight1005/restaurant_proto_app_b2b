import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/Globals/appColors.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/models/tables.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/item_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/services/API/orderer_service.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/icon_button_bg.dart';

class TableItem extends StatelessWidget {

  final TableData tableElement;
  final Function(int productID) onPress;
  final Function(int productID) onEdgeTap;
  final bool isActive;

  TableItem({
    Key? key,
    required this.tableElement,
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
            height: 300,
            width: 260,
            child:
                ScaleTap(
                  enableFeedback: !isActive ? true : false,
                  scaleMinValue: !isActive ? 0.85 : 1,
                  opacityMinValue: 1,
                  onPressed: !isActive ? (){
                    onPress(tableElement.id);
                  } : (){},
                  child: Stack(
                    children: [
                      Container(
                        height: 300,
                        width: 260,
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
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                        child: Text(
                                          "Table #" + tableElement.id.toString(),
                                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ),
                                ),
                                SizedBox(height: 35,),
                                Container(
                                  height: 160,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: tableElement.isNeedCheckout || tableElement.isNewOrderAvailable ? AppColors.primary : AppColors.bg,
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  child: tableElement.isNeedCheckout
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Checkout",
                                          style: TextStyle(
                                            fontSize: 22, 
                                            fontWeight: FontWeight.bold, 
                                            color: AppColors.textWhite
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 14),
                                        child: Icon(
                                          tableElement.neededCheckoutType.toLowerCase() == "cash" ? FontAwesome5.money_bill_wave : FontAwesome.credit_card_alt,
                                          color: AppColors.textWhite,
                                          size: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          tableElement.neededCheckoutType.toLowerCase() == "cash" ? "Cash" : "Card",
                                          style: TextStyle(
                                            fontSize: 22, 
                                            fontWeight: FontWeight.bold, 
                                            color: AppColors.textWhite,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Unready",
                                          style: TextStyle(
                                            fontSize: 24, 
                                            fontWeight: FontWeight.bold, 
                                            color: tableElement.isNewOrderAvailable ? AppColors.textWhite : AppColors.textBlack
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              tableElement.numOfPreparing.toString(),
                                              style: TextStyle(
                                                fontSize: 52, 
                                                fontWeight: FontWeight.bold, 
                                                color: tableElement.isNewOrderAvailable ? AppColors.textWhite : AppColors.textBlack
                                              ),
                                            ),
                                          ),
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          )
                        ),
                      ),
                      Offstage(
                  offstage: !isActive,
                  child: AnimatedOpacity(
                    opacity: isActive ? 1 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      height: 300,
                      width: 260,
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
                                  onTap: (){onEdgeTap(tableElement.id);},
                                  child: Container(
                                    color: Colors.transparent,
                                  )
                                ),
                                Center(
                                  child: FlatButtonCustom(
                                    title: "Complete",
                                    textColor: AppColors.textBlack,
                                    bg: AppColors.textWhite,
                                    innerHorizontalPadding: 20,
                                    innerVerticalPadding: 20,
                                    borderRadius: 20,
                                    onPress: (){
                                      OrderService(homeNotifier: homeNotifier!, orderNotifier: orderNotifier!).changeStatusOrder(tableElement.id);
                                      homeNotifier!.updateSelectedTableID(-1);
                                    }
                                  )
                                )
                              ],
                            ),
                          ),
                      )
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