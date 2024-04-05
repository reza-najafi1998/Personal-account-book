import 'package:hive_flutter/hive_flutter.dart';
import 'package:payment/data/sourse/source.dart';

class HivePymentSourcs implements DataSource<dynamic>{
  final Box<dynamic> box;
  HivePymentSourcs(this.box);

  @override
  Future<dynamic> createOrSave(dynamic data) async{
  if(data.isInBox){
    data.save();
  }else{
    data.id=await box.add(data);
  }
  return data;
  }

  @override
  Future<void> delete(dynamic data) async {
    return data.delete();
  }

  @override
  Future<void> deleteById(id) async{
    return box.delete(id);
  }

  @override
  Future<void> deleteall() async{
    box.clear();
  }

  @override
  Future<List> getall({String searchKeyword=''}) async{
    if(searchKeyword.isNotEmpty){
      return box.values.where((element) => element.name.contains(searchKeyword)).toList();
    }else{
      return box.values.toList();
    }
  }

}