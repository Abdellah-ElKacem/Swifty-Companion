import 'package:flutter/material.dart';
import '../models/skill.dart';

/// A single animated skill row with label, level chip, and progress bar.
class SkillBar extends StatelessWidget {
  final Skill skill;

  const SkillBar({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill name + level badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BABC).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00BABC).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  'Lvl ${skill.level.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF00BABC),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                // Background track
                Container(
                  height: 7,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled portion
                Container(
                  height: 7,
                  width: constraints.maxWidth * skill.percentage,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BABC), Color(0xFF0087A8)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 2),
          // Percentage label
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(skill.percentage * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
