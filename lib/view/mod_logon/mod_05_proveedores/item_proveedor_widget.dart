class ItemCargoWidget extends StatefulWidget {
  final ItemList<DbObj> item;
  final GlobalKey<SearchListWidgetState<Cargo>>? searchListWidgetKey;
  final GlobalKey<ListWidgetState<Cargo>>? listWidgetKey;
  final Future<void> Function(BuildContext context, ItemList<DbObj> item, void Function() fSetState) selectedItem;

  ItemCargoWidget({
    super.key,
    required this.item,
    required this.searchListWidgetKey,
    required this.listWidgetKey,
    required this.selectedItem,
  });

  ItemCargoWidgetState createState() => ItemCargoWidgetState();
}
class ItemCargoWidgetState extends State<ItemCargoWidget>{
  CargoService serv = CargoService();

  @override
  Widget build(BuildContext context) {
    Cargo value = widget.item.value as Cargo;
    widget.item.reset = (){
      if (mounted) {
        setState(() {});
      }
    };
    return GestureDetector(
      onTap: (){
        widget.selectedItem(context, widget.item, (){
          if (mounted) {
            setState(() {});
          }
        });
        //Navigator.pop(context);
        //Navigator.popUntil(showDialogContext, (route) => route.isFirst);
      },
      child: Card(
        color: widget.item.selected? Colors.blue[100]: null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${value.id} - (${value.idApi}) - ${value.nombre}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Estado: ${value.estado}'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Detalles del Cargo'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${value.id}'),
                              Text('ID API: ${value.idApi}'),
                              Text('Fecha de Registro: ${value.dtReg}'),
                              Text('Registrado por: ${value.idPersReg}'),
                              Text('Estado: ${value.estado}'),
                              Text('Nombre: ${value.nombre}'),
                              Text('Detalle: ${value.detalle}'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  Result? res;
                  await showDialog(
                    context: context,
                    builder: (BuildContext alertDialogContext) {
                      return AlertDialog(
                        title: const Text('Editar Cargo'),
                        content: CreateEditCargoWidget(
                          mostrarCancelar: true,
                          item: value,
                          result: (Result r) {
                            res = r;
                            if (r.success) {
                              widget.searchListWidgetKey?.currentState?.resetGuardaPosLista();
                              widget.listWidgetKey?.currentState?.resetGuardaPosLista();
                              Navigator.popUntil(alertDialogContext, (route) => route.isFirst);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  Info info = Info();
                  await info.showLoadingMask(context);
                  Result res = await serv.deleteItem(value);
                  await info.hideLoadingMask(context);
                  if (res.success) {
                    widget.searchListWidgetKey?.currentState?.resetGuardaPosLista();
                    widget.listWidgetKey?.currentState?.resetGuardaPosLista();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}