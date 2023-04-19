// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

Random random = Random();

String generateRandomHexColor() {
  int length = 6;
  String chars = '0123456789ABCDEF';
  String hex = '#';
  while (length-- > 0) hex += chars[(random.nextInt(16)) | 0];
  return hex;
}
