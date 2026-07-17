import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/pitch_filters.dart';

class PitchFilterSheet extends StatefulWidget {
  final PitchFilters initial;
  final bool hasLocation;

  const PitchFilterSheet({
    super.key,
    required this.initial,
    required this.hasLocation,
  });

  @override
  State<PitchFilterSheet> createState() => _PitchFilterSheetState();
}

class _PitchFilterSheetState extends State<PitchFilterSheet> {
  late RangeValues _priceRange;
  late bool _onlyAvailable;
  late double _maxDistance;
  late bool _useDistanceFilter;

  static const double _maxPriceCeiling = 500000;
  static const double _maxDistanceCeiling = 50;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.initial.minPrice ?? 0,
      widget.initial.maxPrice ?? _maxPriceCeiling,
    );
    _onlyAvailable = widget.initial.onlyAvailable;
    _useDistanceFilter = widget.initial.maxDistanceKm != null;
    _maxDistance = widget.initial.maxDistanceKm ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'filter_pitches'.tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          Text('price_range'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: _maxPriceCeiling,
            divisions: 50,
            activeColor: const Color(0xFFE0E400),
            labels: RangeLabels(
              _priceRange.start.round().toString(),
              _priceRange.end.round().toString(),
            ),
            onChanged: (value) => setState(() => _priceRange = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_priceRange.start.round().toString()),
              Text(_priceRange.end.round().toString()),
            ],
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('only_show_available'.tr),
            value: _onlyAvailable,
            activeThumbColor: const Color(0xFFE0E400),
            onChanged: (value) => setState(() => _onlyAvailable = value),
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('filter_by_distance'.tr),
            subtitle: widget.hasLocation
                ? null
                : Text(
                    'enable_location_to_filter_distance'.tr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
            value: _useDistanceFilter && widget.hasLocation,
            activeThumbColor: const Color(0xFFE0E400),
            onChanged: widget.hasLocation
                ? (value) => setState(() => _useDistanceFilter = value)
                : null,
          ),
          if (_useDistanceFilter && widget.hasLocation) ...[
            Slider(
              value: _maxDistance,
              min: 1,
              max: _maxDistanceCeiling,
              divisions: 49,
              activeColor: const Color(0xFFE0E400),
              label: '${_maxDistance.round()} km',
              onChanged: (value) => setState(() => _maxDistance = value),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${_maxDistance.round()} km'),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(const PitchFilters());
                  },
                  child: Text('reset'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(
                      PitchFilters(
                        minPrice: _priceRange.start > 0 ? _priceRange.start : null,
                        maxPrice:
                            _priceRange.end < _maxPriceCeiling ? _priceRange.end : null,
                        onlyAvailable: _onlyAvailable,
                        maxDistanceKm: (_useDistanceFilter && widget.hasLocation)
                            ? _maxDistance
                            : null,
                      ),
                    );
                  },
                  child: Text(
                    'apply'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
