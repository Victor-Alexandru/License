class Token {
  String _access;
  String _refresh;
  Token(this._access, this._refresh);

  Token.map(dynamic obj) {
    this._access = obj["access"];
    this._refresh = obj["refresh"];
  }

  String get access => _access;
  String get refresh => _refresh;
}
