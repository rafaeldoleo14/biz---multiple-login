class DepositDraftArgs {
  // Empresa / contexto del flujo
  final String companyId; // <- NUEVO (obligatorio para filtrar por empresa)
  final String currencyCode; // <- NUEVO ('DOP' | 'USD' | 'EUR')

  // Cuenta origen
  final String accountId;
  final String currencyPrefix;
  final double minAmount;
  final double availableBalance;
  final String originAccountType;
  final String originAccountNumber;

  // Monto + plazo/tasa
  final double amount;
  final int termDays;
  final double annualRate;
  final double estimatedInterest;
  final double accumulate;
  final DateTime dueDate;

  const DepositDraftArgs({
    required this.companyId,
    required this.currencyCode,
    required this.accountId,
    required this.currencyPrefix,
    required this.minAmount,
    required this.availableBalance,
    required this.originAccountType,
    required this.originAccountNumber,
    required this.amount,
    required this.termDays,
    required this.annualRate,
    required this.estimatedInterest,
    required this.accumulate,
    required this.dueDate,
  });

  DepositDraftArgs copyWith({
    String? companyId,
    String? currencyCode,
    double? amount,
    int? termDays,
    double? annualRate,
    double? estimatedInterest,
    double? accumulate,
    DateTime? dueDate,
  }) {
    return DepositDraftArgs(
      companyId: companyId ?? this.companyId,
      currencyCode: currencyCode ?? this.currencyCode,
      accountId: accountId,
      currencyPrefix: currencyPrefix,
      minAmount: minAmount,
      availableBalance: availableBalance,
      originAccountType: originAccountType,
      originAccountNumber: originAccountNumber,
      amount: amount ?? this.amount,
      termDays: termDays ?? this.termDays,
      annualRate: annualRate ?? this.annualRate,
      estimatedInterest: estimatedInterest ?? this.estimatedInterest,
      accumulate: accumulate ?? this.accumulate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
