import 'package:flutter/material.dart';
import 'package:sgii_front/model/cls_user.dart';
import 'package:sgii_front/service/serv_user.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/parse.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/date_widget.dart';
import 'package:sgii_front/util/my_widget/text_widget.dart';

import 'package:sgii_front/model/cls_persona.dart';
import 'package:sgii_front/service/serv_persona.dart';
import 'package:sgii_front/view/mod_persona/combo_persona_widget.dart';

class CreateEditUserWidget extends StatefulWidget {
  final User? item;
  final void Function(Result r) result;
  final bool mostrarCancelar;
  const CreateEditUserWidget({
    super.key,
    required this.item,
    required this.result,
    required this.mostrarCancelar,
  });

  @override
  CreateEditUserWidgetState createState() => CreateEditUserWidgetState();
}

class CreateEditUserWidgetState extends State<CreateEditUserWidget> {

  bool estaEditando = false;

  final UserService _serv = UserService();
  PersonaService personaS = PersonaService();

  Persona personaSelect = Persona.empty();

  User? item;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _personaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _urlFotoController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    estaEditando = widget.item != null;
    if (estaEditando) {
      fillEditableFields(widget.item!);
    }
  }

  Future<void> fillEditableFields(User? item) async {
    this.item = item;
    if (this.item != null){
      personaSelect = this.item!.persona;
      _personaController.text = this.item!.persona.getValueStr();
      _emailController.text = this.item!.email;
      _passwordController.text = this.item!.password;
      _urlFotoController.text = this.item!.urlFoto;
      _roleController.text = this.item!.role;

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
          widget.item!.id = Parse.getInt(_idController.text);
          widget.item!.persona = personaSelect;
          widget.item!.email = Parse.getString(_emailController.text);
          widget.item!.password = Parse.getString(_passwordController.text);
          widget.item!.urlFoto = Parse.getString(_urlFotoController.text);
          widget.item!.role = Parse.getString(_roleController.text);

          r = await _serv.updateItem(widget.item!);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Actualizacion de User', 'User actualizado');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló en la actualizacion del user');
          }
        } else {
          User item_ = User(
            persona : personaSelect,
            email : Parse.getString(_emailController.text),
            password : Parse.getString(_passwordController.text),
            urlFoto : Parse.getString(_urlFotoController.text),
            role : Parse.getString(_roleController.text),
            id: Parse.getInt(widget.item!= null?widget.item!.id:-1),
            idApi: 1,
            idPersReg: 1,
            dtReg: DateTime.now(),
            estado: 1,
          );
          r = await _serv.createItem(item_);
          if (r.success){
            await info.hideLoadingMask(context);
            info.showMsgDialogAsync(context, 'Agregar User', 'User agregado con exito');
          }else{
            await info.hideLoadingMask(context);
            info.showErrorDialogAsync(context, 'Algo falló al agregar el user');
          }
        }
      }catch(e){
        await info.hideLoadingMask(context);
        r = Result(
          success: false,
          errror: '',
          e: e,
        );
        info.showErrorDialogAsync(context, 'Falló la conexion, intentelo de nuevo');
      }
    } else {
      await info.hideLoadingMask(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor corrija los errores')),
      );
      r = Result(
        success: false,
        errror: 'Por favor corrija los errores',
      );
    }
    widget.result(r);
  }

  @override
  Widget build(BuildContext context) {
    //Text(estaEditando ? 'Editar User' : 'Crear User'),
    return Container(
      width: 500,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                    ComboPersonaWidget(
                      getItem: () {
                        return personaSelect;
                      },
                      setItem: (Persona? item) {
                        personaSelect = item ?? Persona.empty();
                      },
                    ),
                    SizedBox(height: 16),
               TextWidget(
                 controller: _emailController,
                 labelText: 'Email',
                 hintText: 'Escriba Email',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _passwordController,
                 labelText: 'Password',
                 hintText: 'Escriba Password',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _urlFotoController,
                 labelText: 'UrlFoto',
                 hintText: 'Escriba UrlFoto',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               TextWidget(
                 controller: _roleController,
                 labelText: 'Role',
                 hintText: 'Escriba Role',
                 validator: validateNotEmpty,
               ),
               SizedBox(height: 16),
               Wrap(
                 children: [
                   Padding(padding: EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: _guardar,
                       child: Text(estaEditando ? 'Actualizar User' : 'Guardar User'),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(double.infinity, 50),
                       ),
                     ),
                   ),
                   if(widget.mostrarCancelar)Padding(padding:
                   EdgeInsets.all(8),
                     child: ElevatedButton(
                       onPressed: (){
                         widget.result(Result(
                           success: true,
                           message: 'Se cancelo',
                           errror: '',
                         ));
                       },
                       child: Text('Cancelar'),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(double.infinity, 50),
                       ),
                     ),
                   ),
                 ],
               )
             ],
            ),
          )
        ),
      )
    );
  }
}