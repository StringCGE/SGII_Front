import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/view/mod_user/filter_list_user_widget.dart';

class MainModuleUser extends StatefulWidget {

  MainModuleUser({
    super.key,
  });

  @override
  MainModuleUserState createState() => MainModuleUserState();
}

class MainModuleUserState extends State<MainModuleUser> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainModuleUser oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('Lista de personas'),
              ],
            ),
            Expanded(
              child: FilterListUserWidget(
                selectedItem: (BuildContext context, ItemList<DbObj> item, void Function() fSetState) async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}