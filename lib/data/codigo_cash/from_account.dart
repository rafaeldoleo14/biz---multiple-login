class FromAccount {
  final String type;
  final bool isOpen;
  final List<FromAccountList>? list;

  FromAccount({required this.type, required this.isOpen, this.list});
}

class FromAccountList {
  final String name;
  final String currentBalance;
  final String coin;
  final String avaliableBalance;

  FromAccountList({
    required this.name,
    required this.currentBalance,
    required this.coin,
    required this.avaliableBalance,
  });
}

final List<FromAccount> fromAccountList = [
  FromAccount(
    type: 'IMPORTADORA DLF',
    isOpen: true,
    list: [
      FromAccountList(
        name: "Cuenta Corriente / 799792901",
        currentBalance: "907,450.29",
        coin: "RD\$",
        avaliableBalance: "907,450.29",
      ),
      FromAccountList(
        name: "Cuenta Corriente / 799792901",
        currentBalance: "23.94",
        coin: "RD\$",
        avaliableBalance: "23.94",
      ),
      FromAccountList(
        name: "Cuenta de Ahorro / 899123456",
        currentBalance: "0.00",
        coin: "RD\$",
        avaliableBalance: "0.00",
      ),
      FromAccountList(
        name: "Cuenta de Ahorro / 699123456",
        currentBalance: "3,250.22",
        coin: "EU\$",
        avaliableBalance: "3,250.22",
      ),
    ],
  ),
  FromAccount(type: 'MAT DISTRIBUIDORA', isOpen: false),
  FromAccount(type: 'GARP SRL', isOpen: false),
];
