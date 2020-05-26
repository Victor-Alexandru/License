import 'package:moodle_ui/data/rest_ds.dart';
import 'package:moodle_ui/models/token.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(Token token, String username);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((Token token) {
      _view.onLoginSuccess(token, username);
    }).catchError((Object error) {
      _view.onLoginError(error.toString());
    });
  }
}
