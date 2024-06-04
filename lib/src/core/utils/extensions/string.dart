extension StringX on String {
  String? get ifEmpty => isEmpty ? null : this;
}
