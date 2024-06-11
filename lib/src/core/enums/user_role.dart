enum UserRole {
  melave(0),

  rakazMosad(1),

  rakazEshkol(2),
  ahraiTohnit(3),

  apprentice(500),
  other(800);

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
