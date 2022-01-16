import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app_b2b/models/order_data.dart';
import 'package:restaurant_proto_app_b2b/models/std_response.dart';
import 'package:restaurant_proto_app_b2b/models/tables.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app_b2b/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app_b2b/services/API/base_service.dart';
import 'package:restaurant_proto_app_b2b/services/db_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class OrderService extends BaseService {

  final HomeNotifier homeNotifier;
  final OrderNotifier orderNotifier;

  OrderService({required this.homeNotifier, required this.orderNotifier}) : super('order');

  Future<Tables?> getOrderedTables() async {
    Tables? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.get(
        serviceUrl + "getOrdered/tables",
        options: _options,
      );
      
      _response = Tables.fromJson(_dioResponse.data);
      homeNotifier.updateTables(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<Order?> getOrderedForTable(int tableNum) async {
    Order? _response;
    try {
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.post(
        serviceUrl + "getOrdered/kitchen",
        options: _options,
        data: {
          "tableNum": tableNum
        }
      );
      
      _response = Order.fromJson(_dioResponse.data);
      orderNotifier.updateOrderForTable(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<StandartResponse?> changeStatusProduct(int tableNum, int productID) async {
    StandartResponse? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.post(
        serviceUrl + "changeStatus/product",
        options: _options,
        data: {
          "tableNum": tableNum,
          "productId": productID
        }
      );
      
      _response = StandartResponse.fromJson(_dioResponse.data);
      this.getOrderedForTable(tableNum);
      this.getOrderedTables();
      // orderNotifier.updateOrdered(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }


  Future<StandartResponse?> changeStatusOrder(int tableNum) async {
    StandartResponse? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.post(
        serviceUrl + "changeStatus/order",
        options: _options,
        data: {
          "tableNum": tableNum
        }
      );
      
      _response = StandartResponse.fromJson(_dioResponse.data);
      this.getOrderedTables();
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }
}