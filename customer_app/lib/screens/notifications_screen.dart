import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Notifications'), actions: [
            if (app.unread > 0) TextButton(onPressed: app.markAllRead, child: const Text('Mark all read')),
          ]),
          body: app.notifications.isEmpty
              ? const MEmpty(icon: Icons.notifications_none, text: 'No notifications')
              : ListView.separated(
                  itemCount: app.notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final n = app.notifications[i];
                    return ListTile(
                      tileColor: n.read ? null : const Color(0xFFF0FAF4),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE8F6EE),
                        child: Icon(n.icon, color: MC.green),
                      ),
                      title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(n.body),
                      trailing: Text(timeAgo(n.time), style: const TextStyle(fontSize: 11, color: MC.sub)),
                      onTap: () => app.markRead(n),
                    );
                  },
                ),
        ),
      );
}
