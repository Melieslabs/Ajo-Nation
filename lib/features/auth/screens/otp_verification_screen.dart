import 'dart:async';

import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  int _secondsLeft = 30;
  late Timer _timer;
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify code')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'We sent a one-time password to your phone.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'OTP code'),
            ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(label: 'Verify', onPressed: _verify),
            const SizedBox(height: AppTheme.spacing12),
            TextButton(
              onPressed: _secondsLeft == 0 ? () {} : null,
              child: Text(
                _secondsLeft == 0 ? 'Resend code' : 'Resend in $_secondsLeft s',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verify() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.kyc);
  }
}
