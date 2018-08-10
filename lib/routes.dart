import 'package:flutter/material.dart';
import 'package:inventario/screens/usuarios/user_zona.dart';
import 'package:inventario/screens/usuarios/user_producto_zona.dart';
import 'package:inventario/screens/usuarios/user_conteo_producto.dart';
import 'package:inventario/screens/login/login_screen.dart';
import 'package:inventario/screens/home/splash_screen.dart';
import 'package:inventario/screens/usuarios/tabbar.dart';

final routes = {
  '/login_screen':         (BuildContext context) => new LoginScreen(),
  '/user_zona':         (BuildContext context) => new UserZonas(),
  '/user_producto_zona':     (BuildContext context) => new UserProductoZona(),
  '/user_conteo_producto':     (BuildContext context) => new UserConteoProducto(),
  '/user_tab_bar':     (BuildContext context) => new AppBarBottomSample(),
  '/' :          (BuildContext context) => new SplashScreen(),//pantalla por default
};