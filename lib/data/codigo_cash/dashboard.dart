class Product {
  final String type;
  final bool isOpen;
  final List<ProductList>? list;

  Product({required this.type, required this.isOpen, this.list});
}

class ProductList {
  final String name;
  final String currentBalance;
  final String coin;
  final String avaliableBalance;

  ProductList({
    required this.name,
    required this.currentBalance,
    required this.coin,
    required this.avaliableBalance,
  });
}

final List<Product> productList = [
  Product(
    type: 'IMPORTADORA DLF',
    isOpen: true,
    list: [
      ProductList(
        name: "Depósito / *5678",
        currentBalance: "51,076,880.43",
        coin: "RD\$",
        avaliableBalance: "907,450.29",
      ),
      // ProductList(
      //   name: "Cuenta Corriente / *2901",
      //   currentBalance: "23.94",
      //   coin: "RD\$",
      //   avaliableBalance: "23.94",
      // ),
      // ProductList(
      //   name: "Cuenta de Ahorro / *3456",
      //   currentBalance: "0.00",
      //   coin: "RD\$",
      //   avaliableBalance: "0.00",
      // ),
      // ProductList(
      //   name: "Cuenta de Ahorro / *6936",
      //   currentBalance: "3,250.22",
      //   coin: "EU\$",
      //   avaliableBalance: "3,250.22",
      // ),
    ],
  ),
  Product(type: 'MAT DISTRIBUIDORA', isOpen: false),
  Product(type: 'GARP SRL', isOpen: false),
];

class FilterProduct {
  final String title;

  FilterProduct({required this.title});
}

final List<FilterProduct> filterList = [
  FilterProduct(title: 'Resumen'),
  FilterProduct(title: 'Cuentas'),
  FilterProduct(title: 'Préstamos'),
  FilterProduct(title: 'Tarjetas'),
  FilterProduct(title: 'Depósito a plazo'),
];
