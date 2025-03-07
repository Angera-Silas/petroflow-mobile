import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) return false;

    return await auth.authenticate(
      localizedReason: 'Scan your fingerprint or face to access PetroFlow',
      options: const AuthenticationOptions(
        biometricOnly: true,
      ),
    );
  }
}
