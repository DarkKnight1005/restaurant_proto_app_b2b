import 'package:flutter/material.dart';
import 'package:restaurant_proto_app_b2b/services/API/orderer_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {

  OrderService orderService;
  IO.Socket? socket;

  SocketController({required this.orderService}){
    socket = IO.io('http://207.154.247.34:7388', IO.OptionBuilder()
      .setTransports(['websocket'])
      .setQuery({'tableNum': '-1'})
      .build());
    socket!.onConnect((_) {
      debugPrint('Connected to Socket');
    });
    socket!.on('newAction', (data) {
      debugPrint("newAction");
      if(orderService.homeNotifier.enteredTableID != null) orderService.getOrderedForTable(orderService.homeNotifier.enteredTableID!);
      orderService.getOrderedTables();
    });
    socket!.onDisconnect((_) => print('disconnect'));
  }
}