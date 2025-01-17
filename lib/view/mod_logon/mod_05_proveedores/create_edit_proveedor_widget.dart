class CreateEditCargoWidget extends StatefulWidget {
  final Cargo? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditCargoWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditCargoWidgetState createState() => CreateEditCargoWidgetState();
}

class CreateEditCargoWidgetState extends State<CreateEditCargoWidget> {
  final CargoService _serv = CargoService();
  bool estaEditando = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();


  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(Cargo? item) async {
    if (item != null){
      _nombreController.text = item.nombre;
      _detalleController.text = item.detalle;
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }



  Future<void> _guardar() async {
    Info info = Info();
    Result? r;
    if (_formKey.currentState?.validate() ?? false) {
      await info.showLoadingMask(context);


      try{
        if (estaEditando) {
          widget.item!.nombre = Parse.getString(_nombreController.text);
          widget.item!.detalle = Parse.getString(_detalleController.text);
          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, "Actualizacion de Cargo", "Cargo actualizado");
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, "Algo falló en la actualizacion del cargo");
          }
        } else {
          Cargo item_ = Cargo(
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            nombre: Parse.getString(_nombreController.text),
            detalle: Parse.getString(_detalleController.text),
            estado: Parse.getInt("1"),
            dtReg: DateTime.now(),
            idApi: 1,
            idPersReg: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, "Agregar Cargo", "Cargo agregado con exito");
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, "Algo falló al agregar el cargo");
          }
        }
      }catch(e){
        await info.hideLoadingMask(context);
        r = Result(
          success: false,
          errror: "",
          e: e,
        );
        info.showErrorDialogAsync(context, "Falló la conexion, intentelo de nuevo");
      }
    } else {
      await info.hideLoadingMask(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor corrija los errores')),
      );
      r = Result(
        success: false,
        errror: "Por favor corrija los errores",
      );
    }
    widget.result(r);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                controller: _nombreController,
                labelText: "Nombre",
                hintText: "Escriba el nombre",
                validator: validateNotEmpty,
              ),
              SizedBox(height: 16),
              TextWidget(
                controller: _detalleController,
                labelText: "Detalle",
                hintText: "Escriba el detalle",
                validator: validateNotEmpty,
              ),
              SizedBox(height: 16),
              Wrap(
                children: [
                  Padding(padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: _guardar,
                      child: Text(estaEditando ? "Actualizar Cargo" : "Guardar Cargo"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  if(widget.mostrarCancelar)Padding(padding:
                  const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: (){
                        widget.result(Result(
                          success: true,
                          message: "Se cancelo",
                          errror: "",
                        ));
                      },
                      child: const Text("Cancelar"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

}