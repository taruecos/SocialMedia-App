import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/auth/register/register.dart';
import 'package:social_media_app/components/password_text_field.dart';
import 'package:social_media_app/components/text_form_builder.dart';
import 'package:social_media_app/utils/validation.dart';
import 'package:social_media_app/view_models/auth/login_view_model.dart';
import 'package:social_media_app/widgets/indicators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/logo3.png',
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'Log in',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            // Center(
            //   child: Text(
            //     'Log in',
            //     style: TextStyle(
            //       fontSize: 12.0,
            //       fontWeight: FontWeight.w300,
            //       color: Color.fromARGB(97, 0, 0, 0),
            //     ),
            //   ),
            // ),
            SizedBox(height: 25.0),
            buildForm(context, viewModel),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => Register(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildForm(BuildContext context, LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          SizedBox(height: 15.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.login(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () => viewModel.forgotPassword(context),
                child: Container(
                  width: 130,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 45.0,
            width: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Color.fromARGB(255, 226, 226, 226)),
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 255, 253, 253)
                ],
              ),
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              onPressed: () => viewModel.login(context),
              child: Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
