import 'package:flutter/material.dart';
import 'package:sgii_front/util/common/info.dart';
import 'package:sgii_front/util/common/list_errror.dart';
import 'package:sgii_front/util/common/publico_usuario_util.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/common/validador_controller.dart';

class TextLabelInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String nombre;
  final String placeholder;
  final Color backColor;
  final ErrrorNotify? err;

  const TextLabelInputWidget({
    super.key,
    required this.controller,
    required this.nombre,
    required this.placeholder,
    required this.backColor,
    this.err,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        if(err != null)Text(err!.msg)
      ],
    );
  }
}




class PswInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool validar;
  final String nombre;
  final String placeholder;
  final Color backColor;
  final ErrrorNotify? err;
  final ValidadorController? vcPsw;

  const PswInputWidget({
    Key? key,
    required this.controller,
    required this.nombre,
    required this.placeholder,
    required this.backColor,
    required this.validar,
    this.vcPsw,
    this.err,
  }) : super(key: key);

  @override
  PswInputWidgetState createState() => PswInputWidgetState();
}

class PswInputWidgetState extends State<PswInputWidget> {
  late TextEditingController tecPsw;
  final pswRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  String validacionMsg = "";
  @override
  void initState() {
    super.initState();
    tecPsw = TextEditingController();
    tecPsw.addListener(() {
      widget.controller.text = tecPsw.text;
      if(widget.validar){
        validacionMsg = _validarPsw(tecPsw.text);
        if (widget.vcPsw != null){
          widget.vcPsw!.seValido = (validacionMsg == 'Correcto');
        }
        setState(() {});
      }
    });
  }
  String _validarPsw(String password) {

    final RegExp minLengthExp = RegExp(r'.{8,16}');
    final RegExp upperCaseExp = RegExp(r'[A-Z]');
    final RegExp numberExp = RegExp(r'\d');
    final RegExp allowedSpecialCharsExp = RegExp(r'[!@#$%^&*()_+\-={}\[\]:;"<>,.?/]');

    if (!minLengthExp.hasMatch(password)) {
      return 'La contraseña debe tener entre 8 y 16 caracteres.';
    }

    if (!upperCaseExp.hasMatch(password)) {
      return 'La contraseña debe contener al menos una letra mayúscula.';
    }

    if (!numberExp.hasMatch(password)) {
      return 'La contraseña debe contener al menos un número.';
    }

    final forbiddenCharsExp = RegExp(r'[^A-Za-z0-9!@#$%^&*()_+\-={}\[\]:;"<>,.?/]');
    if (forbiddenCharsExp.hasMatch(password)) {
      return 'La contraseña contiene caracteres no permitidos.';
    }

    return 'Correcto';
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            widget.nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: widget.backColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: tecPsw,
              obscureText: true, // Para ocultar los caracteres de la contraseña
              decoration: InputDecoration(
                hintText: widget.placeholder,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        if (widget.validar && validacionMsg != "")
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              validacionMsg,
              style: TextStyle(color: Colors.red),
            ),
          ),
        if(widget.err != null)Text(widget.err!.msg)
      ],
    );
  }
}



class DateInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String nombre;
  final String placeholder;
  final Color backColor;

  const DateInputWidget({
    super.key,
    required this.controller,
    required this.nombre,
    required this.placeholder,
    required this.backColor,
  });

  @override
  DateInputWidgetState createState() => DateInputWidgetState();
}

class DateInputWidgetState extends State<DateInputWidget> {
  String fecha = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.nombre != "")Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            widget.nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            _selectDate(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.backColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fecha.isNotEmpty ? fecha : widget.placeholder,
                      /*style: TextStyle(
                      color: fecha.isNotEmpty ? Colors.black : Colors.grey,
                    ),*/
                    ),
                  ),
                  Icon(Icons.date_range),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        fecha = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'; // Formato de fecha
        widget.controller.text = fecha; // Actualizar el controlador con la fecha
      });
    }
  }
}



class EmailCodeValidator extends StatefulWidget {

  final TextEditingController controller;
  final String nombre;
  final String placeholder;
  final Color backColor;
  final Color buttonColor;
  final ErrrorNotify? err;
  final ValidadorController vcEmail;
  final void Function(String email) emailValido;

  const EmailCodeValidator({
    super.key,
    required this.controller,
    required this.nombre,
    required this.placeholder,
    required this.backColor,
    required this.buttonColor,
    required this.vcEmail,
    required this.emailValido,
    this.err,
  });
  @override
  EmailCodeValidatorState createState() => EmailCodeValidatorState();
}

class EmailCodeValidatorState extends State<EmailCodeValidator> {
  late TextEditingController tecEmail;
  late TextEditingController tecCode;
  bool _correoValidado = false;
  bool _correoFormateado = false;
  bool _auxCorreoFormateado = false;
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  bool primeraEjecucion = true;
  bool primeraEjecucionAux = true;
  @override
  void initState() {
    super.initState();
    tecEmail = TextEditingController();
    tecEmail.addListener(() {
      widget.controller.text = tecEmail.text;
      _validateEmail(tecEmail.text);
    });
    tecCode = TextEditingController();
  }
  void _validateEmail(String email) {
    bool cambiarEstado = false;
    primeraEjecucion = false;
    if (primeraEjecucion != primeraEjecucionAux){
      cambiarEstado = true;
    }
    primeraEjecucionAux = primeraEjecucion;
    _auxCorreoFormateado = _correoFormateado;
    _correoFormateado = emailRegex.hasMatch(email);
    if(_auxCorreoFormateado != _correoFormateado){
      if (_correoFormateado){
        widget.vcEmail.seValido = ((emailValido == email) && _correoFormateado && correoValidado);
      }
      cambiarEstado = true;
    }
    if (cambiarEstado){
      setState(() {});
    }
  }
  String emailValido = "";
  String emailCode = "";
  DateTime fecha = DateTime.now();
  Future<void> aEnviarCodigo() async {
    try{
      Result r = await PublicoUsuarioUtil.validadorEnviarCodigoEmail(email: tecEmail.text);
      emailCode = r.value['emailCode'];
      emailValido = r.value['email'];
      widget.emailValido(emailValido);
      fecha = DateTime.parse(r.value['fecha']);
      if (r.success){
        Info().showMsgDialog(context, "Validacion de correo", "Se envió el codigo al correo, tiene 5 minutos para validar el correo");
      }else{
        Info().showMsgDialog(context, "Validacion de correo", "Error tecnico. Falló el envio de codigo al correo");
      }
    }catch(e){
      Info().showMsgDialog(context, "Validacion de correo", "Algo falló en el envio del codigo");
    }
  }
  bool _validateCode(String code) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(fecha);
    if (difference.inMinutes > 5){
      return false;
    }
    if (emailCode == ""){
      return false;
    }
    if (code.length != 6){
      return false;
    }
    if (emailCode != code){
      return false;
    }
    return true;
  }
  bool correoValidado = false;
  bool correoUsoValidar = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            text: widget.nombre),
        TextInputWidget(
            controller: tecEmail,
            placeholder: widget.placeholder,
            backColor: widget.backColor
        ),
        if(widget.err != null)Text(widget.err!.msg),
        SizedBox(height: 20,),
        Container(
          child: Wrap(
            children: [
              if(_correoFormateado)Container(
                padding: EdgeInsets.only(top: 2),
                child: ExecButton(
                    color: widget.buttonColor,
                    text: 'Enviar codigo',
                    onPressed:(){
                      aEnviarCodigo();
                    }
                ),
              ),
              if(_correoFormateado)TextWidget(
                  padding: EdgeInsets.only(top:10, bottom: 6, left: 8, right: 8),
                  text: ">"),
              if(_correoFormateado)TextWidget(
                  padding: EdgeInsets.only(top:10, bottom: 6, left: 8, right: 8),
                  text: "Codigo: "),
              if(_correoFormateado)Container(
                width: 100,
                child: TextInputWidget(
                    controller: tecCode,
                    placeholder: "Código",
                    backColor: widget.backColor
                ),
              ),
              if(_correoFormateado)SizedBox(width: 25,),
              if(_correoFormateado)Container(
                padding: EdgeInsets.only(top: 2),
                child: ExecButton(
                    color: widget.buttonColor,
                    text: 'Validar correo',
                    onPressed:(){
                      correoUsoValidar = true;
                      correoValidado = _validateCode(tecCode.text);
                      widget.vcEmail.seValido = ((emailValido == tecEmail.text) && _correoFormateado && correoValidado);
                      if (correoValidado){
                        Info().showMsgDialog(context, "Validacion de correo", "Se valido correctamenet el correo electronico");
                        setState(() {
                          _correoValidado = true;
                          widget.vcEmail.seValido = _correoFormateado || _correoValidado;
                        });
                      }else{
                        Info().showMsgDialog(context, "Validacion de correo", "El codigo ingresado no es el correcto o se paso el tiempo de validacion");
                        setState(() {
                          _correoValidado = false;
                          widget.vcEmail.seValido = _correoFormateado || _correoValidado;
                        });
                      }

                    }
                ),
              ),
              SizedBox(width: 40,),
              if(!primeraEjecucion && _correoFormateado)Container(
                padding: EdgeInsets.only(top:6),
                child: TextInfoCampoWidget(
                  text: "Formato correcto",
                  icon: Icons.check,
                  backColor: Color.fromARGB(255, 174, 255, 174),
                  borderColor: Color.fromARGB(255, 66, 131, 66),
                  iconColor: Color.fromARGB(255, 66, 131, 66),
                ),
              ),
              if(!primeraEjecucion && !_correoFormateado)Container(
                padding: EdgeInsets.only(top:6),
                child: TextInfoCampoWidget(
                  text: "Formato incorrecto",
                  icon: Icons.warning,
                  backColor: Color.fromARGB(255, 255, 196, 118),
                  borderColor: Color.fromARGB(255, 243, 81, 46),
                  iconColor: Color.fromARGB(255, 243, 82, 36),
                ),
              ),
              SizedBox(width: 40,),
              if(!primeraEjecucion && correoUsoValidar && _correoValidado && correoValidado == tecEmail.text)Container(
                padding: EdgeInsets.only(top:6),
                child: TextInfoCampoWidget(
                  text: "Correo validado",
                  icon: Icons.check,
                  backColor: Color.fromARGB(255, 174, 255, 174),
                  borderColor: Color.fromARGB(255, 66, 131, 66),
                  iconColor: Color.fromARGB(255, 53, 100, 28),
                ),
              ),
              if(!primeraEjecucion && correoUsoValidar &&  !_correoValidado)Container(
                padding: EdgeInsets.only(top:6),
                child: TextInfoCampoWidget(
                  text: "Correo no validado",
                  icon: Icons.warning,
                  backColor: Color.fromARGB(255, 255, 196, 118),
                  borderColor: Color.fromARGB(255, 243, 81, 46),
                  iconColor: Color.fromARGB(255, 243, 82, 36),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}


class ExecButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  final Color colorText;
  final double borderRadius;
  final double padding;

  const ExecButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.colorText = Colors.black,
    this.borderRadius = 8.0,
    this.padding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorText,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
        minimumSize: Size(0, 50.0),
        side: BorderSide(color: color, width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: color, width: 2.0),
        ),
      ),
    );
  }
}


class TextInputWidget extends StatefulWidget{
  final TextEditingController controller;
  final String placeholder;
  final Color backColor;
  TextInputWidget({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.backColor,
  });
  TextInputWidgetState createState() => TextInputWidgetState();
}

class TextInputWidgetState extends State<TextInputWidget>{

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: widget.backColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget{
  final String text;
  final EdgeInsetsGeometry padding;
  TextWidget({
    super.key,
    required this.text,
    required this.padding,
  });
  @override
  Widget build(BuildContext context){
    return Container(
      padding: this.padding,
      child: Text(
        this.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}


class TextInfoCampoWidget extends StatelessWidget{
  final String text;
  final Color backColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;
  TextInfoCampoWidget({
    super.key,
    required this.text,
    required this.backColor,
    required this.borderColor,
    required this.iconColor,
    required this.icon,
  });
  @override
  Widget build(BuildContext context){
    return Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          color: backColor,
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              this.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10,),
            Icon(
              this.icon,
              color: iconColor,
            ),
          ],
        )
    );
  }
}









