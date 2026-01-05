import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceBidController extends GetxController {
  final amount = TextEditingController();
  final description = TextEditingController();
  
  final rxBidAmount = 0.0.obs;
  final taskFee = 0.10; // 10%
  
  @override
  void onInit() {
    super.onInit();
    amount.addListener(() {
      rxBidAmount.value = double.tryParse(amount.text) ?? 0.0;
    });
  }
  
  double get earnings => rxBidAmount.value * (1 - taskFee);
}
