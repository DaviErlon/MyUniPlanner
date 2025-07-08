import 'package:flutter/services.dart';

void closeProgram() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}