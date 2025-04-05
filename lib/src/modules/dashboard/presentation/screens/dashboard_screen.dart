import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/core/navigation/routes.dart';
import 'package:jima/src/core/supabase_infra/auth_service.dart';
import 'package:jima/src/tools/components/primary_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppButton.primary(
          onPressed: () async {
            try {
              loading = true;
              setState(() {});
              await container<SupabaseAuthService>().signOut();
              if (!context.mounted) return;
              context.goNamed(AppRoute.authAction.name);
            } catch (e) {
              setState(() {
                loading = false;
              });
            }
          },
          loading: loading,
          text: 'Log out',
        ),
      ),
    );
  }
}
