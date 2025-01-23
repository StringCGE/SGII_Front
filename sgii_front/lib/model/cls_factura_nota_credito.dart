import 'package:sgii_front/model/cls_000_db_obj.dart';
import 'package:sgii_front/model/cls_emisor_item.dart';
import 'package:sgii_front/model/cls_item_factura_nota_credito.dart';
import 'package:sgii_front/service/serv_emisor_item.dart';
import 'package:sgii_front/model/cls_registro_doc.dart';
import 'package:sgii_front/service/serv_registro_doc.dart';
import 'package:sgii_front/model/cls_cliente.dart';
import 'package:sgii_front/service/serv_cliente.dart';
import 'package:sgii_front/util/common/parse.dart';

class FacturaNotaCredito extends DbObj {

  EmisorItem emisor;
  RegistroDoc registroFactura;
  Cliente cliente;
  String claveAcceso;
  bool esFactura;
  String autorizacion;
  double subtotalPrevio;
  double subtotal0;
  double descuento;
  double subtotal;
  double iva;
  double total;
  double pagoEfectivo;
  double pagoTarjetaDebCred;
  double pagoOtraForma;
  String pagoOtraFormaDetalle;
  List<ItemFacturaNotaCredito> lItem;

  FacturaNotaCredito({
    required this.emisor,
    required this.registroFactura,
    required this.cliente,
    required this.claveAcceso,
    required this.esFactura,
    required this.autorizacion,
    required this.subtotalPrevio,
    required this.subtotal0,
    required this.descuento,
    required this.subtotal,
    required this.iva,
    required this.total,
    required this.pagoEfectivo,
    required this.pagoTarjetaDebCred,
    required this.pagoOtraForma,
    required this.pagoOtraFormaDetalle,
    required this.lItem,
    required super.id,
    required super.idApi,
    required super.dtReg,
    required super.idPersReg,
    required super.estado,
  });

  @override
  String toString() {
    return 'FacturaNotaCredito';
  }

  static Future<FacturaNotaCredito> fromMap(Map<String, dynamic> map, bool fromApi) async {
    int id = -1;
    int idApi = -1;
    int emisor_id = -1;
    int emisor_idApi = -1;
    int registroFactura_id = -1;
    int registroFactura_idApi = -1;
    int cliente_id = -1;
    int cliente_idApi = -1;

    if (fromApi) {
      idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
      Map<String, dynamic> registroFactura_map = map['registroFactura'];
      registroFactura_id = Parse.getInt(registroFactura_map['id']);
      registroFactura_idApi = Parse.getInt(registroFactura_map['id']);
      
      Map<String, dynamic> cliente_map = map['cliente'];
      cliente_id = Parse.getInt(cliente_map['id']);
      cliente_idApi = Parse.getInt(cliente_map['id']);
      
    } else {
      id = Parse.getInt(map['id']);
      idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
      Map<String, dynamic> registroFactura_map = map['registroFactura'];
      registroFactura_id = Parse.getInt(registroFactura_map['id']);
      registroFactura_idApi = Parse.getInt(registroFactura_map['idApi']);
      
      Map<String, dynamic> cliente_map = map['cliente'];
      cliente_id = Parse.getInt(cliente_map['id']);
      cliente_idApi = Parse.getInt(cliente_map['idApi']);
      
    }

    String claveAcceso = Parse.getString(map['claveAcceso']);
    bool esFactura = Parse.getBool(map['esFactura']);
    String autorizacion = Parse.getString(map['autorizacion']);
    double subtotalPrevio = Parse.getDouble(map['subtotalPrevio']);
    double subtotal0 = Parse.getDouble(map['subtotal0']);
    double descuento = Parse.getDouble(map['descuento']);
    double subtotal = Parse.getDouble(map['subtotal']);
    double iva = Parse.getDouble(map['iva']);
    double total = Parse.getDouble(map['total']);
    double pagoEfectivo = Parse.getDouble(map['pagoEfectivo']);
    double pagoTarjetaDebCred = Parse.getDouble(map['pagoTarjetaDebCred']);
    double pagoOtraForma = Parse.getDouble(map['pagoOtraForma']);
    String pagoOtraFormaDetalle = Parse.getString(map['pagoOtraFormaDetalle']);
    //DateTime? dtReg = map['dtReg'] != null
      //? DateTime.parse(map['dtReg'])
      //: null;
    DateTime dtReg = Parse.getDateTime(map['dtReg']);
    int idPersReg = Parse.getInt(map['idPersReg']);
    int estado = Parse.getInt(map['estado']);

    List<ItemFacturaNotaCredito> lItem = [];
    return FacturaNotaCredito(
      emisor: await EmisorItemService().directGetItemById(emisor_id, emisor_idApi),
      registroFactura: await RegistroDocService().directGetItemById(registroFactura_id, registroFactura_idApi),
      cliente: await ClienteService().directGetItemById(cliente_id, cliente_idApi),
      claveAcceso: claveAcceso,
      esFactura: esFactura,
      autorizacion: autorizacion,
      subtotalPrevio: subtotalPrevio,
      subtotal0: subtotal0,
      descuento: descuento,
      subtotal: subtotal,
      iva: iva,
      total: total,
      pagoEfectivo: pagoEfectivo,
      pagoTarjetaDebCred: pagoTarjetaDebCred,
      pagoOtraForma: pagoOtraForma,
      pagoOtraFormaDetalle: pagoOtraFormaDetalle,
      lItem: lItem,
      id: id,
      idApi: idApi,
      dtReg: dtReg,
      idPersReg: idPersReg,
      estado: estado,
    );
  }

  Future<void> setFromMap(Map<String, dynamic> map, bool fromApi) async {
    int emisor_id = -1;
    int emisor_idApi = -1;
    int registroFactura_id = -1;
    int registroFactura_idApi = -1;
    int cliente_id = -1;
    int cliente_idApi = -1;


    if (fromApi) {
      this.idApi = Parse.getInt(map['id']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['id']);
      
      Map<String, dynamic> registroFactura_map = map['registroFactura'];
      registroFactura_id = Parse.getInt(registroFactura_map['id']);
      registroFactura_idApi = Parse.getInt(registroFactura_map['id']);
      
      Map<String, dynamic> cliente_map = map['cliente'];
      cliente_id = Parse.getInt(cliente_map['id']);
      cliente_idApi = Parse.getInt(cliente_map['id']);
      
    } else {
      this.id = Parse.getInt(map['id']);
      this.idApi = Parse.getInt(map['idApi']);

      Map<String, dynamic> emisor_map = map['emisor'];
      emisor_id = Parse.getInt(emisor_map['id']);
      emisor_idApi = Parse.getInt(emisor_map['idApi']);
      
      Map<String, dynamic> registroFactura_map = map['registroFactura'];
      registroFactura_id = Parse.getInt(registroFactura_map['id']);
      registroFactura_idApi = Parse.getInt(registroFactura_map['idApi']);
      
      Map<String, dynamic> cliente_map = map['cliente'];
      cliente_id = Parse.getInt(cliente_map['id']);
      cliente_idApi = Parse.getInt(cliente_map['idApi']);
      
    }

      this.emisor = await EmisorItemService().directGetItemById(emisor_id, emisor_idApi);
      this.registroFactura = await RegistroDocService().directGetItemById(registroFactura_id, registroFactura_idApi);
      this.cliente = await ClienteService().directGetItemById(cliente_id, cliente_idApi);
      this.claveAcceso = claveAcceso;
      this.esFactura = esFactura;
      this.autorizacion = autorizacion;
      this.subtotalPrevio = subtotalPrevio;
      this.subtotal0 = subtotal0;
      this.descuento = descuento;
      this.subtotal = subtotal;
      this.iva = iva;
      this.total = total;
      this.pagoEfectivo = pagoEfectivo;
      this.pagoTarjetaDebCred = pagoTarjetaDebCred;
      this.pagoOtraForma = pagoOtraForma;
      this.pagoOtraFormaDetalle = pagoOtraFormaDetalle;
      this.dtReg = dtReg;
      this.idPersReg = idPersReg;
      this.estado = estado;
      this.lItem = lItem;
  }

  @override
  Map<String, dynamic> toMap() {

    return {
      'emisor': emisor.toMap(),
      'registroFactura': registroFactura.toMap(),
      'cliente': cliente.toMap(),
      'claveAcceso': claveAcceso,
      'esFactura': esFactura,
      'autorizacion': autorizacion,
      'subtotalPrevio': subtotalPrevio,
      'subtotal0': subtotal0,
      'descuento': descuento,
      'subtotal': subtotal,
      'iva': iva,
      'total': total,
      'pagoEfectivo': pagoEfectivo,
      'pagoTarjetaDebCred': pagoTarjetaDebCred,
      'pagoOtraForma': pagoOtraForma,
      'pagoOtraFormaDetalle': pagoOtraFormaDetalle,
      'lItem' : lItem.map((item) => item.toMap()).toList(),
      'id': id,
      'idApi': idApi,
      'dtReg': dtReg.toIso8601String(),
      'idPersReg': idPersReg,
      'estado': estado,
    };
  }

  static FacturaNotaCredito _empty = FacturaNotaCredito(
    emisor: EmisorItem.empty(),
    registroFactura: RegistroDoc.empty(),
    cliente: Cliente.empty(),
    claveAcceso : '',
    esFactura : false,
    autorizacion : '',
    subtotalPrevio : 0,
    subtotal0 : 0,
    descuento : 0,
    subtotal : 0,
    iva : 0,
    total : 0,
    pagoEfectivo : 0,
    pagoTarjetaDebCred : 0,
    pagoOtraForma : 0,
    pagoOtraFormaDetalle : '',
    lItem: [],
    id: 1,
    idApi: 1,
    dtReg: DateTime(1995, 04, 14, 12, 34, 56, 7890),
    idPersReg: 1,
    estado: -100, // State for empty object
  );

  @override
  static FacturaNotaCredito empty() {
    return _empty;
  }
  
  @override
  String getValueStr(){
    if (esFactura){

    }else{

    }
    return '${esFactura?"Factura: ":"Nota de credito: "} ${cliente.persona.nombre1} ${cliente.persona.apellido1}';
  }
}
