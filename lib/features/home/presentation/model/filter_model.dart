import 'dart:convert';

class FilterModel {
  final String name;
  final int temperature;
  final double opacity;
  final double focusSharpness;
  final bool isCustom;
  final bool isDark;

  FilterModel({
    required this.name,
    required this.temperature,
    required this.opacity,
    required this.focusSharpness,
    this.isCustom = false,
    this.isDark = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'temperature': temperature,
    'opacity': opacity,
    'focusSharpness': focusSharpness,
    'isCustom': isCustom,
    'isDark': isDark,
  };

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    name: json['name'],
    temperature: json['temperature'],
    opacity: (json['opacity'] as num).toDouble(),
    focusSharpness: (json['focusSharpness'] ?? 0.5).toDouble(),
    isCustom: json['isCustom'] ?? false,
    isDark: json['isDark'] ?? false,
  );

  String toJsonString() => jsonEncode(toJson());

  factory FilterModel.fromJsonString(String jsonString) =>
      FilterModel.fromJson(jsonDecode(jsonString));
}
