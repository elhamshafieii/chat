import 'dart:async';

import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/screens/auth/login_screen/bloc/auth_bloc.dart';
import 'package:chat/screens/auth/otp_screen/otp_screen.dart';
import 'package:chat/screens/user_information/user_information_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription<AuthState>? stateSubscription;
  final phoneController = TextEditingController();
  Country? country;
  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country countryCode) {
        setState(() {
          country = countryCode;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      authRepository.signInWithPhone('+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  void dispose() {
    stateSubscription?.cancel();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeData.appBarTheme.backgroundColor,
          elevation: 0,
          title: const Text('Enter your phone Number'),
        ),
        body: BlocProvider<AuthBloc>(
          create: (context) {
            final bloc = AuthBloc(authRepository: authRepository);
            stateSubscription = bloc.stream.listen((state) {
              if (state is AuthSuccess) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return UserInformationScreen();
                }));
              } else if (state is AuthGetVerificationId) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return OTPScreen(
                    verificationId: state.verificationId,
                  );
                }));
              } else if (state is AuthError) {
                showSnackBar(
                    context: context, content: state.error.message.toString());
              }
            });
            // bloc.add(AuthStarted());
            return bloc;
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                          'Chat app will need to verify your phone number:'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: pickCountry,
                        child: Text(
                          'Pick country:',
                          style: themeData.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: themeData
                                  .floatingActionButtonTheme.backgroundColor),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          country != null
                              ? Text('+${country!.phoneCode}')
                              : const Text(''),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: size.width * 0.7,
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              decoration: const InputDecoration(
                                  hintText: 'phone number'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                      width: 90,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                              onPressed: () async {
                                String phoneNumber =
                                    phoneController.text.trim();
                                if (country != null && phoneNumber.isNotEmpty) {
                                  context.read<AuthBloc>().add(
                                      AuthNextButtomClicked(
                                          phoneNumber:
                                              '+${country!.phoneCode}$phoneNumber'));
                                } else {
                                  showSnackBar(
                                      context: context,
                                      content: 'Fill out all the fields');
                                }
                              },
                              child: state is AuthLoading
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white)
                                  : const Text('Next'));
                        },
                      )),
                ]),
          ),
        ));
  }
}
