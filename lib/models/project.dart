/// Represents a project entry from the 42 Intra API.
class Project {
  final String name;
  final String status;   // "finished", "in_progress", "searching_a_group", etc.
  final bool validated;  // true = passed, false = failed/not graded
  final int? finalMark;

  const Project({
    required this.name,
    required this.status,
    required this.validated,
    this.finalMark,
  });

  /// Parses a [Project] from a raw `projects_users` entry in the 42 API response.
  factory Project.fromJson(Map<String, dynamic> json) {
    final projectMap = json['project'] as Map<String, dynamic>? ?? {};
    return Project(
      name: projectMap['name'] as String? ?? 'Unknown Project',
      status: json['status'] as String? ?? 'unknown',
      validated: json['validated?'] as bool? ?? false,
      finalMark: json['final_mark'] as int?,
    );
  }

  bool get isFinished => status == 'finished';
}
