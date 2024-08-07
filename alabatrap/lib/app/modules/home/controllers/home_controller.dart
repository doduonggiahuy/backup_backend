import 'dart:convert';

import 'package:alabatrap/app/data/models/shoes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxList<Shoes> shoesList = RxList<Shoes>();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await fetchShoes();
  }

  void suffixTap() {
    searchController.clear();
  }

  void submitTap(String value) {
    debugPrint("Search submitted: $value");
  }

  Future<void> fetchShoes() async {
    final response = await http.get(
      Uri.parse('https://shoes-collections.p.rapidapi.com/shoes'),
      headers: {
        'x-rapidapi-host': 'shoes-collections.p.rapidapi.com',
        'x-rapidapi-key': '9b9bd68283mshb2be753c746ac2ap143141jsna78819b24ba5',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      shoesList.value = data.map((item) => Shoes.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shoes');
    }
  }
}
