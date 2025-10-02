import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';
import 'auth_model.dart';
import 'login.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false, // ลบทุกหน้าที่ค้างออก ให้เริ่มที่ Login เลย
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final auth = AuthModel(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    context.read<AuthCubit>().register(auth);
                  },
                  child: const Text("Register"),
                ),
                if (state is Unauthenticated && state.message != null)
                  Text(state.message!,
                      style: const TextStyle(color: Colors.red)),
              ],
            );
          },
        ),
      ),
    );
  }
}
