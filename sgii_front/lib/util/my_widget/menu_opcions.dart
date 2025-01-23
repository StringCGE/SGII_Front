import 'package:flutter/material.dart';
import 'package:sgii_front/util/common/nav.dart';
import 'package:sgii_front/util/common/opcion.dart';
import 'package:sgii_front/util/my_widget/main_logon_widget.dart';
import 'package:sgii_front/view/mod_cliente/create_edit_cliente_widget.dart';
import 'package:sgii_front/view/mod_cliente/main_module_cliente.dart';
import 'package:sgii_front/view/mod_emisor/create_edit_emisor_widget.dart';
import 'package:sgii_front/view/mod_emisor/main_module_emisor.dart';
import 'package:sgii_front/view/mod_estado_civil/main_module_estado_civil.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/create_edit_factura_nota_credito_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/create_edit_factura_venta_widget.dart';
import 'package:sgii_front/view/mod_factura_nota_credito/main_module_factura_nota_credito.dart';
import 'package:sgii_front/view/mod_nacionalidad/main_module_nacionalidad.dart';
import 'package:sgii_front/view/mod_persona/create_edit_persona_widget.dart';
import 'package:sgii_front/view/mod_persona/main_module_persona.dart';
import 'package:sgii_front/view/mod_producto/create_edit_producto_widget.dart';
import 'package:sgii_front/view/mod_producto/main_module_producto.dart';
import 'package:sgii_front/view/mod_producto/reporte_producto_widget.dart';
import 'package:sgii_front/view/mod_proveedor/create_edit_proveedor_widget.dart';
import 'package:sgii_front/view/mod_proveedor/main_module_proveedor.dart';
import 'package:sgii_front/view/mod_sexo/main_module_sexo.dart';
import 'package:sgii_front/view/mod_tipo_identificacion/main_module_tipo_identificacion.dart';
import 'package:sgii_front/view/mod_user/create_edit_user_widget.dart';
import 'package:sgii_front/view/mod_user/main_module_user.dart';

class MenuOptions{
  late List<String> roles;
  late List<Opcion> menuOpcion;
  MenuOptions({
    required this.roles,
  }){
    menuOpcion  = Opcion.filtrarOpcionesPorRoles(menuOpcionTodas, roles);
  }

  bool isSidebarVisible = false;
  bool isPinned = false;
  String strSeleccion = "Aun no se selecciono";
  Opcion? seleccion = null;


  List<Opcion> menuOpcionTodas = [
    // Gestión de Inventario
    Opcion(
      roles: [], esOpcion: false,
      nombre: 'Inventario', ejecutar: (BuildContext context, MenuOptions mo){
      /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainLogonWidget(
                menuOptions: mo,
                child: GestionDeInventarioScreen()
            ),
          ),
        );*/
    },
      icono: Icons.inventory,
      opciones: [
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Ver productos',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
              context: context,
              next: () => MainLogonWidget(
                menuOptions: mo,
                child: MainModuleProducto()
              ),
              settingName: 'MainModuleProducto',
              settingArg: null
            );
          },
          icono: Icons.view_list,
          opciones: [],
        ),
        Opcion(
          roles: ['inventario'], esOpcion: true,
          nombre: 'Agregar producto',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
              context: context,
              next: () => MainLogonWidget(
                menuOptions: mo,
                child: CreateEditProductoWidget(
                  item: null,
                  result: (r){
                    Nav.navPop(context: context);
                  },
                  mostrarCancelar: false),
              ),
              settingName: 'MainModuleProducto',
              settingArg: null
            );
          },
          icono: Icons.add,
          opciones: [],
        ),
        Opcion(
          roles: [ 'gerente', 'inventario'], esOpcion: true,
          nombre: 'Reporte',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                  menuOptions: mo,
                  child: ReporteProductoWidget(),
                ),
                settingName: 'ReporteProductoWidget',
                settingArg: null
            );
          },
          icono: Icons.check_box,
          opciones: [],
        ),
      ],
    ),

    // Gestión de Compras
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: false,
      nombre: 'Compras',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: GestionDeComprasScreen()
          ),
        ),
      );*/
      },
      icono: Icons.shopping_cart,
      opciones: [
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Facturación de compra',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: FacturacionDeCompraScreen()
              ),
            ),
          );*/
          },
          icono: Icons.receipt,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'],  esOpcion: true,
          nombre: 'Historial de compras',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: HistorialDevolucionesScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.history,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Notas de credito Compras',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: RegistrarDevolucionCompraScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.add_box,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario',], esOpcion: true,
          nombre: 'Historial de devoluciones compradas',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: HistorialDevolucionesScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.history,
          opciones: [],
        ),
      ],
    ),

    // Gestión de Ventas
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: false,
      nombre: 'Ventas',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: GestionDeVentasScreen()
          ),
        ),
      );*/
      },
      icono: Icons.sell,
      opciones: [
        Opcion(
          roles: ['gerente', 'cajero'],  esOpcion: true,
          nombre: 'Facturación de venta',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: CreateEditFacturaVentaWidget(
                        item: null,
                        result: (r){
                          Nav.navPop(context: context);
                        },
                        mostrarCancelar: false),
                ),
                settingName: 'CreateEditFacturaVentaWidget',
                settingArg: null
            );
          },
          icono: Icons.receipt_long,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Historial de ventas',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleFacturaNotaCredito()
                ),
                settingName: 'MainModuleFacturaNotaCredito',
                settingArg: null
            );
          },
          icono: Icons.history,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Notas de credito Ventas',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: HistorialDevolucionesVentasScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.history,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Historial de devoluciones Ventas',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: HistorialDevolucionesVentasScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.history,
          opciones: [],
        ),
      ],
    ),

    //Cliente
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'],  esOpcion: false,
      nombre: 'Clientes',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ClientesScreen()
              ),
            ),
          );*/
      },
      icono: Icons.person,
      opciones: [
        Opcion(
          roles: ['gerente', 'cajero'], esOpcion: true,
          nombre: 'Ver clientes',
          ejecutar: (BuildContext context, MenuOptions mo){

            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                  menuOptions: mo,
                  child: MainModuleCliente(),
                ),
                settingName: 'MainModuleCliente',
                settingArg: null
            );
          },
          icono: Icons.list_alt,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'cajero'], esOpcion: true,
          nombre: 'Agregar cliente',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                  menuOptions: mo,
                  child: CreateEditClienteWidget(
                      item: null,
                      result: (r){
                        Nav.navPop(context: context);
                      },
                      mostrarCancelar: false),
                ),
                settingName: 'CreateEditClienteWidget',
                settingArg: null
            );
          },
          icono: Icons.add_circle,
          opciones: [],
        ),
      ],
    ),
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: false,
      nombre: 'Proveedores',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ProveedoresScreen()
              ),
            ),
          );*/
      },
      icono: Icons.business,
      opciones: [
        Opcion(
          roles: ['inventario'], esOpcion: true,
          nombre: 'Ver proveedores',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleEmisor()
                ),
                settingName: 'MainModuleEmisor',
                settingArg: null
            );
          },
          icono: Icons.list,
          opciones: [],
        ),
        Opcion(
          roles: ['inventario'], esOpcion: true,
          nombre: 'Agregar proveedor',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: CreateEditEmisorWidget(
                        item: null,
                        result: (r){
                          Nav.navPop(context: context);
                        },
                        mostrarCancelar: false),
                ),
                settingName: 'MainModuleEstadoCivil',
                settingArg: null
            );
          },
          icono: Icons.add_business,
          opciones: [],
        ),
      ],
    ),
    // Gestión de Usuarios
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: false,
      nombre: 'Usuarios',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: GestionDeUsuariosScreen()
          ),
        ),
      );*/
      },
      icono: Icons.people,
      opciones: [
        Opcion(
          roles: ['admin', 'gerente'], esOpcion: true,
          nombre: 'Ver usuarios',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.navDropAll(
              context: context,
              next: () => MainLogonWidget(
                menuOptions: mo,
                child: MainModuleUser(),
              ),
              settingName: 'MainModuleUser',
              settingArg: null
            );
          },
          icono: Icons.list_alt,
          opciones: [],
        ),
        Opcion(
          roles: ['admin', 'gerente'],  esOpcion: true,
          nombre: 'Agregar usuario',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
              context: context,
              next: () => MainLogonWidget(
                menuOptions: mo,
                child: CreateEditUserWidget(
                  item: null,
                  result: (r){
                    Nav.navPop(context: context);
                  },
                  mostrarCancelar: false),
              ),
              settingName: 'CreateEditUserWidget',
              settingArg: null
            );
          },
          icono: Icons.add_circle,
          opciones: [],
        ),
        Opcion(
          roles: ['admin', 'gerente'], esOpcion: true,
          nombre: 'Ver personas',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.navDropAll(
              context: context,
              next: () => MainLogonWidget(
                menuOptions: mo,
                child: MainModulePersona(),
              ),
              settingName: 'MainModulePersona',
              settingArg: null
            );
          },
          icono: Icons.list_alt,
          opciones: [],
        ),
        Opcion(
          roles: ['admin', 'gerente'],  esOpcion: true,
          nombre: 'Agregar personas',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                  menuOptions: mo,
                  child: CreateEditPersonaWidget(
                      item: null,
                      result: (r){
                        Nav.navPop(context: context);
                      },
                      mostrarCancelar: false),
                ),
                settingName: 'CreateEditPersonaWidget',
                settingArg: null
            );
          },
          icono: Icons.add_circle,
          opciones: [],
        ),
        Opcion(
          roles: ['admin'], esOpcion: true,
          nombre: 'Asignar roles y permisos',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: AsignarRolesYPermisosScreen()
              ),
            ),
          );*/
          },
          icono: Icons.security,
          opciones: [],
        ),
      ],
    ),
    // Reportes y Estadísticas
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: false,
      nombre: 'Reportes y Estadísticas',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: ReportesYEstadisticasScreen()
          ),
        ),
      );*/
      },
      icono: Icons.bar_chart,
      opciones: [
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Ventas por período',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: VentasPorPeriodoScreen()
              ),
            ),
          );*/
          },
          icono: Icons.timeline,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'], esOpcion: true,
          nombre: 'Compras por período',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ComprasPorPeriodoScreen()
              ),
            ),
          );*/
          },
          icono: Icons.date_range,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente', 'inventario'],  esOpcion: true,
          nombre: 'Productos más vendidos',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ProductosMasVendidosScreen()
              ),
            ),
          );*/
          },
          icono: Icons.shopping_bag,
          opciones: [],
        ),
        Opcion(
          roles: [ 'gerente', 'inventario'],  esOpcion: true,
          nombre: 'Inventario bajo mínimo',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: InventarioBajoMinimoScreen()
              ),
            ),
          );*/
          },
          icono: Icons.warning,
          opciones: [],
        ),
      ],
    ),

    //Básico
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'],  esOpcion: false,
      nombre: 'Básico',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ProveedoresScreen()
              ),
            ),
          );*/
      },
      icono: Icons.business,
      opciones: [
        Opcion(
          roles: ['gerente'], esOpcion: true,
          nombre: 'Sexo',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.navDropAll(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleSexo()
                ),
                settingName: 'MainModuleSexo',
                settingArg: null
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente'],  esOpcion: true,
          nombre: 'Nacionalidad',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleNacionalidad()
                ),
                settingName: 'MainModuleNacionalidad',
                settingArg: null
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente'],  esOpcion: true,
          nombre: 'Estado Civil',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleEstadoCivil()
                ),
                settingName: 'MainModuleEstadoCivil',
                settingArg: null
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
        Opcion(
          roles: ['gerente'],  esOpcion: true,
          nombre: 'Tipo de Identificacion',
          ejecutar: (BuildContext context, MenuOptions mo){
            Nav.push(
                context: context,
                next: () => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleTipoIdentificacion()
                ),
                settingName: 'MainModuleTipoIdentificacion',
                settingArg: null
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
      ],
    ),


    // Configuraciones
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'],  esOpcion: false,
      nombre: 'Configuraciones',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: ConfiguracionesScreen()
          ),
        ),
      );*/
      },
      icono: Icons.settings,
      opciones: [
        Opcion(
          roles: ['admin'], esOpcion: true,
          nombre: 'Configuración general del sistema',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ConfiguracionGeneralScreen()
              ),
            ),
          );*/
          },
          icono: Icons.system_update,
          opciones: [],
        ),
        Opcion(
          roles: [ 'gerente'],  esOpcion: true,
          nombre: 'Monedas e impuestos',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: MonedasEImpuestosScreen()
              ),
            ),
          );*/
          },
          icono: Icons.attach_money,
          opciones: [],
        ),
        Opcion(
          roles: ['admin', 'gerente'], esOpcion: true,
          nombre: 'Respaldo y restauración de datos',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: RespaldoYRestauracionScreen()
              ),
            ),
          );*/
          },
          icono: Icons.backup,
          opciones: [],
        ),
      ],
    ),

    // Salir del sistema
    Opcion(
      roles: ['admin', 'gerente', 'inventario', 'cajero'], esOpcion: true,
      nombre: 'Salir del sistema',
      ejecutar: (BuildContext context, MenuOptions mo){
        Nav.push(
            context: context,
            next: () => MainLogonWidget(
                menuOptions: mo,
                child: MainModuleTipoIdentificacion()
            ),
            settingName: 'MainModuleTipoIdentificacion',
            settingArg: null
        );

      },
      icono: Icons.exit_to_app,
      opciones: [],
    ),
  ];
}