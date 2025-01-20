import 'package:flutter/material.dart';
import 'package:sgii_front/service/auth_service.dart';

class Nav{
  static Future<void> navPop({
    required BuildContext context,
  }) async {
    actualScreen.removeLast();
    if(actualScreen.length>0){
      AuthService.saveRuta(actualScreen.last);
    }
    Navigator.pop(context);
  }
  static bool navCanPop({
    required BuildContext context,
  }) {
    return Navigator.canPop(context);
  }
  static Future<void> navDropAll({
    required BuildContext context,
    required Widget Function() next,
    required String settingName,
    required dynamic settingArg
  }) async {
    actualScreen.clear();
    actualScreen.add(settingName);
    AuthService.saveRuta(actualScreen.last);
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => next(),
          settings: RouteSettings(
            name: settingName,
            arguments: settingArg,
          )
      ),
          (Route<dynamic> route) => false,
    );
  }
  static Future<void> navDropUpToWidget({
    required BuildContext context,
    required Widget Function() next,
    required String stopWidgetName,
    required String settingName,
    required dynamic settingArg
  }) async {
    actualScreen.clear();
    actualScreen.add(settingName);
    AuthService.saveRuta(actualScreen.last);
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => next(),
          settings: RouteSettings(
            name: settingName,
            arguments: settingArg,
          )
      ),
          (Route<dynamic> route) {
        if(route.settings.name == null) return false;
        return route.settings.name == stopWidgetName;
      },
    );
  }
  static Future<void> push({
    required BuildContext context,
    required Widget Function() next,
    required String settingName,
    required dynamic settingArg
  }) async {
    actualScreen.add(settingName);
    AuthService.saveRuta(actualScreen.last);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => next(),
          settings: RouteSettings(
            name: settingName,
            arguments: settingArg,
          )
      ),
    );
  }
  static List<String> actualScreen = [];
}