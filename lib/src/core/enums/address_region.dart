enum AddressRegion {
  unknown(-1),
  center(0),
  jerusalem(1),
  north(2),
  south(3),
  judea(4);

  const AddressRegion(this.val);
  final int val;

  static AddressRegion fromString(String val) => values
      .firstWhere((e) => e.val == int.tryParse(val), orElse: () => unknown);

  static List<AddressRegion> get regions =>
      values.where((e) => e != unknown).toList();

  String get name {
    switch (this) {
      // TODO: OZ FIX FOR CORRECT VALUES OR ELSE RETURNS ERROR ON UPDATING
      case AddressRegion.center:
        return 'מחוז מרכז';
      case AddressRegion.jerusalem:
        return 'ירושלים והסביבה';
      case AddressRegion.north:
        return 'מחוז צפון';
      case AddressRegion.judea:
        return 'יהודה ושומרון';
      case AddressRegion.south:
        return 'מחוז דרום';
      case AddressRegion.unknown:
        return 'ללא';
    }
  }
}

extension RegionX on AddressRegion {
  bool get isEmpty => this == AddressRegion.unknown;
}
