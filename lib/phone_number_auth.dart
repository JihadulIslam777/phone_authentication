import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState {
  showMobileFormState,
  showOtpFormState,
}

class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({Key? key}) : super(key: key);

  @override
  State<PhoneNumberAuth> createState() => _PhoneNumberAuthState();
}

class _PhoneNumberAuthState extends State<PhoneNumberAuth> {
  MobileVerificationState currentState =
      MobileVerificationState.showMobileFormState;

  String? verificationId;

  bool? showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {}
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
    }
  }

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // var smsCode;

  getMobileFormWidget(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                    // void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) {}
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState = MobileVerificationState.showOtpFormState;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              },
              child: const Text('verify'),
              style: TextButton.styleFrom(
                primary: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(hintText: 'OTP'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                  verificationId: verificationId!,
                  smsCode: otpController.text,
                );
                signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              child: const Text('verify'),
              style: TextButton.styleFrom(
                primary: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          child: showLoading!
              ? const Center(child: CircularProgressIndicator())
              : currentState == MobileVerificationState.showMobileFormState
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
