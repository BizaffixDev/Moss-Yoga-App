import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  ///Uncomment for WEB
  static const _clientIDWeb =
      '635619436578-euh2fi3diha14opj2g2dk6ar4ei1nr3u.apps.googleusercontent.com';
  static const _clientIDApple =
      '635619436578-4sjfq1c12tsicjokovo29vik7t5lrmbd.apps.googleusercontent.com';

  static final _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? _clientIDWeb
        : Platform.isIOS
            ? _clientIDApple
            : '',
  );

  // static final _googleSignIn = GoogleSignIn(clientId: _clientIDWeb);
  // static final _googleSignIn = GoogleSignIn(clientId: _clientIDApple);

  Future<GoogleSignInAccount?> login() {
    print('this is the clientId being sent ${_googleSignIn.clientId}');

    _googleSignIn.signOut();
    return _googleSignIn.signIn();
  }

  // Future<GoogleSignInAccount?> signUp() {
  //   print('this is the clientId being sent ${_googleSignIn.clientId}');
  //   return _googleSignIn.signInOption();
  // }

  Future logout() => _googleSignIn.signOut();
}
