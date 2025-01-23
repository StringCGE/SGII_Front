enum TipoEmision {
  normal,
}

extension TipoEmisionExtension on TipoEmision {
  String get codigo {
    switch (this) {
      case TipoEmision.normal:
        return '1';
    }
  }
}

enum TipoComprobante {
  factura,
  liquidacion,
  notaCredito,
  notaDebito,
  guiaRemision,
  retencion,
}

extension TipoComprobanteExtension on TipoComprobante {
  String get codigo {
    switch (this) {
      case TipoComprobante.factura:
        return '01';
      case TipoComprobante.liquidacion:
        return '03';
      case TipoComprobante.notaCredito:
        return '04';
      case TipoComprobante.notaDebito:
        return '05';
      case TipoComprobante.guiaRemision:
        return '06';
      case TipoComprobante.retencion:
        return '07';
    }
  }
}

enum TipoAmbiente {
  pruebas,
}

extension TipoAmbienteExtension on TipoAmbiente {
  String get codigo {
    switch (this) {
      case TipoAmbiente.pruebas:
        return '1';
    }
  }
}

class ClaveAcceso {
  late String fechaEmision;
  late TipoComprobante tipoComprobante;
  late String numeroRUC;
  late TipoAmbiente tipoAmbiente;
  late String serie;
  late String numeroComprobante;
  late String codigoNumerico;
  late TipoEmision tipoEmision;
  late String digitoVerificador;

  void generarDigitoVerificador() {
    final codigo = _getCodigoPross();
    int suma = 0;
    int peso = 2;

    for (int i = codigo.length - 1; i >= 0; i--) {
      suma += int.parse(codigo[i]) * peso;
      peso = peso == 7 ? 2 : peso + 1;
    }

    final modulo = 11 - (suma % 11);
    digitoVerificador = modulo == 11
        ? '0'
        : modulo == 10
        ? '1'
        : modulo.toString();
  }

  String _getCodigoPross() {
    return fechaEmision +
        tipoComprobante.codigo +
        numeroRUC +
        tipoAmbiente.codigo +
        serie +
        numeroComprobante +
        codigoNumerico +
        tipoEmision.codigo;
  }

  String getCodigo() {
    return _getCodigoPross() + digitoVerificador;
  }
}
