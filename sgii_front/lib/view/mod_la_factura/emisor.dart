class Emisor_0 {
  String _numeroRuc = '';
  String _razonSocial = '';
  String _nombreComercial = '';
  String _direccionEstablecimientoMatriz = '';
  String _direccionEstablecimientoEmisor = '';
  String _codigoEstablecimientoEmisor = '';
  String _codigoPuntoEmision = '';
  String _contribuyenteEspecial = '';
  String _obligadoContabilidad = '';
  String _logoEmisor = '';
  String _tipoAmbiente = '';
  String _tipoEmision = '';

  set numeroRuc(String value) {
    if (value.length == 13 && int.tryParse(value) != null) {
      _numeroRuc = value;
    } else {
      throw Exception("Número de RUC debe ser numérico y tener 13 caracteres.");
    }
  }

  set razonSocial(String value) {
    if (value.isNotEmpty && value.length <= 300) {
      _razonSocial = value;
    } else {
      throw Exception("Razón Social debe tener un máximo de 300 caracteres.");
    }
  }

  set nombreComercial(String value) {
    if (value.length <= 300) {
      _nombreComercial = value;
    }
  }

  set direccionEstablecimientoMatriz(String value) {
    if (value.isNotEmpty && value.length <= 300) {
      _direccionEstablecimientoMatriz = value;
    } else {
      throw Exception("Dirección del Establecimiento Matriz es obligatoria y debe tener un máximo de 300 caracteres.");
    }
  }

  set direccionEstablecimientoEmisor(String value) {
    if (value.length <= 300) {
      _direccionEstablecimientoEmisor = value;
    }
  }

  set codigoEstablecimientoEmisor(String value) {
    if (value.length == 3 && int.tryParse(value) != null) {
      _codigoEstablecimientoEmisor = value;
    } else {
      throw Exception("Código del Establecimiento Emisor debe ser numérico y tener 3 caracteres.");
    }
  }

  set codigoPuntoEmision(String value) {
    if (value.length == 3 && int.tryParse(value) != null) {
      _codigoPuntoEmision = value;
    } else {
      throw Exception("Código del Punto de Emisión debe ser numérico y tener 3 caracteres.");
    }
  }

  set contribuyenteEspecial(String value) {
    if (value.length >= 3 && value.length <= 5 && int.tryParse(value) != null) {
      _contribuyenteEspecial = value;
    }
  }

  set obligadoContabilidad(String value) {
    if (value == 'SI' || value == 'NO') {
      _obligadoContabilidad = value;
    }
  }

  set logoEmisor(String value) {
    _logoEmisor = value;
  }

  set tipoAmbiente(String value) {
    if (value.length == 1 && int.tryParse(value) != null) {
      _tipoAmbiente = value;
    } else {
      throw Exception("Tipo de Ambiente debe ser numérico de 1 carácter.");
    }
  }

  set tipoEmision(String value) {
    if (value.length == 1 && int.tryParse(value) != null) {
      _tipoEmision = value;
    } else {
      throw Exception("Tipo de Emisión debe ser numérico de 1 carácter.");
    }
  }

  bool comprobarCompleto() {
    return _numeroRuc.isNotEmpty && _razonSocial.isNotEmpty
        && _direccionEstablecimientoMatriz.isNotEmpty && _codigoEstablecimientoEmisor.isNotEmpty
        && _codigoPuntoEmision.isNotEmpty && _tipoAmbiente.isNotEmpty
        && _tipoEmision.isNotEmpty;
  }
}