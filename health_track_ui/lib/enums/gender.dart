enum Gender {
  male('M'),
  female('F'),
  other('O');

  final String value;
  const Gender(this.value);

  static Gender? fromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (gender) => gender.value == value,
      orElse: () => Gender.other,
    );
  }
}
