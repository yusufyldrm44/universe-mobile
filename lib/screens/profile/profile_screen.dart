import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final date = DateTime.parse(raw).toLocal();
      return DateFormat('d MMMM yyyy', 'tr_TR').format(date);
    } catch (_) {
      return raw;
    }
  }

  String _membershipYear(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      return DateTime.parse(raw).year.toString();
    } catch (_) {
      return '';
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(
          'Çıkış yap',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          'Hesabından çıkmak istediğine emin misin?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Çıkış yap'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthService>().logout();
      if (context.mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;
    final fullName = user?.fullName ?? 'Misafir';
    final department = user?.department ?? '';
    final university = user?.university ?? '';
    final email = user?.universityEmail ?? '';
    final membershipYear = _membershipYear(user?.createdAt);
    final memberSince = membershipYear.isEmpty
        ? 'PROFIL'
        : 'PROFIL · ÜYE $membershipYear\'DAN BERİ';
    final tagline = [department, university]
        .where((e) => e.isNotEmpty)
        .join(' · ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memberSince,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '$fullName.',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              if (tagline.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  tagline,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Divider(),
              _InfoRow(label: 'E-POSTA', value: email),
              _InfoRow(label: 'ÜNİVERSİTE', value: university),
              _InfoRow(label: 'BÖLÜM', value: department),
              _InfoRow(
                label: 'KAYIT TARİHİ',
                value: _formatDate(user?.createdAt),
                isLast: true,
              ),
              const SizedBox(height: 28),
              Text(
                'Profil düzenleme yakında.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Çıkış Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
