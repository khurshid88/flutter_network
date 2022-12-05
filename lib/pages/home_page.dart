import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_network/services/log_service.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var text = "No data";

  _apiPostList() async {
    try {
      var response = await HttpService.GET(HttpService.API_POST_LIST, HttpService.paramsEmpty());
      setState(() {
        text = response!;
      });
    } catch (e) {
      LogService.e(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Networking"),
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Text(text),
          )),
    );
  }
}
