import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Spacer(),
              Icon(Icons.favorite,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 20),
              Text('Selamat datang di CycleCare',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text(
                  'Catat period secara pribadi, offline, dan tanpa klaim medis.'),
              const SizedBox(height: 24),
              const Text(
                  'Data ditampilkan dari cache perangkat dan disinkronkan secara aman ke akun Supabase.'),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () => context.go('/dashboard'),
                      child: const Text('Mulai'))),
            ]),
          ),
        ),
      );
}
