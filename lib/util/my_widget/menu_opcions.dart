import 'package:flutter/material.dart';
import 'package:sgii_front/util/common/opcion.dart';
import 'package:sgii_front/util/my_widget/main_logon_widget.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/estado_civil/main_module_estado_civil.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/nacionalidad/main_module_nacionalidad.dart';
import 'package:sgii_front/view/mod_logon/mod_09_basicos/sexo/main_module_sexo.dart';

class MenuOptions{
  bool isSidebarVisible = false;
  bool isPinned = false;
  String strSeleccion = "Aun no se selecciono";
  Opcion? seleccion = null;

  List<Opcion> menuOpcion = [
    // Gestión de Inventario
    Opcion(
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
          nombre: 'Ver productos',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: VerProductosScreen()
              ),
            ),
          );*/
          },
          icono: Icons.view_list,
          opciones: [],
        ),
        Opcion(
          nombre: 'Agregar producto',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: AgregarProductoScreen()
              ),
            ),
          );*/
          },
          icono: Icons.add,
          opciones: [],
        ),
        Opcion(
          nombre: 'Existencias',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: ControlDeExistenciasScreen()
              ),
            ),
          );*/
          },
          icono: Icons.check_box,
          opciones: [],
        ),
      ],
    ),

    // Gestión de Compras
    Opcion(
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
          nombre: 'Registrar compra',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: RegistrarCompraScreen()
              ),
            ),
          );*/
          },
          icono: Icons.note_add,
          opciones: [],
        ),
        Opcion(
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
          nombre: 'Notas de crédito (Devoluciones)',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: NotasDeCreditoComprasScreen()
              ),
            ),
          );*/
          },
          icono: Icons.credit_score,
          opciones: [
            Opcion(
              nombre: 'Registrar devolución de compra',
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
              nombre: 'Historial de devoluciones',
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
      ],
    ),


    // Gestión de Ventas
    Opcion(
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
          nombre: 'Registrar venta',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: RegistrarVentaScreen()
              ),
            ),
          );*/
          },
          icono: Icons.add_shopping_cart,
          opciones: [],
        ),
        Opcion(
          nombre: 'Facturación de venta',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: FacturacionDeVentaScreen()
              ),
            ),
          );*/
          },
          icono: Icons.receipt_long,
          opciones: [],
        ),
        Opcion(
          nombre: 'Notas de crédito (Devoluciones)',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: NotasDeCreditoVentasScreen()
              ),
            ),
          );*/
          },
          icono: Icons.credit_score,
          opciones: [
            Opcion(
              nombre: 'Registrar devolución de venta',
              ejecutar: (BuildContext context, MenuOptions mo){
                /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: RegistrarDevolucionVentaScreen()
                  ),
                ),
              );*/
              },
              icono: Icons.add_box,
              opciones: [],
            ),
            Opcion(
              nombre: 'Historial de devoluciones',
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
      ],
    ),

    //Cliente
    Opcion(
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
          nombre: 'Ver clientes',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: VerClientesScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.list_alt,
          opciones: [],
        ),
        Opcion(
          nombre: 'Agregar cliente',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: AgregarClienteScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.add_circle,
          opciones: [],
        ),
      ],
    ),
    Opcion(
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
          nombre: 'Ver proveedores',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: VerProveedoresScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.list,
          opciones: [],
        ),
        Opcion(
          nombre: 'Agregar proveedor',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainLogonWidget(
                      menuOptions: mo,
                      child: AgregarProveedorScreen()
                  ),
                ),
              );*/
          },
          icono: Icons.add_business,
          opciones: [],
        ),
      ],
    ),
    // Gestión de Usuarios
    Opcion(
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
          nombre: 'Ver usuarios',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: VerUsuariosScreen()
              ),
            ),
          );*/
          },
          icono: Icons.list_alt,
          opciones: [],
        ),
        Opcion(
          nombre: 'Agregar usuario',
          ejecutar: (BuildContext context, MenuOptions mo){
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLogonWidget(
                  menuOptions: mo,
                  child: AgregarUsuarioScreen()
              ),
            ),
          );*/
          },
          icono: Icons.add_circle,
          opciones: [],
        ),
        Opcion(
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
          nombre: 'Sexo',
          ejecutar: (BuildContext context, MenuOptions mo){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleSexo()
                ),
              ),
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
        Opcion(
          nombre: 'Nacionalidad',
          ejecutar: (BuildContext context, MenuOptions mo){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleNacionalidad()
                ),
              ),
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
        Opcion(
          nombre: 'Estado Civil',
          ejecutar: (BuildContext context, MenuOptions mo){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainLogonWidget(
                    menuOptions: mo,
                    child: MainModuleEstadoCivil()
                ),
              ),
            );
          },
          icono: Icons.groups,
          opciones: [],
        ),
      ],
    ),


    // Configuraciones
    Opcion(
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
      nombre: 'Salir del sistema',
      ejecutar: (BuildContext context, MenuOptions mo){
        /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogonWidget(
              menuOptions: mo,
              child: SalirDelSistemaScreen()
          ),
        ),
      );*/
      },
      icono: Icons.exit_to_app,
      opciones: [],
    ),
  ];

}