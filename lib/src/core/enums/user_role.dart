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

  bool get isProgramDirector => this == UserRole.ahraiTohnit;
}
