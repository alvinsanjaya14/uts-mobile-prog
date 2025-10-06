import 'package:flutter/material.dart';
import 'loginOrSignup_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String password = '';

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  String passwordStrength = "Weak";
  double strengthValue = 0.0;

  void checkPassword(String value) {
    setState(() {
      password = value;
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasLowercase = value.contains(RegExp(r'[a-z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasSpecialChar = value.contains(RegExp(r'[!@#\$&*~]'));

      int strength = [
        hasMinLength,
        hasUppercase,
        hasLowercase,
        hasNumber,
        hasSpecialChar
      ].where((c) => c).length;

      strengthValue = strength / 5;

      if (strength <= 1) {
        passwordStrength = "Weak";
      } else if (strength == 2) {
        passwordStrength = "Moderate";
      } else if (strength == 3 || strength == 4) {
        passwordStrength = "Strong";
      } else if (strength == 5) {
        passwordStrength = "Very Strong";
      }
    });
  }

  Widget buildCheckItem(String text, bool conditionMet) {
    return Row(
      children: [
        Icon(
          conditionMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: conditionMet ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/signup.png',
                height: 250,
                ),
              ),
              const Text("Let's get you started!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const TextField(
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              const TextField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: checkPassword,
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: strengthValue,
                backgroundColor: Colors.grey[300],
                color: strengthValue <= 0.3
                    ? Colors.red
                    : (strengthValue <= 0.6 ? Colors.orange : Colors.green),
              ),
              const SizedBox(height: 4),
              Text("Password strength: $passwordStrength"),
              const SizedBox(height: 10),
              const Text("Password must contain:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              buildCheckItem("At least 8 characters", hasMinLength),
              buildCheckItem("At least 1 uppercase letter (A-Z)", hasUppercase),
              buildCheckItem("At least 1 lowercase letter (a-z)", hasLowercase),
              buildCheckItem("At least 1 number (0-9)", hasNumber),
              buildCheckItem("At least 1 special character (@,#,\$)", hasSpecialChar),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (hasMinLength &&
                          hasUppercase &&
                          hasLowercase &&
                          hasNumber &&
                          hasSpecialChar)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Account created successfully!")),
                          );
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccountScreen()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Create account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
