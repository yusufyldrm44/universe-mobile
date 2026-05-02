import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/placeholder_view.dart';

class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('İlanlar'),
      ),
      body: const SafeArea(
        child: PlaceholderView(
          icon: Icons.storefront_outlined,
          title: 'İlanlar yapım aşamasında',
          subtitle: 'Kitap, ders notu ve eşya ilanları yakında.',
          weekNote: 'Hafta 8\'de eklenecek',
        ),
      ),
    );
  }
}
