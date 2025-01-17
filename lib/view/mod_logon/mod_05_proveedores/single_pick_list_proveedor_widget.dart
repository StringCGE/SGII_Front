class SinglePickListCargoWidget extends StatefulWidget {
  Cargo? Function() getItem;
  void Function(Cargo? item) setItem;
  SinglePickListCargoWidget({
    super.key,
    required this.getItem,
    required this.setItem,
  });

  @override
  SinglePickListCargoWidgetState createState() => SinglePickListCargoWidgetState();
}

class SinglePickListCargoWidgetState extends State<SinglePickListCargoWidget> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final GlobalKey<SearchListWidgetState<Cargo>> _searchListCargoWidgetKey = GlobalKey<SearchListWidgetState<Cargo>>();
  Cargo itemSelect = Cargo.empty();
  CargoService servCargo = CargoService();

  @override
  void initState() {
    super.initState();
    value = widget.getItem();
    if (value != null){
      _itemController.text = value!.nombre;
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }
  Cargo? value;
  List<ItemList<DbObj>> lItemPickList = [];
  @override
  Widget build(BuildContext context) {
    return PickListWidget(
        lItemPickList: lItemPickList,
        labelText: 'Cargo',
        hintText: 'Seleccione una persona',
        validator: validateNotEmpty,
        filterList: (BuildContext context, Future<void> Function() onSetState) {
          return SearchListWidget<Cargo>(
            key: _searchListCargoWidgetKey,
            itemCard: (BuildContext context, ItemList<DbObj> item_) {
              ItemList<DbObj> encontrado = lItemPickList.firstWhere(
                    (item){
                  if (item.value.idApi >= 0){
                    return item.value.idApi == item_.value.idApi;
                  }else{
                    return item.value.id == item_.value.id;
                  }
                },
                orElse: () => ItemList<DbObj>( value: Cargo.empty()),
              );
              if (encontrado.value.estado != Cargo.empty().estado){
                item_.selected = encontrado.selected;
              }else{
                item_.selected = false;
              }
              return ItemCargoWidget(
                item: item_,
                listWidgetKey: null,
                searchListWidgetKey: _searchListCargoWidgetKey,
                selectedItem: (BuildContext itemCargoWidgetContext, ItemList<DbObj> item, void Function() fSetState) async {
                  item.selected = !item.selected;
                  ItemList<DbObj>? itemAnt;
                  if (lItemPickList.isNotEmpty){
                    itemAnt = lItemPickList.elementAt(0);
                    itemAnt.selected = false;
                  }
                  if (item.selected){
                    lItemPickList.clear();
                    lItemPickList.add(item);
                    widget.setItem(item.value as Cargo);
                  }else{
                    lItemPickList.remove(item);
                  }
                  fSetState();
                  _searchListCargoWidgetKey.currentState?.resetGuardaPosLista();
                },
              );
            },
            fetchData: (DateTime offset, int take, bool forceRefresh, Future<void> Function() reset) async {
              ResultOf<List<Cargo>> result = await servCargo.fetchDataFind(
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
                    title: Text('Agregar Cargo'),
                    content: CreateEditCargoWidget(
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
        },
        selectedItemCard: (BuildContext pickListWidget,  ItemList<DbObj> item_){
          Cargo value = item_.value as Cargo;
          return Card(
            elevation: 4,
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                value.nombre,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
    );
  }
}