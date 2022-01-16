import 'package:meta/meta.dart';
import 'dart:convert';

Tables tablesFromJson(String str) => Tables.fromJson(json.decode(str));

String tablesToJson(Tables data) => json.encode(data.toJson());

class Tables {
    Tables({
        required this.tables,
    });

    final List<TableData> tables;

    factory Tables.fromJson(Map<String, dynamic> json) => Tables(
        tables: List<TableData>.from(json["tables"].map((x) => TableData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tables": List<dynamic>.from(tables.map((x) => x.toJson())),
    };
}

class TableData {
    TableData({
        required this.id,
        required this.isNewOrderAvailable,
        required this.isNeedCheckout,
        required this.neededCheckoutType,
        required this.numOfPreparing,
    });

    final int id;
    final bool isNewOrderAvailable;
    final bool isNeedCheckout;
    final String neededCheckoutType;
    final int numOfPreparing;

    factory TableData.fromJson(Map<String, dynamic> json) => TableData(
        id: json["_id"],
        isNewOrderAvailable: json["isNewOrderAvailable"],
        isNeedCheckout: json["isNeedCheckout"],
        neededCheckoutType: json["neededCheckoutType"],
        numOfPreparing: json["numOfPreparing"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "isNewOrderAvailable": isNewOrderAvailable,
        "isNeedCheckout": isNeedCheckout,
        "neededCheckoutType": neededCheckoutType,
        "numOfPreparing": numOfPreparing,
    };
}
