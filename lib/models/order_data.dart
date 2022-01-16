import 'package:meta/meta.dart';
import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
    Order({
        required this.order,
    });

    final List<OrderElement> order;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        order: List<OrderElement>.from(json["order"].map((x) => OrderElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order": List<dynamic>.from(order.map((x) => x.toJson())),
    };
}

class OrderElement {
    OrderElement({
        required this.productData,
        required this.count,
        required this.status,
    });

    final ProductData productData;
    final int count;
    final Status status;

    factory OrderElement.fromJson(Map<String, dynamic> json) => OrderElement(
        productData: ProductData.fromJson(json["productData"]),
        count: json["count"],
        status: statusValues.map[json["status"]]!,
    );

    Map<String, dynamic> toJson() => {
        "productData": productData.toJson(),
        "count": count,
        "status": statusValues.reverse[status],
    };
}

class ProductData {
    ProductData({
        required this.id,
        required this.title,
        required this.description,
        required this.photoUrl,
    });

    final int id;
    final String title;
    final String description;
    final String photoUrl;

    factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "photoUrl": photoUrl,
    };
}

enum Status { PREPARING, READY }

final statusValues = EnumValues({
    "preparing": Status.PREPARING,
    "ready": Status.READY
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String>? reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap!;
    }
}
