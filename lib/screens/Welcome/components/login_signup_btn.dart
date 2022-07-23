import 'package:flutter/material.dart';
import '/screens/auth/login.dart';
import '/screens/auth/signup.dart';

import '../../../constants.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: kPrimaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Login(
                      role: 'user',
                    );
                  },
                ),
              );
            },
            child: Text(
              "Login as user".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Login(role: 'admin');
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(primary: kBgLightColor, elevation: 0),
          child: Text(
            "Login as Admin".toUpperCase(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
