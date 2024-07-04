import 'package:flutter/material.dart';

import 'termWidget.dart';



class TermsListView extends StatelessWidget {
  const TermsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  const Padding(
      padding: EdgeInsets.all(38),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //TERM 1
            TermWidget(
              number: "1. ",
              termText:
              "Acceptance of Terms: By using the Moss yoga app, you agree to be bound by these terms and conditions, as well as our Privacy Policy, which can be found on our website.",
            ),

            TermWidget(
              number: "2. ",
              termText:
              "User Eligibility: To use Moss, you must be at least 18 years old or have the permission of a parent or legal guardian. Moss is intended for personal use only and may not be used for commercial purposes.",
            ),

            TermWidget(
              number: "3. ",
              termText:
              "Account Registration: To use Moss, you must register for an account by providing your email address and creating a password. You are responsible for maintaining the confidentiality of your login information and for all activities that occur under your account.",
            ),

            TermWidget(
              number: "4. ",
              termText:
              "User Conduct: You agree to use Moss only for lawful purposes and in accordance with these terms and conditions. You may not use Moss to harm, exploit, or harass others, or to engage in any illegal activity.",
            ),

            TermWidget(
              number: "5. ",
              termText:
              "Intellectual Property: Moss and its content, including but not limited to text, graphics, logos, and images, are protected by copyright and other intellectual property laws. You may not copy, modify, distribute, or create derivative works based on Moss without our prior written consent.",
            ),

            TermWidget(
              number: "6. ",
              termText:
              "Disclaimer of Warranties: Moss is provided 'as is' and without any warranty or guarantee of any kind, either express or implied. We do not warrant that Moss will be error-free or uninterrupted, or that it will meet your specific needs or expectations.",
            ),
            TermWidget(
              number: "7. ",
              termText:
              "Limitation of Liability: We will not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with your use of Moss, even if we have been advised of the possibility of such damages.",
            ),
            TermWidget(
              number: "8. ",
              termText:
              "Modification of Terms: We reserve the right to modify these terms and conditions at any time, and your continued use of Moss after any changes have been made constitutes your acceptance of the new terms.",
            ),
            TermWidget(
              number: "9. ",
              termText:
              "Governing Law: These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction where the owner of Moss is based.",
            ),

            TermWidget(
              number: "10. ",
              termText:
              "Termination: We reserve the right to terminate your access to Moss at any time for any reason, including without limitation if you violate these terms and conditions.",
            ),


          ],
        ),
      ),
    );
  }
}