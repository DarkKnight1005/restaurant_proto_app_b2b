import 'package:after_layout/after_layout.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/Globals/appColors.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/services/API/orderer_service.dart';
import 'package:restaurant_proto_app_b2b/widgets/helpWidgets/animted_text_fade.dart';
import 'package:restaurant_proto_app_b2b/widgets/helpWidgets/distance_determiner.dart';
import 'package:restaurant_proto_app_b2b/widgets/helpWidgets/fadeOut_bound.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/badget_button.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/icon_button_bg.dart';
import 'package:flutter/scheduler.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/product_item.dart';
import 'package:restaurant_proto_app_b2b/widgets/home/table_item.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home>, SingleTickerProviderStateMixin{

  bool isSelected = false;
  bool isActive = false;
  Function? startTimer;
  HomeNotifier? homeNotifier;
  OrderNotifier? orderNotifier;
  GlobalKey<DistanceDeterminerState> distanceDeterminer = GlobalKey();
  OrderService? orderService;
  ScrollController scrollController = ScrollController();

  
  @override
  void afterFirstLayout(BuildContext context) async{
    orderService = OrderService(homeNotifier: homeNotifier!, orderNotifier: orderNotifier!);
    await orderService?.getOrderedTables();
    homeNotifier!.distanceDeterminer = distanceDeterminer;
    // homeNotifier!.scrollController = scrollController;
    
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  )
  .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));


  late final Tween<Offset> _offsetAnimation11 = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  );
  // final animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1)).animate(_controller);

  int getCountOfNeedAction(){
    int allUnreadyProducts = 0;
    for (var item in homeNotifier!.tables.tables) {
      if(item.isNeedCheckout || item.isNewOrderAvailable){
        allUnreadyProducts++;
      }
    }
    return allUnreadyProducts;
  }

  Widget labelsTablesScreen(){
    return Container(
      height: 70,
      // width: 700,
      decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Row(
          children: [
            Text(
              "Active Tables: ",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              homeNotifier!.tables.tables.length.toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textBlack),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: VerticalDivider(width: 1, thickness: 1, color: Colors.grey[350]),
            ),
            Text(
              "Need Action: ",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              getCountOfNeedAction().toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textBlack),
            ),
          ],
        ),
      )
    );
  }

  Widget lablesEnteredTableScreen(){
    return Container(
      height: 70,
      // width: 700,
      decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Row(
          children: [
            Text(
              "Unready Products: ",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              homeNotifier!.tables.tables[homeNotifier!.tables.tables.indexWhere((element) => element.id == homeNotifier!.enteredTableID)].numOfPreparing.toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textBlack),
            ),
          ],
        ),
      )
    );
  }
  

  Widget getHeader(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Row(
          children: [
            IconButtonBG(
              onPress: (){
                if(homeNotifier!.screenType != ScreenType.TABLES){
                  homeNotifier!.updateScreenType(ScreenType.TABLES, orderNotifier: orderNotifier);
                }else{
                  orderService?.getOrderedTables();
                }
              },
              hasFeedback: homeNotifier!.screenType != ScreenType.TABLES,
              icon: homeNotifier!.screenType == ScreenType.TABLES ? FontAwesome5.first_order_alt : Icons.arrow_back_ios_new_rounded,
              iconColor: AppColors.textGrey, 
              scaleFactor: 0.7,
              iconSize: 45,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: AnimatedFadeOutIn<String>(
                  initialData: "Tables",
                  data: homeNotifier!.screenType == ScreenType.TABLES ? "Tables" : "Table #" + homeNotifier!.enteredTableID.toString(),
                  builder: (value) =>  
                  Text(
                    value,
                    style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                  ),
              ),
            ),
            Expanded(child: Container(height: 0,)),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: homeNotifier!.screenType == ScreenType.TABLES
              ? labelsTablesScreen()
              : lablesEnteredTableScreen()
            )
          ],
        ),
      ),
    );
  }

  Widget getTables(){
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: DistanceDeterminer(
              key: distanceDeterminer,
              getDistance: (distance){
                debugPrint("Distance --> " + distance.toString());
                homeNotifier!.updateDeltaDistanceMain(distance);
              }
            ),
          ),
          SizedBox(
            height: homeNotifier!.deltaDistanceMain == null ? (MediaQuery.of(context).size.height * .817) : (MediaQuery.of(context).size.height - homeNotifier!.deltaDistanceMain!),
            width: double.infinity,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 60, bottom: 40),
                child: 
                homeNotifier!.screenType == ScreenType.TABLES
                ? Wrap(
                  spacing: 65,
                  runSpacing: 65,
                  // alignment: WrapAlignment.spaceBetween,
                  children: 
                  [
                    for (var index = 0; index < homeNotifier!.tables.tables.length; index++) ...[
                      TableItem(
                        tableElement: homeNotifier!.tables.tables[index],
                        onPress: (tableId){
                          homeNotifier!.tables.tables[index].isNeedCheckout
                          ? homeNotifier!.updateSelectedTableID(tableId)
                          : homeNotifier!.tables.tables[index].numOfPreparing != 0
                          ? homeNotifier!.updateScreenType(ScreenType.ORDER, newEnteredTableID: tableId, orderService: orderService)
                          // ignore: unnecessary_statements
                          : null;
                        }, 
                        onEdgeTap: (tableId){
                          homeNotifier!.updateSelectedTableID(-1);
                        }, 
                        isActive: homeNotifier!.selectedTableID == homeNotifier!.tables.tables[index].id
                      )
                    ]
                  ],
                )
                : Wrap(
                  spacing: 55,
                  runSpacing: 55,
                  children: 
                  [
                    for (var index = 0; index < orderNotifier!.orderForTable.order.length; index++) ...[
                      ProductItem(
                        orderElement: orderNotifier!.orderForTable.order[index], 
                        onPress: (productID){
                          if(orderNotifier!.orderForTable.order[index].status == Status.PREPARING)
                          homeNotifier!.updateSelectedProductID(productID);
                        }, 
                        onEdgeTap: (productID){
                          homeNotifier!.updateSelectedProductID(-1);
                        }, 
                        isActive: homeNotifier!.selectedProductID == orderNotifier!.orderForTable.order[index].productData.id 
                        && orderNotifier!.orderForTable.order[index].status == Status.PREPARING,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          homeNotifier!.checkCanScroll(scrollController.hasClients ? scrollController.position : null)
          ? FadeoutBound(height: 35)
          : Container(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

   homeNotifier = Provider.of<HomeNotifier>(context);
   orderNotifier = Provider.of<OrderNotifier>(context);

  return Scaffold(
    backgroundColor: AppColors.textWhite,
    body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: Column(
        children: [
          getHeader(),
          getTables(),
          // getTables(),
        ],
      )
    ),
  );
}
}