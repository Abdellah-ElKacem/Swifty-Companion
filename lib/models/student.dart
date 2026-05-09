import 'skill.dart';
import 'project.dart';

/// Strongly-typed model representing a 42 Intra student profile.
class Student {
  final String login;
  final String displayName;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? location;
  final int wallet;
  final int correctionPoints;
  final double level;
  final List<Skill> skills;
  final List<Project> projects;

  const Student({
    required this.login,
    required this.displayName,
    required this.email,
    this.phone,
    this.imageUrl,
    this.location,
    required this.wallet,
    required this.correctionPoints,
    required this.level,
    required this.skills,
    required this.projects,
  });

  /// Constructs a [Student] from the raw JSON map returned by `GET /v2/users/:login`.
  factory Student.fromJson(Map<String, dynamic> json) {
    // --- cursus_users: pick the "main" 42cursus entry for level & skills ---
    final List<dynamic> cursusUsers = json['cursus_users'] as List<dynamic>? ?? [];
    Map<String, dynamic>? mainCursus;
    for (final entry in cursusUsers) {
      final cursusId = (entry as Map<String, dynamic>)['cursus_id'];
      // cursus_id 21 = 42cursus; fallback to whatever is last
      if (cursusId == 21) {
        mainCursus = entry;
        break;
      }
      mainCursus = entry;
    }

    final double level =
        (mainCursus?['level'] as num?)?.toDouble() ?? 0.0;

    final List<dynamic> rawSkills =
        (mainCursus?['skills'] as List<dynamic>?) ?? [];
    final List<Skill> skills = rawSkills
        .map((s) => Skill.fromJson(s as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.level.compareTo(a.level)); // highest first

    // --- projects_users ---
    final List<dynamic> rawProjects =
        json['projects_users'] as List<dynamic>? ?? [];
    final List<Project> projects = rawProjects
        .map((p) => Project.fromJson(p as Map<String, dynamic>))
        .where((p) => p.isFinished) // show only finished (passed + failed)
        .toList()
      ..sort((a, b) => (b.finalMark ?? 0).compareTo(a.finalMark ?? 0));

    // --- image ---
    final imageMap = json['image'] as Map<String, dynamic>?;
    final String? imageUrl =
        imageMap?['versions']?['medium'] as String? ??
        imageMap?['link'] as String?;

    return Student(
      login: json['login'] as String? ?? 'unknown',
      displayName: json['usual_full_name'] as String? ??
          json['displayname'] as String? ??
          json['login'] as String? ??
          'Unknown',
      email: json['email'] as String? ?? 'N/A',
      phone: json['phone'] as String?,
      imageUrl: imageUrl,
      location: json['location'] as String?,
      wallet: json['wallet'] as int? ?? 0,
      correctionPoints: json['correction_point'] as int? ?? 0,
      level: level,
      skills: skills,
      projects: projects,
    );
  }

  /// Formats level as "Level X (Y%)" e.g. "Level 7 (42%)"
  String get levelDisplay {
    final int lvl = level.floor();
    final int pct = ((level - lvl) * 100).round();
    return 'Level $lvl ($pct%)';
  }

  /// 0.0–1.0 progress within the current level
  double get levelProgress => level - level.floor();
}
