import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF619451);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Профиль',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Tabs
            Row(
              children: [
                _tabItem('Профиль', true),
                _tabItem('Дети', false),
                _tabItem('Платежи', false),
                _tabItem('Настройки', false),
              ],
            ),
            const Divider(),

            const SizedBox(height: 16),

            /// Profile photo and name/email
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Алина Аскарова',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('alina.askarova@gmail.com',
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),

            const SizedBox(height: 16),

            /// Plan warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF6E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD59F),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('FREE',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Вы используете бесплатный план. Перейдите в платежи, чтобы обновить план.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Personal Data
            const Text('Персональные данные',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _profileField('Имя', 'Алина Аскарова',
                trailingText: 'Редактировать', trailingColor: greenColor),
            _profileField('Email', 'alina.askarova@gmail.com',
                trailingText: 'Редактировать', trailingColor: greenColor),
            _profileField('Пароль', '••••••••',
                trailingText: 'Сбросить пароль', trailingColor: greenColor),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () {},
              child: const Text('Удалить аккаунт'),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF619451) : Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 2,
              width: 24,
              color: const Color(0xFF619451),
            )
        ],
      ),
    );
  }

  Widget _profileField(String label, String value,
      {String? trailingText, Color? trailingColor}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 14)),
                  ]),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  color: trailingColor ?? Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              )
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }
}
