import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/screens/auth/login_screen/login_screen.dart';
import 'package:chat/screens/landing/bloc/landing_bloc.dart';
import 'package:chat/screens/mobile_layout/mobile_layout_screen.dart';
import 'package:chat/screens/user_information/user_information_screen.dart';
import 'package:chat/screens/widgets/custom_button.dart';
import 'package:chat/screens/widgets/error_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return BlocProvider<LandingBloc>(
      create: (context) {
        final bloc = LandingBloc(authRepository: authRepository);
        bloc.add(LandingStarted());
        return bloc;
      },
      child: BlocBuilder<LandingBloc, LandingState>(
        builder: (context, state) {
          if (state is LandingLoading) {
            return const Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          } else if (state is LandingError) {
            return ErrorScreen(
              message: state.error,
            );
          } else if (state is LandingSuccessWithRegisteredPhoneNumber) {
            return const UserInformationScreen();
          } else if (state is LandingSuccessWithRegisteredPhoneNumberAndName) {
            return MobileLayoutScreen(
              user: state.user,
            );
          } else if (state is LandingSuccessWithoutRegistered) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'Wellcome to Chat',
                        style: TextStyle(
                            fontSize: 33, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.height / 10,
                      ),
                      Image.asset(
                        'assets/images/bg.png',
                        width: 340,
                        height: 340,
                        color:
                            themeData.floatingActionButtonTheme.backgroundColor,
                      ),
                      SizedBox(
                        height: size.height / 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width * 0.85,
                        child: CustomButton(
                            text: 'AGREE AND CONTINUE',
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const LoginScreen();
                              }));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            throw Exception();
          }
        },
      ),
    );
  }
}
