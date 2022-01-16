import 'package:flutter/material.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/models/tables.dart';

enum CheckoutType{
  CASH,
  CARD,
}

class OrderNotifier extends ChangeNotifier {
  
  Order orderForTable = Order(order: []);
  
  void updateOrderForTable(Order newOrderForTable, {bool needNotify = true}){
    this.orderForTable = newOrderForTable;
    if(needNotify) notifyListeners();
  }
}
