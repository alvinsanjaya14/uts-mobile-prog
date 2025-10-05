import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes.dart'; // Pastikan path ini benar
import '../widgets/custom_button.dart'; // Pastikan path ini benar

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lingkaran hijau dengan ikon centang
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF2E7D32), // Warna hijau yang sesuai
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),

              // Teks "Pembayaran Anda Berhasil"
              const Text(
                'Pembayaran Anda Berhasil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Tombol untuk kembali ke halaman utama
              CustomButton.primary(
                text: 'Kembali Ke Halaman Utama',
                onPressed: () {
                  // Menggunakan GoRouter untuk kembali ke home
                  // 'go' akan mereset stack navigasi
                  context.go(AppRoutes.home);
                },
                width: double.infinity,
                size: CustomButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}