import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfyn_task/views/login_page.dart';

import '../components/custom_list_tile.dart';
import '../models/mutual_fund_model.dart';
import '../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String id = "homePage";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences loginData;
  String email1 = '';
  ApiService client = ApiService();
  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      email1 = loginData.getString('email')!;
      print("${email1}the home page name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HDFC mutual fund data'),
        actions: [
          IconButton(
            onPressed: () async {
              loginData.setBool('login', true);
              await FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, Login.id);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 27,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Data>>(
        builder: (context, AsyncSnapshot<List<Data>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(
                "hello dev the snapshot error is: ${snapshot.error}"); //type NULL is not a subtype of String
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Data> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return customListTile(data[index], context);
              },
            );
          } else {
            return const Text("No data found.");
          }
        },
        future: client.getData(),
      ),
    );
  }
}
