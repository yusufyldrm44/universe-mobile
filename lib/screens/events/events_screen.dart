import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/placeholder_view.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Etkinlikler'),
      ),
      body: const SafeArea(
        child: PlaceholderView(
          icon: Icons.event_outlined,
          title: 'Etkinlikler yapım aşamasında',
          subtitle: 'Kampüs etkinlikleri ve topluluk duyuruları yakında.',
          weekNote: 'Hafta 7\'de eklenecek',
        ),
      ),
    );
  }
}
