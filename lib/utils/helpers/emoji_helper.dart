import 'package:flutter/material.dart';

class EmojiHelper {
  static IconData getIndustryIcon(String industry) {
    switch (industry) {
      case 'Technologie':
        return Icons.computer;
      case 'Gesundheit':
        return Icons.health_and_safety;
      case 'Bildung':
        return Icons.school;
      case 'Finanzen':
        return Icons.account_balance;
      case 'Einzelhandel':
        return Icons.shopping_cart;
      case 'Online':
        return Icons.web;
      default:
        return Icons.business;
    }
  }
}
