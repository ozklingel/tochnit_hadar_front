enum UserRole {
  other(-2),
  apprentice(-1),
  melave(0),
  rakazMosad(1),
  rakazEshkol(2),
  ahraiTohnit(3);

  const UserRole(this.val);

  final int val;

  String get name => switch (this) {
        UserRole.melave => 'מלווה',
        UserRole.rakazMosad => 'רכז מוסד',
        UserRole.rakazEshkol => 'רכז אשכול',
        UserRole.ahraiTohnit => 'אחראי תכנית',
        _ => 'USER.ROLE.ERROR',
      };

  // hierarchies
  bool get isAhraiTohnit => this == UserRole.ahraiTohnit;
  bool get isRakazEshkolPlus => isAhraiTohnit || this == UserRole.rakazEshkol;
  bool get isRakazMosad => this == UserRole.rakazMosad;
  bool get isRakazMosadPlus => isRakazEshkolPlus || this == UserRole.rakazMosad;
  bool get isMelavePlus => isRakazMosadPlus || this == UserRole.melave;
  bool get isMelave => this == UserRole.melave;
}
