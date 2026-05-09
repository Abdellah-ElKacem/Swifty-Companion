import 'package:flutter/material.dart';
import '../models/project.dart';

/// A styled list tile showing a project name, mark, and pass/fail badge.
class ProjectTile extends StatelessWidget {
  final Project project;

  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final bool passed = project.validated;
    final Color badgeColor = passed ? const Color(0xFF00C896) : Colors.redAccent;
    final Color badgeBg = passed
        ? const Color(0xFF00C896).withValues(alpha: 0.12)
        : Colors.redAccent.withValues(alpha: 0.12);
    final IconData icon =
        passed ? Icons.check_circle_outline : Icons.cancel_outlined;
    final String markText =
        project.finalMark != null ? '${project.finalMark}' : '--';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF252530),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Icon(icon, color: badgeColor, size: 20),
          const SizedBox(width: 10),
          // Project name
          Expanded(
            child: Text(
              project.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Mark badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              markText,
              style: TextStyle(
                color: badgeColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
