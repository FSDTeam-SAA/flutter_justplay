class PitchFilters {
  final double? minPrice;
  final double? maxPrice;
  final bool onlyAvailable;
  final double? maxDistanceKm;

  const PitchFilters({
    this.minPrice,
    this.maxPrice,
    this.onlyAvailable = false,
    this.maxDistanceKm,
  });

  bool get isActive =>
      minPrice != null ||
      maxPrice != null ||
      onlyAvailable ||
      maxDistanceKm != null;

  PitchFilters copyWith({
    double? minPrice,
    double? maxPrice,
    bool? onlyAvailable,
    double? maxDistanceKm,
    bool clearMaxDistance = false,
  }) {
    return PitchFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      maxDistanceKm: clearMaxDistance ? null : (maxDistanceKm ?? this.maxDistanceKm),
    );
  }
}
