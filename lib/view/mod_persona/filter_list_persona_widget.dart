import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/util/common/item_list.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/search_list_widget.dart';
import 'package:sgii_front/view/mod_persona/create_edit_persona_widget.dart';
import 'package:sgii_front/view/mod_persona/item_persona_widget.dart';

class FilterListPersonaWidget extends StatefulWidget {
  final Future<void> Function(BuildContext filterListCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  FilterListPersonaWidget({
    super.key,
    required this.selectedItem,
  });

  @override
  FilterListPersonaWidgetState createState() => FilterListPersonaWidgetState();
}

class FilterListPersonaWidgetState extends State<FilterListPersonaWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Persona>> _searchListWidgetKey = GlobalKey<SearchListWidgetState<Persona>>();
  PersonaService serv = PersonaService();


  void reset(){

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void didUpdateWidget(covariant FilterListPersonaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return SearchListWidget<Persona>(
      key: _searchListWidgetKey,
      itemCard: (BuildContext context, ItemList<DbObj> item_) {
        return mostrarDatos(item_);
      },
      fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
        ResultOf<List<Persona>> result = await serv.fetchDataFind(
            offset,
            take,
            _nombreController.text.isEmpty ? null : _nombreController.text);
        return result;
      },
      finds: (BuildContext context) {
        return <Widget>[
          Container(
            width: 300,
            height: 60,
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ];
      },
      create: (BuildContext context) async {
        Result? res;
        await showDialog(
          context: context,
          builder: (BuildContext alertDialogContext){
            return AlertDialog(
              title: Text('Agregar Persona'),
              content: CreateEditPersonaWidget(
                  mostrarCancelar: true,
                  item:null,
                  result: (Result r){
                    res = r;
                    if (r.success){
                      Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                    }
                    //Navigator.of(context).pop();
                    //Navigator.pop(alertDialogContext);
                  }
              ),
            );
          },
        );
        if (res == null){
          return Result(success: false,);
        }
        return res!;
      },

    );
  }

  Widget mostrarDatos(ItemList<DbObj> item){
    return ItemPersonaWidget(
      item: item,
      listWidgetKey: null,
      searchListWidgetKey: _searchListWidgetKey,
      selectedItem: widget.selectedItem,
    );
  }
}