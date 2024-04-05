import 'package:flutter/foundation.dart';
import 'package:payment/data/sourse/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource{
  final DataSource<T> localDataSourse;
  Repository(this.localDataSourse);

  @override
  Future createOrSave(data) async{
    final result=await localDataSourse.createOrSave(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(data) async{
    await localDataSourse.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async{
    await localDataSourse.deleteById(id);
    notifyListeners();
  }

  @override
  Future<void> deleteall() async{
    await localDataSourse.deleteall();
    notifyListeners();
  }

  @override
  Future<List> getall({String searchKeyword=''}) async{
    return localDataSourse.getall(searchKeyword: searchKeyword);

  }

}