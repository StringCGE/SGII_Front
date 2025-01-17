import 'dart:convert';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/config.dart';
import 'package:http/http.dart' as http;

import 'package:sgii_front/model/cls_proveedor.dart';

class ProveedorService {
  static final ProveedorService _singleton = ProveedorService._internal();
  static const String _cacheKey = 'value_cache_Proveedor';

  List<Proveedor> _lItem = [];

  ProveedorService._internal();

  factory ProveedorService() {
    return _singleton;
  }

  List<Proveedor> get lItem => _lItem;

  Future<Proveedor> directGetItemById(int id, int idApi) async {
    ResultOf<Proveedor> result = await getItemById(id, idApi);
    if (!result.success) {
      return Proveedor.empty();
    }
    if (result.value == null) {
      return Proveedor.empty();
    }
    return result.value!;
  }

  Future<ResultOf<Proveedor>> getItemById(int id, int idApi) async {
    if (await _isConnectedToInternet()) {
      return _getItemById_Api(idApi);
    } else {
      return await _getItemById_Cache(id);
    }
  }

  Future<ResultOf<Proveedor>> _getItemById_Cache(int id) async {
    try {
      Proveedor existe = _lItem.firstWhere(
            (p) => p.id == id,
        orElse: () => Proveedor.empty(),
      );
      return ResultOf<Proveedor>(
        success: true,
        message: "",
        errror: "",
        value: existe,
      );
    } catch (e) {
      return ResultOf<Proveedor>(
        success: false,
        message: "",
        errror: "",
        e: e,
      );
    }
  }

  Future<ResultOf<Proveedor>> _getItemById_Api(int id) async {
    try {
      final url = Uri.parse('${Config.url}/api/Proveedor/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Proveedor value = await Proveedor.fromMap(data, true);
        List<Proveedor> list = [value];
        _actualizarList(list, 0);
        return ResultOf<Proveedor>(
          success: true,
          value: list[0],
          message: "Proveedor leído correctamente",
          errror: "",
        );
      } else {
        return ResultOf<Proveedor>(
          success: false,
          message: "",
          errror: "Error al leer Proveedor",
        );
      }
    } catch (e) {
      return ResultOf<Proveedor>(
        success: false,
        message: "",
        errror: "Error al leer Proveedor",
        e: e,
      );
    }
  }

  Future<Result> createItem(Proveedor value) async {
    if (await _isConnectedToInternet()) {
      return _createItem_Api(value);
    } else {
      return await _createItem_Cache(value);
    }
  }

  Future<Result> _createItem_Cache(Proveedor value) async {
    value.local = 1;
    lItem.add(value);
    return Result(
      success: true,
      message: "",
      errror: "",
    );
  }

  Future<Result> _createItem_Api(Proveedor value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.post(
      Uri.parse('${Config.url}/api/Proveedor'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return Result(
        success: true,
        message: "Proveedor agregado correctamente",
        errror: "",
      );
    } else {
      return Result(
        success: false,
        message: "",
        errror: "Error al agregar Proveedor",
      );
    }
  }

  Future<Result> deleteItem(Proveedor value) async {
    value.estado = 0;
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }

  Future<Result> updateItem(Proveedor value) async {
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }

  Future<Result> _updateItem_Cache(Proveedor value) async {
    value.local = 2;
    return Result(
      success: true,
      message: "Proveedor actualizado correctamente.",
      errror: "",
    );
  }

  Future<Result> _updateItem_Api(Proveedor value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.put(
      Uri.parse('${Config.url}/api/Proveedor/${value.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 200) {
      return Result(
        success: true,
        message: "Proveedor actualizado correctamente",
        errror: "",
      );
    } else {
      return Result(
        success: false,
        message: "",
        errror: "Error al actualizar Proveedor",
      );
    }
  }

  Future<bool> _isConnectedToInternet() async {
    try {
      final response = await http.get(Uri.parse('${Config.url}/api/Status'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _actualizarList(List<Proveedor> nuevosItem, int i) async {
    var nuevo = nuevosItem[i];
    int index = _lItem.indexWhere((value) => value.idApi == nuevo.idApi);
    if (index != -1) {
      Map<String, dynamic> apiMap = nuevo.toMap();
      Map<String, dynamic> localMap = _lItem[index].toMap();
      if (apiMap == localMap) {
        _lItem[index].setFromMap(apiMap, true);
        nuevosItem[i] = _lItem[index];
        return true;
      }
    } else {
      _lItem.add(nuevo);
      return true;
    }
    return false;
  }
}
