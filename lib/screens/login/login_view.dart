import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/scrollable_column.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.put(LoginViewModel());
    return Scaffold(
      body: Form(
        key: viewModel.formKey,
        child: ScrollableColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/logo_white.png'),
              height: 120,
              width: 120,
            ),
            const Text(
              'ISMMART POS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 0.2,
            ),
            const Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: CustomTextField1(
                  controller: viewModel.emailController,
                  hint: 'Email',
                  suffixIcon: Icons.email_outlined,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return AppConstants.validateEmail(value);
                  },
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CustomTextField1(
                  controller: viewModel.passController,
                  hint: 'Password',
                  suffixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return AppConstants.validateDefaultField(value);
                  }),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: CustomTextBtn(
                height: 52,
                radius: 30,
                title: "Login",
                backgroundColor: Colors.white.withOpacity(0.2),
                onPressed: () {
                  if (viewModel.formKey.currentState!.validate()) {
                    viewModel.login();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
