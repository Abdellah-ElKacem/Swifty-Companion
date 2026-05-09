/// Represents a skill from the 42 Intra API.
class Skill {
  final String name;
  final double level;

  const Skill({
    required this.name,
    required this.level,
  });

  /// Parses a [Skill] from a raw JSON map returned by the 42 API.
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String? ?? 'Unknown',
      level: (json['level'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts the raw float level (e.g. 7.42) to a percentage (0.0–1.0)
  /// capped at the max level of 21.
  double get percentage => (level / 21.0).clamp(0.0, 1.0);
}
