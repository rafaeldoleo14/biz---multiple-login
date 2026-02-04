import 'package:biz_codigo_cash/data/codigo_cash/beneficiary.dart';
import 'package:biz_codigo_cash/data/codigo_cash/from_account.dart';
import 'package:flutter/material.dart';

class CashCodeProvider extends ChangeNotifier {
  FromAccountList? selectedAccount;

  set onSelectedAccount(FromAccountList account) {
    if (selectedAccount == null) {
      selectedAccount = account;
    } else {
      selectedAccount = null;
    }

    notifyListeners();
  }

  // Exits beneficiary

  final List<BeneficiaryCash> beneficiaryCashList = [
    BeneficiaryCash(
      id: 1,
      name: 'Facundo Cabral',
      phone: '(809) 765-4321',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
    BeneficiaryCash(
      id: 2,
      name: 'Isabella Rossellini',
      phone: '(809) 765-1234',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
    BeneficiaryCash(
      id: 3,
      name: 'Gabriel Garcia Marquez',
      phone: '(809) 765-5678',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
    BeneficiaryCash(
      id: 4,
      name: 'Salma Hayek',
      phone: '(809) 765-8765',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
    BeneficiaryCash(
      id: 5,
      name: 'Carlos Santana',
      phone: '(809) 765-4320',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
    BeneficiaryCash(
      id: 6,
      name: 'Frida Kahlo',
      phone: '(809) 765-9876',
      amount: 200.00,
      type: 'Beneficiario cash',
    ),
  ];

  void onAmount(BeneficiaryCash beneficiary, double amount) {
    for (var item in beneficiaryCashList) {
      if (item.id == beneficiary.id) {
        final newAmount = item.amount + amount;

        if (item.amount >= 20000 && amount >= 0) {
          // Ya está en el máximo, no se suma más
          return;
        } else if (newAmount > 20000) {
          // Si al sumar pasa de 20,000, ajústalo a 20,000 exactos
          item.amount = 20000;
        } else if (newAmount <= 200) {
          item.amount = 200;
        } else {
          // Si todavía no llega, suma normalmente
          item.amount = newAmount;
        }

        break;
      }
    }
    notifyListeners();
  }

  // Beneficiary

  List<BeneficiaryCash> selectedBeneficiaries = [];

  void onSelectedBeneficiaries(BeneficiaryCash beneficiary) {
    selectedBeneficiaries.add(beneficiary);
    notifyListeners();
  }

  void removeBeneficiary(BeneficiaryCash beneficiary) {
    // Restablece su monto antes de eliminarlo
    beneficiary.amount = 200.00;

    // Elimina el beneficiario de la lista
    selectedBeneficiaries.remove(beneficiary);

    // Notifica el cambio
    notifyListeners();
  }

  // New Beneficiary Form

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  TextEditingController lastNameController = TextEditingController();
  FocusNode lastNameFocusNode = FocusNode();

  TextEditingController phoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  TextEditingController cedulaController = TextEditingController();
  FocusNode cedulaFocusNode = FocusNode();

  void onNotifyChanges() {
    notifyListeners();
  }

  double newBeneficiaryAmount = 200.00;

  void onCreateNewBeneficiary() {
    BeneficiaryCash newBeneficiary = BeneficiaryCash(
      id: beneficiaryCashList.length + 1,
      name: '${nameController.text} ${lastNameController.text}',
      phone: '(809) ${phoneController.text}',
      amount: newBeneficiaryAmount,
      type: 'Nuevo beneficiario',
    );

    beneficiaryCashList.insert(0, newBeneficiary);
    onSelectedBeneficiaries(newBeneficiary);
    onCancelNewBeneficiary();
    notifyListeners();
  }

  void onCancelNewBeneficiary() {
    nameController.text = '';
    lastNameController.text = '';
    phoneController.text = '';
    cedulaController.text = '';
    newBeneficiaryAmount = 200.00;
    notifyListeners();
  }
}
