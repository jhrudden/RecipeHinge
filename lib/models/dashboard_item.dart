import 'package:flutter/cupertino.dart';

import '../infrastructure/overall/repositories/database.dart';

class DashBoardItem {
  final Icon icon;
  final String title;
  final String subText;
  final Function(BuildContext, DatabaseService) onTap;

  DashBoardItem(
      {@required this.icon,
      @required this.title,
      @required this.subText,
      @required this.onTap});
}
