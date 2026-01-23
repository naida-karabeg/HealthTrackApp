enum BloodType {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-');

  final String value;
  const BloodType(this.value);

  static BloodType? fromString(String? value) {
    if (value == null) return null;
    return BloodType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => BloodType.oPositive,
    );
  }
}
