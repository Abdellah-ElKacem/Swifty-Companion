import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/student.dart';
import '../widgets/skill_bar.dart';
import '../widgets/project_tile.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final student = Student.fromJson(userProfile);
    return _ProfileBody(student: student);
  }
}

// ──────────────────────────────────────────────
// Internal stateful widget so we can manage tabs
// ──────────────────────────────────────────────
class _ProfileBody extends StatefulWidget {
  final Student student;
  const _ProfileBody({required this.student});

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const Color _teal = Color(0xFF00BABC);
  static const Color _bg = Color(0xFF1E1E24);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      backgroundColor: _bg,
      // ── AppBar with back arrow (navigates back to search) ──
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          tooltip: 'Back to Search',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          student.login,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _teal,
          indicatorWeight: 3,
          labelColor: _teal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Skills'),
            Tab(text: 'Projects'),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(student: student),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _SkillsTab(student: student),
                _ProjectsTab(student: student),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Header: avatar, name, details grid, level progress bar
// ─────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final Student student;
  static const Color _teal = Color(0xFF00BABC);
  static const Color _card = Color(0xFF252530);

  const _ProfileHeader({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E24),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + core info ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _teal, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: _card,
                  child: student.imageUrl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: student.imageUrl!,
                            width: 84,
                            height: 84,
                            fit: BoxFit.cover,
                            placeholder: (ctx, _) => const _AvatarPlaceholder(),
                            errorWidget: (ctx, _, err) =>
                                const _AvatarPlaceholder(),
                          ),
                        )
                      : const _AvatarPlaceholder(),
                ),
              ),
              const SizedBox(width: 16),
              // Name + login + location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${student.login}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    if (student.location != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 13, color: Color(0xFF00BABC)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              student.location!,
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Row(
                        children: [
                          const Icon(Icons.location_off,
                              size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Unavailable',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Level progress bar ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    student.levelDisplay,
                    style: const TextStyle(
                        color: _teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  Text(
                    '${(student.levelProgress * 100).toStringAsFixed(0)}% to next',
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: student.levelProgress,
                  minHeight: 8,
                  backgroundColor: _card,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(_teal),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Details grid: email, mobile, wallet, evaluations ──
          _DetailsGrid(student: student),
        ],
      ),
    );
  }
}

// ─────────────────────────────────
// 2×2 detail chips
// ─────────────────────────────────
class _DetailsGrid extends StatelessWidget {
  final Student student;
  const _DetailsGrid({required this.student});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: student.email),
      _DetailItem(
          icon: Icons.phone_outlined,
          label: 'Mobile',
          value: (student.phone == null ||
                  student.phone!.isEmpty ||
                  student.phone == 'hidden')
              ? 'N/A'
              : student.phone!),
      _DetailItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Wallet',
          value: '\u20B3 ${student.wallet}'),
      _DetailItem(
          icon: Icons.rate_review_outlined,
          label: 'Evaluations',
          value: '${student.correctionPoints} pts'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      mainAxisExtent: 70,
      childAspectRatio: 2.6,
      children: items.map((i) => _DetailCard(item: i)).toList(),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _DetailCard extends StatelessWidget {
  final _DetailItem item;
  const _DetailCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF252530),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00BABC).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: const Color(0xFF00BABC), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
                Text(
                  item.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────
// Skills tab
// ─────────────────────────────────
class _SkillsTab extends StatelessWidget {
  final Student student;
  const _SkillsTab({required this.student});

  @override
  Widget build(BuildContext context) {
    if (student.skills.isEmpty) {
      return const _EmptyState(
        icon: Icons.psychology_outlined,
        message: 'No skills found for this student.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: student.skills.length,
      itemBuilder: (_, i) => SkillBar(skill: student.skills[i]),
    );
  }
}

// ─────────────────────────────────
// Projects tab
// ─────────────────────────────────
class _ProjectsTab extends StatelessWidget {
  final Student student;
  const _ProjectsTab({required this.student});

  @override
  Widget build(BuildContext context) {
    if (student.projects.isEmpty) {
      return const _EmptyState(
        icon: Icons.folder_open_outlined,
        message: 'No completed projects found.',
      );
    }
    final passed = student.projects.where((p) => p.validated).toList();
    final failed = student.projects.where((p) => !p.validated).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (passed.isNotEmpty) ...[
          _SectionLabel(
              label: 'Passed (${passed.length})',
              color: const Color(0xFF00C896)),
          ...passed.map((p) => ProjectTile(project: p)),
          const SizedBox(height: 12),
        ],
        if (failed.isNotEmpty) ...[
          _SectionLabel(
              label: 'Failed (${failed.length})',
              color: Colors.redAccent),
          ...failed.map((p) => ProjectTile(project: p)),
        ],
      ],
    );
  }
}

// ─────────────────────────────────
// Helpers
// ─────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[700], size: 56),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.person, color: Color(0xFF00BABC), size: 40);
  }
}