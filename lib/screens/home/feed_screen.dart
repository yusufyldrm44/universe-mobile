import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;
    final firstName = (user?.fullName ?? '').split(' ').first;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ANA SAYFA',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            firstName.isEmpty
                ? 'Hoş geldin.'
                : 'Merhaba, $firstName.',
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kampüsündeki ilanlar, etkinlikler ve sohbetler tek bir akışta.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 20),
          _SectionCard(
            label: 'BU HAFTA',
            title: 'Akış henüz boş',
            description:
                'İlanlar, etkinlikler ve topluluk paylaşımları aktif edildiğinde burada görünecek.',
          ),
          const SizedBox(height: 14),
          _SectionCard(
            label: 'YOL HARİTASI',
            title: 'Geliştirme devam ediyor',
            description:
                'Hafta 7\'de etkinlikler, Hafta 8\'de ilanlar ve Hafta 11\'de mesajlaşma ile karşılaşacaksın.',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;

  const _SectionCard({
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
