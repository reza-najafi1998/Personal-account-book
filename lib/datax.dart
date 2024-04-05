
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Userdata{
  final String id;
  final String name;
  final String phonenumber;
  final String dataAt;
  final String timeAt;


  Userdata(this.id, this.name, this.phonenumber, this.dataAt, this.timeAt);
  Userdata.fromjson(dynamic json):id=json['id'],name=json['name'],phonenumber=json['phone'],dataAt=json['date_at'],timeAt=json['time_at'];
  }


class HttpClient{
  static Dio instance=Dio(BaseOptions(
    baseUrl: 'http://192.168.1.10/apphesabnevis'
  ));
}



Future<dynamic> loginUser(String phonenumber,String password)async{
  final response=await HttpClient.instance.post('/login.php',data: {
    "phonenumber":phonenumber,
    "password":password,
  });
  if(response.statusCode==200){
    //final Userdata userdata=Userdata.fromjson(response);
    return response.data.toString();
  }else{
    return response.data.toString();
  }
}

Future<String> addNewPerson(String userid,String name,String amount,String info)async{
  final response=await HttpClient.instance.post('/new_person.php',data: {
    "userid":userid,
    "name":name,
    "amount":amount,
    "info":info,
  });
  if(response.statusCode==200){

    //final Userdata userdata=Userdata.fromjson(response);
    return response.data.toString();
  }else{
    return response.data.toString();
  }
}

