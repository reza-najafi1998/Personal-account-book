import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class DataUser extends HiveObject {
  @HiveField(0)
  String phoneNumber = '';
  @HiveField(1)
  String name = '';
}

@HiveType(typeId: 1)
class Accounts extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String name = '';

  static int _nextId = 1;

  Accounts() {
    this.id = _nextId; // مقداردهی خودکار id به مقدار nextId
    _nextId++; // افزایش مقدار nextId برای نمونه بعدی
  }
}

@HiveType(typeId: 2)
class Transactions extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  bool status = true;
  @HiveField(2)
  int price = 0;
  @HiveField(3)
  String description = '';
  @HiveField(4)
  String date = '';
  @HiveField(5)
  String time = '';
}
