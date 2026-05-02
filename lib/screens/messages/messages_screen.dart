import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/placeholder_view.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mesajlar'),
      ),
      body: const SafeArea(
        child: PlaceholderView(
          icon: Icons.chat_bubble_outline,
          title: 'Mesajlar yapım aşamasında',
          subtitle: 'Anlık mesajlaşma yakında devreye alınacak.',
          weekNote: 'Hafta 11\'de eklenecek',
        ),
      ),
    );
  }
}
