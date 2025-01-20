import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sgii_front/util/common/parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:sgii_front/util/common/result.dart';
import 'package:sgii_front/util/my_widget/config.dart';

import 'package:sgii_front/model/cls_sexo.dart';

class SexoService {
  static final SexoService _singleton = SexoService._internal();
  static const String _cacheKey = 'value_cache_Sexo';

  List<Sexo> _lItem = [];

  SexoService._internal();

  factory SexoService() {
    return _singleton;
  }

  List<Sexo> get lItem => _lItem;
  Future<Sexo> directGetItemById(int id, int idApi) async {
    ResultOf<Sexo> result = await getItemById(id, idApi);
    if (!result.success){
      return Sexo.empty();
    }
    if (result.value == null){
      return Sexo.empty();
    }
    return result.value!;
  }
  Future<ResultOf<Sexo>> getItemById(int id, int idApi) async {
    if (await _isConnectedToInternet()) {
      return _getItemById_Api(idApi);
    } else {
      //Se se tiene internet y cae aqui, el api no esta funcionando
      return await _getItemById_Cache(id);
    }
  }
  Future<ResultOf<Sexo>> _getItemById_Cache(int id) async {
    try{
      Sexo existe = _lItem.firstWhere(
            (c) => c.id == id,
        orElse: () => Sexo.empty(),
      );
      return ResultOf<Sexo>(
        success: true,
        message: "",
        errror: "",
        value: existe,
      );
    }catch(e){
      return ResultOf<Sexo>(
        success: false,
        message: "",
        errror: "",
        e: e,
      );
    }
  }
  Future<ResultOf<Sexo>> _getItemById_Api(int id) async {
    try{
      final url = Uri.parse('${Config.urlApi}/api/Sexo/${id}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Sexo value = await Sexo.fromMap(data, true);
        List<Sexo> list = [value];
        _actualizarList(list, 0);
        return ResultOf<Sexo>(
          success: true,
          value: list[0],
          message: "Sexo leido correctamente",
          errror: "",
        );
      } else {
        return ResultOf<Sexo>(
          success: false,
          message: "",
          errror: "Error al leer Sexo",
        );
      }
    }catch(e){
      return ResultOf<Sexo>(
        success: false,
        message: "",
        errror: "Error al leer Sexo",
        e: e,
      );
    }

  }


  Future<Result> createItem(Sexo value) async {
    if (await _isConnectedToInternet()) {
      return _createItem_Api(value);
    } else {
      return await _createItem_Cache(value);
    }
  }
  Future<Result> _createItem_Cache(Sexo value) async {
    value.local = 1;
    lItem.add(value);
    return Result(
      success: true,
      message: "",
      errror: "",
    );
  }
  Future<Result> _createItem_Api(Sexo value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.post(
      Uri.parse('${Config.urlApi}/api/Sexo'), // Cambia el endpoint según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 201) {
      return Result(
        success: true,
        message: "Sexo agregado correctamente",
        errror: "",
      );
    } else {
      return Result(
        success: false,
        message: "",
        errror: "Error al agregar Sexo",
      );
    }
  }
  Future<Result> deleteItem(Sexo value) async {
    value.estado = 0;
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> updateItem(Sexo value) async {
    if (await _isConnectedToInternet()) {
      return _updateItem_Api(value);
    } else {
      return await _updateItem_Cache(value);
    }
  }
  Future<Result> _updateItem_Cache(Sexo value) async {
    value.local = 2;
    return Result(
      success: true,
      message: "Sexo actualizado correctamente.",
      errror: "",
    );
  }
  Future<Result> _updateItem_Api(Sexo value) async {
    value.local = 0;
    Map<String, dynamic> map = value.toMap();
    final response = await http.put(
      Uri.parse('${Config.urlApi}/api/Sexo/${value.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );
    if (response.statusCode == 200) {
      return Result(
        success: true,
        message: "Sexo actualizado correctamente",
        errror: "",
      );
    } else {
      return Result(
        success: false,
        message: "",
        errror: "Error al actualizar Sexo",
      );
    }
  }

  Future<ResultOf<List<Sexo>>> fetchData(DateTime offset, int take, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, null);
    } else {
      return await _fetchData_Cache(offset, take, null);
    }
  }

  Future<ResultOf<List<Sexo>>> fetchDataFind(DateTime offset, int take, String? nombre, {bool forceRefresh = false}) async {
    if (await _isConnectedToInternet() || forceRefresh) {
      return _fetchData_Api(offset, take, nombre);
    } else {
      return await _fetchData_Cache(offset, take, nombre);
    }
  }

  Future<ResultOf<List<Sexo>>> _fetchData_Api(DateTime offset, int take, String? nombre) async {
    String fecha = Parse.getDatetimeToStringFromQuery(offset);

    StringBuffer urlBuilder = StringBuffer('${Config.urlApi}/api/Sexo?offsetDT=$fecha&take=$take');
    if (nombre != null && nombre.isNotEmpty) {
      urlBuilder.write('&nombre=$nombre');
    }
    String url = urlBuilder.toString();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Sexo> nuevosItem = await Future.wait(
            data.map((item) => Sexo.fromMap(item, true))
        );
        /*List<Sexo> nuevosItem = data.map((item) {
          return Sexo.fromMap(item, true);
        }).toList();*/
        bool seActualizaCache = false;
        for (int i = 0; i < nuevosItem.length; i++) {
          seActualizaCache = seActualizaCache || await _actualizarList(nuevosItem, i);
        }
        if (seActualizaCache){
          _sFromCache();
        }

        return ResultOf<List<Sexo>>(
          success: true,
          message: "",
          errror: "",
          value: nuevosItem,
        );
      } else {
        return ResultOf<List<Sexo>>(
          success: false,
          message: "",
          errror: "Error al obtener datos del API",
          value: [],
          e: null,
        );
      }
    } catch (e) {
      return ResultOf<List<Sexo>>(
        success: false,
        message: "",
        errror: "Error al obtener datos del API",
        value: [],
        e: e,
      );
    }
  }

  Future<ResultOf<List<Sexo>>> _fetchData_Cache(DateTime offset, int take, String? nombre) async {
    await _lFromCache();
    List<Sexo> filteredItems = _lItem
        .where((value) {
      bool fechaValida = value.dtReg.isBefore(offset) && !value.dtReg.isAtSameMomentAs(offset);
      bool nombreValido = true;
      /*if(nombre != null){
        if (!nombre.isEmpty){
          nombreValido = value.nombre.contains(nombre);
        }
      }*/
      return fechaValida && nombreValido;
    }).toList();

    filteredItems.sort((a, b) => b.dtReg.compareTo(a.dtReg));
    List<Sexo> items_ = filteredItems.take(take).toList();
    return ResultOf<List<Sexo>>(
      success: true,
      message: "",
      errror: "",
      value: items_,
      e: null,
    );
  }


  Future<List<Sexo>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> jsonData = json.decode(cachedData);
      List<Sexo> nuevosItem = await Future.wait(
          jsonData.map((item) => Sexo.fromMap(item, false))
      );
      return nuevosItem;
    } else {
      return [];
    }
  }
  bool _dataLoaded = false;
  Future<void> _lFromCache() async {
    if (_dataLoaded) {
      return;
    }
    _lItem = await _loadFromCache();
    _dataLoaded = true;
  }
  Future<void> _saveToCache(List<Sexo> lVals) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(lVals.map((e) => e.toMap()).toList());
    await prefs.setString(_cacheKey, jsonData);
  }
  Future<void> _sFromCache() async {
    await _saveToCache(_lItem);
  }
  void updateLocalData(List<Sexo> lVals) {
    _lItem = lVals;
  }
  Future<bool> _isConnectedToInternet() async {
    if (kIsWeb) {
      try {
        final response = await http.get(Uri.parse('${Config.urlApi}/api/Status'));
        return response.statusCode == 200;
      } catch (e) {
        return false;
      }
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
  }
  Future<bool> _actualizarList(List<Sexo> nuevosItem, int i) async {//Map<String, dynamic>
    var nuevo = nuevosItem[i];
    int index = _lItem.indexWhere((value) => value.idApi == nuevo.idApi);
    if (index != -1) {
      late Map<String, dynamic> apiMap;
      late Map<String, dynamic> localMap;
      apiMap = nuevo.toMap();
      localMap = _lItem[index].toMap();
      if (apiMap == localMap){
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