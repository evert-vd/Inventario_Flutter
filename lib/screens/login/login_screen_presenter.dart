import 'package:inventario/data/rest_login.dart';
import 'package:inventario/models/usuario.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Usuario user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((Usuario user) {
      _view.onLoginSuccess(user);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}