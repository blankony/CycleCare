import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/design/cycle_care_design.dart';
import '../../../app/providers.dart';
import '../../../app/widgets.dart';

enum _LockState { checking, locked, authenticated, unsupported, error }

class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  _LockState _state = _LockState.checking;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final security = ref.read(securityServiceProvider);
    final available = await security.isAvailable();
    if (!mounted) return;
    if (!available) {
      setState(() => _state = _LockState.unsupported);
      return;
    }
    setState(() => _state = _LockState.locked);
    await _authenticate();
  }

  Future<void> _authenticate() async {
    setState(() => _state = _LockState.checking);
    try {
      final ok = await ref.read(securityServiceProvider).authenticate();
      if (!mounted) return;
      setState(() {
        _state = ok ? _LockState.authenticated : _LockState.locked;
        _errorDetail = ok
            ? null
            : 'Autentikasi dibatalkan. Coba lagi atau keluar dari akun.';
      });
      if (ok && mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted && context.mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          }
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _LockState.error;
        _errorDetail =
            'Autentikasi tidak tersedia pada perangkat ini. ($error)';
      });
    }
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted && context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.cycleCareColors;
    final now = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    return Scaffold(
      body: CycleCareBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final body = Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CycleCareSpacing.lg,
                  vertical: CycleCareSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(CycleCareRadius.pill),
                          ),
                          child: const Text(
                            'CC',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: CycleCareSpacing.sm),
                        Text(
                          'CycleCare',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Semantics(
                          label: _headlineLabel(_state),
                          child: _LockVisual(state: _state),
                        ),
                        const SizedBox(height: CycleCareSpacing.lg),
                        Text(
                          _headline(_state, now),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: CycleCareSpacing.sm),
                        Text(
                          _support(_state, _errorDetail),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: CycleCareSpacing.lg),
                        if (_state == _LockState.locked ||
                            _state == _LockState.checking) ...[
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _state == _LockState.checking
                                  ? null
                                  : _authenticate,
                              icon: const Icon(Icons.fingerprint),
                              label: Text(
                                _state == _LockState.checking
                                    ? 'Meminta autentikasi...'
                                    : 'Buka kunci',
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  context.canPop() ? context.pop() : null,
                              icon: const Icon(Icons.lock_open),
                              label: const Text('Kembali ke CycleCare'),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: _signOut,
                          child: const Text('Keluar dari akun'),
                        ),
                        const SizedBox(height: CycleCareSpacing.sm),
                        Text(
                          'Data periodmu tetap tersimpan di perangkat. Menghapus kunci tidak menghapus catatan.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              if (constraints.maxWidth >= 900) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: body,
                  ),
                );
              }
              return body;
            },
          ),
        ),
      ),
    );
  }

  String _headline(_LockState state, String now) => switch (state) {
        _LockState.checking => 'Meminta autentikasi',
        _LockState.locked => 'Aplikasi terkunci',
        _LockState.authenticated => 'Berhasil dibuka',
        _LockState.unsupported => 'Kunci biometrik tidak tersedia',
        _LockState.error => 'Tidak dapat membuka kunci',
      };

  String _support(_LockState state, String? detail) {
    return switch (state) {
      _LockState.checking =>
        'Sentuh sensor biometrik saat diminta oleh sistem.',
      _LockState.locked =>
        detail ?? 'Gunakan biometrik perangkat untuk membuka CycleCare.',
      _LockState.authenticated =>
        'Kamu dapat menutup layar dan mulai mencatat period.',
      _LockState.unsupported => detail ??
          'Perangkat ini tidak mendukung autentikasi biometrik. Buka kunci melalui akun Supabase.',
      _LockState.error => detail ??
          'Coba lagi beberapa saat. Jika tetap gagal, keluar dari akun.',
    };
  }

  String _headlineLabel(_LockState state) =>
      'Status kunci: ${_headline(state, "")}';
}

class _LockVisual extends StatelessWidget {
  const _LockVisual({required this.state});

  final _LockState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color) = switch (state) {
      _LockState.checking => (Icons.hourglass_top, theme.colorScheme.primary),
      _LockState.locked => (Icons.lock_outline, theme.colorScheme.primary),
      _LockState.authenticated => (Icons.lock_open, theme.colorScheme.primary),
      _LockState.unsupported => (
          Icons.shield_outlined,
          theme.colorScheme.error,
        ),
      _LockState.error => (Icons.sync_problem, theme.colorScheme.error),
    };
    final bg = color.withValues(alpha: 0.12);
    return Container(
      width: 96,
      height: 96,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.24),
          width: 1.2,
        ),
      ),
      child: Icon(icon, size: 40, color: color),
    );
  }
}
