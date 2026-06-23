


import 'package:flutter/material.dart';
import 'package:flutter_application_1/user_model.dart';
import 'package:flutter_application_1/user_service.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'user_detail_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _service = UserService();
  late Future<List<UserModel>> _futureData = _service.getAllUsers();
  final _scroller = ScrollController();
  bool _showUpIcon = false;
  bool _gridStyle = true;

  // ── Palette ──────────────────────────────────────────────
  static const _primary   = Color(0xFF4F46E5); // indigo-600
  static const _surface   = Color(0xFFF8F8FF); // ghost white
  static const _card      = Color(0xFFFFFFFF);
  static const _textMain  = Color(0xFF1E1B4B); // indigo-950
  static const _textSub   = Color(0xFF6B7280); // gray-500
  static const _accent    = Color(0xFFE0E7FF); // indigo-100

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      final show = _scroller.position.pixels > 500;
      if (show != _showUpIcon) setState(() => _showUpIcon = show);
    });
  }

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  // ── Avatar color by index ─────────────────────────────────
  static const _avatarColors = [
    Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFFF43F5E), Color(0xFFEF4444),
    Color(0xFF14B8A6), Color(0xFFF59E0B), Color(0xFF10B981),
    Color(0xFF3B82F6), Color(0xFFF97316),
  ];

  Color _avatarColor(int id) => _avatarColors[id % _avatarColors.length];

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      floatingActionButton: _showUpIcon ? _buildFab() : null,
      body: _buildBody(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _card,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.people_alt_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            "Users",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: _textMain,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        // Grid / List toggle
        Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              _gridStyle
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
              color: _primary,
              size: 20,
            ),
            tooltip: _gridStyle ? "List view" : "Grid view",
            onPressed: () => setState(() => _gridStyle = !_gridStyle),
          ),
        ),
    
      ],
    );
  }

  // ── FAB ───────────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton.small(
      onPressed: () => _scroller.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 3,
      child: const Icon(Icons.keyboard_arrow_up_rounded),
    );
  }

  // ── Body ──────────────────────────────────────────────────
  Widget _buildBody() {
    return FutureBuilder<List<UserModel>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.hasError) return _buildError(snapshot.error.toString());

        if (snapshot.connectionState != ConnectionState.done) {
          return _buildSkeleton();
        }

        return RefreshIndicator(
          color: _primary,
          onRefresh: () async =>
              setState(() => _futureData = _service.getAllUsers()),
          child: _buildGrid(snapshot.data),
        );
      },
    );
  }

  // ── Error state ───────────────────────────────────────────
  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Color(0xFFEF4444)),
            ),
            const SizedBox(height: 20),
            const Text("Something went wrong",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: _textMain)),
            const SizedBox(height: 8),
            Text(msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _textSub, fontSize: 13)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  setState(() => _futureData = _service.getAllUsers()),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Try again"),
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────
  Widget _buildSkeleton() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final w = MediaQuery.of(context).size.width;

    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Color(0xFFE5E7EB),
        highlightColor: Color(0xFFF9FAFB),
      ),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: w > 1000 ? (w - 1000) / 2 : 16,
          vertical: 16,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridStyle ? (isLandscape ? 4 : 2) : 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: _gridStyle ? 3 / 4.2 : 4.5,
        ),
        itemCount: 10,
        itemBuilder: (_, __) => _gridStyle
            ? _skeletonGridCard()
            : _skeletonListCard(),
      ),
    );
  }

  Widget _skeletonGridCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 36, backgroundColor: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Container(height: 14, width: 100,
              decoration: BoxDecoration(color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 8),
          Container(height: 12, width: 130,
              decoration: BoxDecoration(color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 6),
          Container(height: 12, width: 90,
              decoration: BoxDecoration(color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4))),
        ],
      ),
    );
  }

  Widget _skeletonListCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(radius: 26, backgroundColor: Color(0xFFE5E7EB)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 14, width: 120,
                    decoration: BoxDecoration(color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(height: 11, width: 160,
                    decoration: BoxDecoration(color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGrid(List<UserModel>? data) {
    if (data == null || data.isEmpty) {
      return const Center(
          child: Text("No users found",
              style: TextStyle(color: _textSub)));
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final w = MediaQuery.of(context).size.width;

    return GridView.builder(
      controller: _scroller,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: w > 1000 ? (w - 1000) / 2 : 16,
        vertical: 16,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridStyle ? (isLandscape ? 4 : 2) : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: _gridStyle ? 3 / 4.2 : 4.5,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final user = data[index];
        return _gridStyle
            ? _buildGridCard(user, index)
            : _buildListCard(user, index);
      },
    );
  }

  // ── Grid Card ─────────────────────────────────────────────
  Widget _buildGridCard(UserModel user, int index) {
    final color = _avatarColor(index);
    final initials =
        "${user.name.firstname[0]}${user.name.lastname[0]}".toUpperCase();

    return GestureDetector(
      onTap: () => _goDetail(user),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Full Name
              Text(
                "${user.name.firstname} ${user.name.lastname}",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _textMain,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined, size: 11, color: _textSub),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: _textSub),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  // ── List Card ─────────────────────────────────────────────
  Widget _buildListCard(UserModel user, int index) {
    final color = _avatarColor(index);
    final initials =
        "${user.name.firstname[0]}${user.name.lastname[0]}".toUpperCase();

    return GestureDetector(
      onTap: () => _goDetail(user),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: color.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${user.name.firstname} ${user.name.lastname}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _textMain,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: _textSub),
                    ),
                    const SizedBox(height: 4),
        
                  ],
                ),
              ),

        
            ],
          ),
        ),
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────
  void _goDetail(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => UserDetailScreen(user: user)),
    );
  }
}
