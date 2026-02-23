import 'package:flutter/material.dart';

@immutable
class LoggedUser {
  final String company;
  final String username;
  final String password;

  const LoggedUser({
    required this.company,
    required this.username,
    required this.password,
  });

  LoggedUser copyWith({String? company, String? username, String? password}) {
    return LoggedUser(
      company: company ?? this.company,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

class MultipleLoginProvider with ChangeNotifier {
  final List<String> companies = [
    "The Coca Cola Company For DR",
    "PepsiCo Inc.",
    "Nestle S.A.",
    "The Kraft Heinz Company",
    "Unilever PLC",
    "Dr Pepper Snapple Group",
    "Mondelez International",
    "Danone S.A.",
    "Reckitt Benckiser Group PLC",
  ];

  LoggedUser? _loggedUser;

  LoggedUser? get loggedUser => _loggedUser;
  bool get isLoggedIn => _loggedUser != null;

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

    _loggedUser = LoggedUser(company: c, username: u, password: password);

    addCompany(c);
  }

  void logout() {
    _loggedUser = null;
    notifyListeners();
  }
}
