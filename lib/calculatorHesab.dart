import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/data.dart';


class CalculatorHesab {
  final Box<Accounts> acc;
  final Box<Transactions> trx;

  CalculatorHesab(this.acc, this.trx);

  void fullacc(String searchKeyword) {
    List<Accounts> acc_names = [];
    for (var data in acc.values.where((element) => element.name.contains(searchKeyword))
          .toList()) {
      print(data.name);
    }
  }

  int bedehi() {
    int bedehi = 0;
    for (var data in acc.values) {
      int temp = fullhesabperson(data.id);
      temp < 0 ? bedehi = bedehi + temp : null;
    }
    return bedehi;
  }

  int talab() {
    int talab = 0;
    for (var data in acc.values) {
      int temp = fullhesabperson(data.id);
      temp > 0 ? talab = talab + temp : null;
    }

    return talab;
  }

  int fullhesabperson(int id) {
    int temp = 0;
    for (var element in trx.values) {
      element.id == id
          ? element.status
              ? temp = temp + element.price
              : temp = temp - element.price
          : null;
    }
    return temp;
  }

  String lastdatetrx(int id) {
    String lastdate = '';
    for (var element in trx.values) {
      if (element.id.toString() == id.toString()) {
        lastdate = element.date;
      }
      //element.id==id?element.status?temp=temp+element.price:temp=temp-element.price:null;
    }
    return lastdate;
  }
}
