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
  @HiveField(2,defaultValue: '')
  String phone = '';

  static int _nextId = 1;

  Accounts() {
    initializeNextId();
    this.id = _nextId; // مقداردهی خودکار id به مقدار nextId
    _nextId++; // افزایش مقدار nextId برای نمونه بعدی
  }
  void initializeNextId() async {
    var box = await Hive.openBox<Accounts>('Accounts');
    var accounts = box.values.toList();
    if (accounts.isNotEmpty) {
      _nextId = accounts.map((account) => account.id).reduce((a, b) => a > b ? a : b) + 1;
    }
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
