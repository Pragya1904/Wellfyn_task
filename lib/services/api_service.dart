
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:wellfyn_task/models/mutual_fund_model.dart';

class ApiService
{
  //added the api endpoint from the newsapi.org documentation
  final apiEndpoint="https://api.mfapi.in/mf/119063";

  //step 2: http request function--> for this add dependency of http in pubspec.yaml --->http package
  Future<List<Data>> getData() async{
    print("getData method called");
    final  res=await http.get(Uri.parse(apiEndpoint));
    print("getData method called 222");
    print(res.statusCode);
    if(res.statusCode==200)
    {

      Map<String,dynamic> json=jsonDecode(res.body);

      //body is a list of articles in json
      List<dynamic> body1=json['data'];
      print("data recieved successfully!!");
      //below line is written to get different articles from the json file and puts them into a list named articles
      // print(body);
      // List<Article> articles=
      //  body.map((dynamic item) => Article.fromJson(item)).toList();
      final List<dynamic> body = jsonDecode(res.body)['data'];
      print(body);
      print("****************************************************");
      print(body1);
      List<Data> data =
      body.map((dynamic item) => Data.fromJson(item)).toList();
      print("-------------------------------------------------");
      print(data);
      return data;
      //step 3: call this service from home page
    }
    else
    {
      print("data recieved unsuccessfully!!");
      throw("Couldn't fetch the data");
    }

  }

}