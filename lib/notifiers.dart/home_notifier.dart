import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_proto_app_b2b/models/auth_dto.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/models/tables.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/services/API/orderer_service.dart';
import 'package:restaurant_proto_app_b2b/services/db_service.dart';
import 'package:restaurant_proto_app_b2b/widgets/helpWidgets/distance_determiner.dart';

enum ScreenType{
  TABLES,
  ORDER
}

class HomeNotifier extends ChangeNotifier {
  
  int? selectedTableID;
  int? selectedProductID;
  int? enteredTableID;
  // int? selectedProductID;

  double? deltaDistanceMain;

  double opacity = 0;
  int panelNum = 0;

  GlobalKey<DistanceDeterminerState>? distanceDeterminer;

  Tables tables = Tables(tables: []);

  ScreenType screenType = ScreenType.TABLES;

  bool checkCanScroll(ScrollPosition? scrollController){
    bool isScrollable = scrollController != null ? (scrollController.maxScrollExtent > 0) : true;//products.products.length > 6;
    // bool isScrollable = scrollController != null ? (scrollController!.position.maxScrollExtent > 0) : true;
    return isScrollable;
  }

  void updateTables(Tables newTables, {bool needNotify = true}){
    tables = newTables;
    if (needNotify) notifyListeners();
  }

  void updateDeltaDistanceMain(double newDistance){
    deltaDistanceMain = newDistance;
    notifyListeners();
  }

  void updateOpacity(double newOpacity){
    opacity = newOpacity;
    notifyListeners();
  }

  void updateSelectedTableID(int newTableId){
    this.selectedTableID = newTableId;
    notifyListeners();
  }

  void updateScreenType(ScreenType newScreenType, {int? newEnteredTableID, OrderService? orderService, OrderNotifier? orderNotifier}){
    this.screenType = newScreenType;
    this.enteredTableID = newEnteredTableID;
    if(newScreenType == ScreenType.TABLES) orderNotifier!.updateOrderForTable(Order(order: []));
    if(newEnteredTableID != null) orderService!.getOrderedForTable(newEnteredTableID);
    notifyListeners();
  }

  void updateSelectedProductID(int newProductID){
    this.selectedProductID = newProductID;
    notifyListeners();
  }


}
