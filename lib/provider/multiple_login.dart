import 'package:flutter/material.dart';

@immutable
class LoggedUser {
  final String company;
  final String username;
  final String password;

  final bool biometricsEnabled;

  const LoggedUser({
    required this.company,
    required this.username,
    required this.password,
    this.biometricsEnabled = false,
  });

  LoggedUser copyWith({
    String? company,
    String? username,
    String? password,
    bool? biometricsEnabled,
  }) {
    return LoggedUser(
      company: company ?? this.company,
      username: username ?? this.username,
      password: password ?? this.password,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}

class MultipleLoginProvider with ChangeNotifier {
  final List<String> companies = [
    // "The Coca Cola Company For DR",
    // "PepsiCo Inc.",
    // "Nestle S.A.",
    // "The Kraft Heinz Company",
    // "Unilever PLC",
    // "Dr Pepper Snapple Group",
    // "Mondelez International",
    // "Danone S.A.",
    // "Reckitt Benckiser Group PLC",
  ];

  LoggedUser? _loggedUser;

  final Map<String, bool> _biometricsByAccount = {};

  LoggedUser? get loggedUser => _loggedUser;
  bool get isLoggedIn => _loggedUser != null;

  // bool get bool isMultipleRncs => companies.length > 1 ? true : false;
  bool get isMultipleRncs => companies.length > 1;

  String _accountKey(String company, String username) {
    return '${company.trim().toLowerCase()}|${username.trim().toLowerCase()}';
  }

  bool isBiometricsEnabled({
    required String company,
    required String username,
  }) {
    final key = _accountKey(company, username);
    return _biometricsByAccount[key] ?? false;
  }

  void setBiometricsEnabled({
    required String company,
    required String username,
    required bool enabled,
  }) {
    final c = company.trim();
    final u = username.trim();
    if (c.isEmpty || u.isEmpty) return;

    final key = _accountKey(c, u);
    _biometricsByAccount[key] = enabled;

    final lu = _loggedUser;
    if (lu != null &&
        lu.company.trim().toLowerCase() == c.toLowerCase() &&
        lu.username.trim().toLowerCase() == u.toLowerCase()) {
      _loggedUser = lu.copyWith(biometricsEnabled: enabled);
    }

    notifyListeners();
  }

  void addCompany(String company) {
    final newValue = company.trim();
    if (newValue.isEmpty) return;
    final normalized = newValue.toLowerCase();

    // Busca si ya existe (ignorando mayúsculas/minúsculas y espacios)
    final existingIndex = companies.indexWhere(
      (c) => c.trim().toLowerCase() == normalized,
    );

    if (existingIndex != -1) {
      // Ya existe: la quitamos para luego ponerla arriba (sin duplicar)
      companies.removeAt(existingIndex);
    }

    companies.insert(0, newValue);
    notifyListeners();
  }

  void login({
    required String company,
    required String username,
    required String password,
  }) {
    final c = company.trim();
    final u = username.trim();

    if (c.isEmpty || u.isEmpty || password.isEmpty) return;

    final enabled = isBiometricsEnabled(company: c, username: u);

    _loggedUser = LoggedUser(
      company: c,
      username: u,
      password: password,
      biometricsEnabled: enabled,
    );

    addCompany(c);
    notifyListeners();
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
  }
}
