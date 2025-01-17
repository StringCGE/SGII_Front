
import 'package:flutter/material.dart';
import 'package:sgii_front/util/my_widget/menu_opcions.dart';
import 'package:sgii_front/util/common/opcion.dart';

class MainLogonWidget extends StatefulWidget {
  final MenuOptions menuOptions;//List<Opcion> Function(BuildContext context)
  final Widget child;
  MainLogonWidget({
    super.key,
    required this.menuOptions,
    required this.child,
  });

  MainLogonWidgetState createState() => MainLogonWidgetState();
}

class MainLogonWidgetState extends State<MainLogonWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  late MenuOptions mo;
  late List<Opcion> lo;
  @override
  void initState() {
    super.initState();
    mo = widget.menuOptions;
    mo.isSidebarVisible = false;
    lo = mo.menuOpcion;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      mo.isSidebarVisible = !mo.isSidebarVisible;
      if (mo.isSidebarVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _togglePin() {
    setState(() {
      mo.isPinned = !mo.isPinned;
      if (mo.isPinned) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mo.strSeleccion),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleSidebar,
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              if (mo.isPinned)
                Container(
                  width: 250,
                  color: Colors.blueGrey[900],//Color.fromARGB(215, 211, 189, 49),
                  child: _buildSidebarContent(),
                ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      if (!mo.isPinned && mo.isSidebarVisible) {
                        _toggleSidebar();
                      }
                    },
                    child: widget.child//widSeleccionado
                ),
              ),
            ],
          ),
          if (!mo.isPinned && mo.isSidebarVisible)
            GestureDetector(
              onTap: _toggleSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          if (!mo.isPinned && mo.isSidebarVisible)
            Row(
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: 250,
                    color: Colors.blueGrey[900],
                    child: _buildSidebarContent(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  mo.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: Colors.white,
                ),
                onPressed: _togglePin,
              ),
            ],
          ),
          Divider(color: Colors.white54),
          Expanded(
            child: ListView(
              children: [
                ...lo.map((item) => SidebarItemWidget(
                  opcion: item,
                  mo: mo,
                  seleccion: mo.seleccion,
                  onSeleccion: (Opcion? opcion){
                    if (opcion != null){
                      mo.seleccion = opcion;
                      mo.strSeleccion = mo.seleccion!.nombre;
                      mo.seleccion!.ejecutar(context, mo);
                    }
                    setState(() {});
                  },
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }




}




class SidebarItemWidget extends StatefulWidget {
  final Opcion opcion;
  final MenuOptions mo;
  final Function(Opcion? opcion) onSeleccion;
  final Opcion? seleccion; // Opción seleccionada, puede ser null si no hay ninguna seleccionada.

  SidebarItemWidget({
    required this.opcion,
    required this.mo,
    required this.onSeleccion,
    this.seleccion, // Se pasa la opción seleccionada desde el widget padre.
  });

  @override
  _SidebarItemWidgetState createState() => _SidebarItemWidgetState();
}


class _SidebarItemWidgetState extends State<SidebarItemWidget> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.opcion == widget.seleccion;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.opcion.opciones.isNotEmpty) {
            widget.opcion.isSubmenuVisible = !widget.opcion.isSubmenuVisible;
            widget.onSeleccion(null);
          } else {
            widget.opcion.ejecutar(context, widget.mo);
            widget.onSeleccion(widget.opcion);
          }
        });
      },
      child: Container(
        //color: isSelected ? Colors.blue[600] : (widget.opcion.isSubmenuVisible ? Colors.blue[800] : Colors.transparent),
        color: Colors.transparent,
        child: Column(
          children: [
            ListTile(
              leading: widget.opcion.icono != null
                  ? Icon(widget.opcion.icono, color: Colors.white)
                  : null, // Si no hay ícono, no se muestra nada
              title: Text(
                widget.opcion.nombre,
                style: TextStyle(
                  color: isSelected ? Colors.yellow : Colors.white, // Cambiar color de texto si está seleccionado
                  fontSize: 18,
                ),
              ),
            ),
            // Mostrar submenú si está visible
            if (widget.opcion.isSubmenuVisible && widget.opcion.opciones.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: widget.opcion.opciones.map((subOpcion) {
                    return SidebarItemWidget(
                      opcion: subOpcion,
                      mo: widget.mo,
                      onSeleccion: (Opcion? opcion) {
                        widget.onSeleccion(opcion);
                      },
                      seleccion: widget.seleccion, // Pasamos la opción seleccionada al submenú
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}