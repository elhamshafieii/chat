import 'package:chat/common/utils/utils.dart';
import 'package:chat/data/repository/auth_repository.dart';
import 'package:chat/screens/auth/otp_screen/bloc/otp_bloc.dart';
import 'package:chat/screens/mobile_layout/mobile_layout_screen.dart';
import 'package:chat/screens/user_information/user_information_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Verify your number'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code.'),
            SizedBox(
                width: size.width * 0.5,
                child: BlocProvider<OtpBloc>(
                  create: (context) {
                    final bloc = OtpBloc(authRepository: authRepository);
                    bloc.stream.forEach((state) {
                      if (state is OtpSuccess) {
                        if (state.userModel.name.isEmpty) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const UserInformationScreen();
                          }));
                        } else {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MobileLayoutScreen(user: state.userModel);
                          }));
                        }
                      } else if (state is OtpError) {
                        showSnackBar(context: context, content: state.error);
                      }
                    });
                    return bloc;
                  },
                  child: BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.length == 6) {
                            BlocProvider.of<OtpBloc>(context).add(OtpCodeFilled(
                                userOtp: value.trim(),
                                verificationCode: widget.verificationId));
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '- - - - - -',
                            hintStyle: TextStyle(fontSize: 30)),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
