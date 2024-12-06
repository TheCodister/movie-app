// import 'dart:convert';

// import 'package:arcgis_maps/arcgis_maps.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:http/http.dart' as http;

// class DisplayMap extends StatefulWidget {
//   const DisplayMap({super.key});

//   @override
//   State<DisplayMap> createState() => _DisplayMapState();
// }

// class _DisplayMapState extends State<DisplayMap> {
//   late ArcGISMapViewController _controller;

//   final String clientId = 'HZOVkLOp9tGYDAqu'; // ArcGIS Client ID
//   final String redirectUri = 'myapp://auth'; // Redirect URI
//   final String authorizationUrl =
//       'https://www.arcgis.com/sharing/rest/oauth2/authorize';
//   final String tokenUrl = 'https://www.arcgis.com/sharing/rest/oauth2/token';
//   String? _accessToken;

//   Future<void> authenticate() async {
//     try {
//       // Build the authorization URL
//       final authUri = Uri.parse(
//         '$authorizationUrl?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&expiration=20160',
//       );

//       // Open the authorization URL for user login
//       final result = await FlutterWebAuth.authenticate(
//         url: authUri.toString(),
//         callbackUrlScheme: redirectUri.split('://').first,
//       );

//       // Extract the authorization code from the result
//       final code = Uri.parse(result).queryParameters['code'];
//       if (code != null) {
//         // Exchange the authorization code for an access token
//         final tokenResponse = await http.post(
//           Uri.parse(tokenUrl),
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//           body: {
//             'client_id': clientId,
//             'grant_type': 'authorization_code',
//             'code': code,
//             'redirect_uri': redirectUri,
//           },
//         );

//         if (tokenResponse.statusCode == 200) {
//           final tokenData = jsonDecode(tokenResponse.body);
//           setState(() {
//             _accessToken = tokenData['access_token'];
//           });

//           // Set the access token in the ArcGIS Authentication Manager

//           debugPrint('Access Token: $_accessToken');
//         } else {
//           debugPrint(
//               'Token exchange failed: ${tokenResponse.statusCode} ${tokenResponse.body}');
//         }
//       }
//     } catch (e) {
//       debugPrint('Authentication failed: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     authenticate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display Map')),
//       body: _accessToken == null
//           ? const Center(child: CircularProgressIndicator())
//           : ArcGISMapView(
//               controllerProvider: () {
//                 _controller = ArcGISMapView.createController()
//                   ..arcGISMap = ArcGISMap.withBasemapStyle(
//                     BasemapStyle.arcGISImagery,
//                   );
//                 return _controller;
//               },
//             ),
//     );
//   }
// }
//
// Copyright 2024 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';

class AuthenticateWithOAuth extends StatefulWidget {
  const AuthenticateWithOAuth({super.key});

  @override
  State<AuthenticateWithOAuth> createState() => _AuthenticateWithOAuthState();
}

class _AuthenticateWithOAuthState extends State<AuthenticateWithOAuth>
    implements ArcGISAuthenticationChallengeHandler {
  // Create a controller for the map view.
  final _mapViewController = ArcGISMapView.createController();

  // Create an OAuthUserConfiguration.
  // This document describes the steps to configure OAuth for your app:
  // https://developers.arcgis.com/documentation/security-and-authentication/user-authentication/flows/authorization-code-with-pkce/
  final _oauthUserConfiguration = OAuthUserConfiguration(
    portalUri: Uri.parse('https://www.arcgis.com'),
    clientId: 'T0A3SudETrIQndd2',
    redirectUri: Uri.parse('my-ags-flutter-app://auth'),
  );

  @override
  void initState() {
    super.initState();

    // Set this class to the arcGISAuthenticationChallengeHandler property on the authentication manager.
    // This class implements the ArcGISAuthenticationChallengeHandler interface,
    // which allows it to handle authentication challenges via calls to its
    // handleArcGISAuthenticationChallenge() method.
    ArcGISEnvironment
        .authenticationManager.arcGISAuthenticationChallengeHandler = this;
  }

  @override
  void dispose() async {
    // We do not want to handle authentication challenges outside of this sample,
    // so we remove this as the challenge handler.
    ArcGISEnvironment
        .authenticationManager.arcGISAuthenticationChallengeHandler = null;

    super.dispose();

    // Revoke OAuth tokens and remove all credentials to log out.
    await Future.wait(
      ArcGISEnvironment.authenticationManager.arcGISCredentialStore
          .getCredentials()
          .whereType<OAuthUserCredential>()
          .map((credential) => credential.revokeToken()),
    );
    ArcGISEnvironment.authenticationManager.arcGISCredentialStore.removeAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add a map view to the widget tree and set a controller.
      body: ArcGISMapView(
        controllerProvider: () => _mapViewController,
        onMapViewReady: onMapViewReady,
      ),
    );
  }

  void onMapViewReady() {
    // Create a map from a web map that has a secure layer (traffic).
    final portalItem = PortalItem.withPortalAndItemId(
      portal: Portal.arcGISOnline(connection: PortalConnection.authenticated),
      itemId: 'e5039444ef3c48b8a8fdc9227f9be7c1',
    );
    final map = ArcGISMap.withItem(portalItem);
    // Set the map to map view controller.
    _mapViewController.arcGISMap = map;
  }

  @override
  void handleArcGISAuthenticationChallenge(
    ArcGISAuthenticationChallenge challenge,
  ) async {
    try {
      // Initiate the sign in process to the OAuth server using the defined user configuration.
      final credential = await OAuthUserCredential.create(
        configuration: _oauthUserConfiguration,
      );

      // Sign in was successful, so continue with the provided credential.
      challenge.continueWithCredential(credential);
    } on ArcGISException catch (error) {
      // Sign in was canceled, or there was some other error.
      final e = (error.wrappedException as ArcGISException?) ?? error;
      if (e.errorType == ArcGISExceptionType.commonUserCanceled) {
        challenge.cancel();
      } else {
        challenge.continueAndFail();
      }
    }
  }
}
