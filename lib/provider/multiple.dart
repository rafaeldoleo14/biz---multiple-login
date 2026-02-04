// multiple_activation_provider.dart

import 'dart:math';
import 'package:flutter/material.dart';

/// Los posibles estados de activación de la tarjeta.
enum Status {
  activacionPendiente('Activación pendiente'),
  estatusNoValidado('Estatus no validado'),
  activacionCompletada('Activación completada'),
  activacionFallida('Tarjeta no activada');

  final String label;
  const Status(this.label);
  @override
  String toString() => label;
}

/// Modelo de tarjeta con flags [isLoading], estado mutable y selección.
class CardI {
  final String name;
  final double balance;
  final String coin;
  Status status;
  bool isLoading;
  bool selectedForActivation;

  CardI({
    required this.name,
    required this.balance,
    required this.coin,
    required this.status,
    this.isLoading = false,
    this.selectedForActivation = false,
  });
}

/// Provider que genera 35 tarjetas y maneja:
///  - Carga con delays aleatorios
///  - Reordenamiento por status una vez cargadas
///  - Activación múltiple de hasta 20 tarjetas pendientes
///  - Randomización de status en no validadas
///  - Control de scroll para UI
class MultipleActivationProvider with ChangeNotifier {
  final Random _rnd = Random();

  /// Lista de todas las tarjetas.
  late List<CardI> cards;

  List<CardI> get selectedCards {
    final list = cards.where((c) => c.selectedForActivation).toList();
    list.sort((a, b) {
      int rank(Status s) {
        if (s == Status.activacionFallida) return 0;
        if (s == Status.activacionCompletada) return 1;
        return 2; // cualquier otro estado
      }

      return rank(a.status).compareTo(rank(b.status));
    });
    return list;
  }

  /// Flag global de carga.
  bool isLoadingAll = false;

  /// Indica si el contenedor está abierto.
  bool isOpenContainer = false;

  /// Modo de selección múltiple.
  bool multipleActivation = false;

  /// ScrollController para la UI.
  final ScrollController scrollController = ScrollController();
  bool showScrollToTop = false;

  MultipleActivationProvider() {
    cards = _generateRandomCards();
    scrollController.addListener(() {
      final shouldShow = scrollController.offset > 50;
      if (shouldShow != showScrollToTop) {
        showScrollToTop = shouldShow;
        notifyListeners();
      }
    });
  }

  /// Genera 35 tarjetas aleatorias según distribuciones.
  List<CardI> _generateRandomCards() {
    const total = 35, pendings = 25;
    final list = <CardI>[];
    for (var i = 0; i < pendings; i++) {
      list.add(_makeRandomCard(_rnd, forcedStatus: Status.activacionPendiente));
    }
    const otherCount = total - pendings;
    final noValidCount = _rnd.nextInt(3);
    final noValidIdx = <int>{};
    while (noValidIdx.length < noValidCount) {
      noValidIdx.add(_rnd.nextInt(otherCount));
    }
    for (var i = 0; i < otherCount; i++) {
      final st = noValidIdx.contains(i)
          ? Status.estatusNoValidado
          : Status.activacionCompletada;
      list.add(_makeRandomCard(_rnd, forcedStatus: st));
    }
    list.shuffle(_rnd);
    return list;
  }

  /// Crea una tarjeta con cuatro dígitos aleatorios y balance.
  static CardI _makeRandomCard(Random rnd, {required Status forcedStatus}) {
    final last4 = rnd.nextInt(10000).toString().padLeft(4, '0');
    final balance = double.parse(
      (rnd.nextDouble() * 100000).toStringAsFixed(2),
    );
    return CardI(
      name: 'Tarjeta de crédito / *$last4',
      balance: balance,
      coin: 'RD',
      status: forcedStatus,
    );
  }

  /// Ordena las tarjetas por status: no validado → pendiente → completada.
  void _sortByStatus() {
    cards.sort((a, b) {
      int rank(Status s) {
        if (s == Status.estatusNoValidado) return 0;
        if (s == Status.activacionPendiente) return 1;
        return 2;
      }

      return rank(a.status).compareTo(rank(b.status));
    });
  }

  /// Inicia la carga de todas las tarjetas (2–7s), luego reordena.
  Future<void> loadCards() async {
    isLoadingAll = true;
    for (var c in cards) {
      c.isLoading = true;
    }
    notifyListeners();

    final futures = cards.map((c) {
      final secs = _rnd.nextInt(6) + 2;
      return Future.delayed(Duration(seconds: secs), () {
        c.isLoading = false;
        notifyListeners();
      });
    }).toList();
    await Future.wait(futures);

    isLoadingAll = false;
    _sortByStatus();
    notifyListeners();
  }

  /// Randomiza el status de una tarjeta no validada.
  Future<void> randomizeCardStatus(CardI card) async {
    if (card.status != Status.estatusNoValidado) return;
    card.isLoading = true;
    notifyListeners();
    final secs = _rnd.nextInt(6) + 2;
    await Future.delayed(Duration(seconds: secs));
    final others = Status.values
        .where((s) => s != Status.estatusNoValidado)
        .toList();
    card.status = others[_rnd.nextInt(others.length)];
    card.isLoading = false;
    _sortByStatus();
    notifyListeners();
  }

  /// Alterna modo multipleActivation, selecciona primeras 20 y reordena selección.
  set onMultipleActivation(bool value) {
    multipleActivation = value;
    for (var c in cards) {
      c.selectedForActivation = false;
    }
    if (value) {
      final pendings = cards
          .where((c) => c.status == Status.activacionPendiente)
          .toList();
      for (var i = 0; i < pendings.length && i < 20; i++) {
        pendings[i].selectedForActivation = true;
      }
      // reordenar para mostrar seleccionadas primero
      cards.sort((a, b) {
        if (a.selectedForActivation && !b.selectedForActivation) return -1;
        if (!a.selectedForActivation && b.selectedForActivation) return 1;
        return 0;
      });
    } else {
      // volver al orden por status al desactivar
      _sortByStatus();
    }
    notifyListeners();
  }

  /// Alterna la selección individual y reordena.
  void toggleSelectedForActivation(CardI card) {
    card.selectedForActivation = !card.selectedForActivation;
    if (multipleActivation) {
      cards.sort((a, b) {
        if (a.selectedForActivation && !b.selectedForActivation) return -1;
        if (!a.selectedForActivation && b.selectedForActivation) return 1;
        return 0;
      });
    }
    notifyListeners();
  }

  /// Desmarca todas las selecciones y reordena.
  void clearAllSelections() {
    for (var c in cards) {
      c.selectedForActivation = false;
    }
    if (multipleActivation) _sortByStatus();
    notifyListeners();
  }

  /// Selecciona las primeras 20 pendientes y reordena.
  void selectFirst20Pendings() {
    clearAllSelections();
    final pendings = cards
        .where((c) => c.status == Status.activacionPendiente)
        .toList();
    for (var i = 0; i < pendings.length && i < 20; i++) {
      pendings[i].selectedForActivation = true;
    }
    cards.sort((a, b) {
      if (a.selectedForActivation && !b.selectedForActivation) return -1;
      if (!a.selectedForActivation && b.selectedForActivation) return 1;
      return 0;
    });
    notifyListeners();
  }

  /// Forza un repaint manual.
  void onNotifyChanges() {
    notifyListeners();
  }

  bool cardFaild = false;

  /// Activa las tarjetas seleccionadas (de 2 a 10), simula recarga de 2–7 s
  /// y asigna un estado final (completada o fallida).
  Future<void> activateSelectedCards({bool again = false}) async {
    // 1. Obtener las tarjetas a procesar
    final List<CardI> toActivate = again
        ? selectedCards
              .where((c) => c.status == Status.activacionFallida)
              .toList()
        : selectedCards;

    if (toActivate.isEmpty) return; // nada que hacer

    // 2. Decidir cuáles fallan SOLAMENTE en la primera corrida
    final Set<int> failIdx = <int>{};
    if (!again) {
      final failCount = _rnd.nextInt(min(3, toActivate.length)); // 0–2 fallos
      while (failIdx.length < failCount) {
        failIdx.add(_rnd.nextInt(toActivate.length));
      }
    }

    // 3. Marcar todas en loading y notificar
    for (final c in toActivate) {
      c.isLoading = true;
    }
    notifyListeners();

    // 4. Simular activación (10–20 s)
    final futures = <Future<void>>[];
    for (var i = 0; i < toActivate.length; i++) {
      final card = toActivate[i];
      final secs = _rnd.nextInt(11) + 10; // 10–20 s
      futures.add(
        Future.delayed(Duration(seconds: secs), () {
          final success =
              again || !failIdx.contains(i); // nunca falla en reintento

          card.isLoading = false;
          card.status = success
              ? Status.activacionCompletada
              : Status.activacionFallida;

          // Si es reintento y ahora sí se activó, quitamos la selección
          // if (again && success) card.selectedForActivation = false;

          notifyListeners(); // refresco por tarjeta
        }),
      );
    }

    // 5. Esperar a que todas terminen
    await Future.wait(futures);

    // 6. Reordenar y actualizar UI
    _sortByStatus();
    notifyListeners();
  }

  void resetFlow() {
    multipleActivation = false;
    cardFaild = false;

    for (var c in cards) {
      // 2. limpia todas las selecciones
      c.selectedForActivation = false;
    }
    _sortByStatus(); // 3. vuelve al orden estándar
    notifyListeners();
  }
}
