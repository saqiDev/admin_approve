import 'package:admin_approve/view/Registration.dart';
import 'package:admin_approve/view/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
   return StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  // If the user is already signed-in, use it as initial data
  initialData: FirebaseAuth.instance.currentUser,
  builder: (context, snapshot) {
    // User is not signed in
    if (!snapshot.hasData) {
      return SignInScreen(
        headerBuilder: (context, constraints, _) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset('assets/logo.png')
      ),
    );
  },

  //  subtitle
  //
  subtitleBuilder: (context, action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        action == AuthAction.signIn
            ? 'Welcome ! Please sign in to continue.'
            : 'Please create an account to continue',
      ),
    );
  },
  footerBuilder: (context, _) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text(
        'By signing in, you agree to our terms and conditions.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  },
  //
        
        providerConfigs:const [
          EmailProviderConfiguration(),
         
        ]
      );
    }

    // Render your application if authenticated
    return const LandingScreen();
  },
);
  }
}