import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class DisplayMap extends StatefulWidget {
  const DisplayMap({super.key});

  @override
  State<DisplayMap> createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {
  late ArcGISMapViewController _controller;

  final String clientId =
      ' e3e87787dda94aea8d66732312a440e7'; // Replace with your ArcGIS App's Client ID
  final String redirectUri =
      'https://myapp//auth'; // Must match the URI set in ArcGIS Developer Portal
  final String authorizationUrl =
      'https://www.arcgis.com/sharing/rest/oauth2/authorize';
  final String tokenUrl = 'https://www.arcgis.com/sharing/rest/oauth2/token';

  Future<void> authenticate() async {
    try {
      final authUri = Uri.parse(
          '$authorizationUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri');
      final result = await FlutterWebAuth.authenticate(
        url: authUri.toString(),
        callbackUrlScheme: redirectUri.split(':').first,
      );

      // Extract the authorization code from the result
      final code = Uri.parse(result).queryParameters['code'];
      if (code != null) {
        // Exchange the authorization code for an access token
        final tokenResponse = await ArcGISAuthenticationManager.instance
            .exchangeAuthorizationCode(
          clientId: clientId,
          clientSecret:
              null, // Leave null unless your app requires client secret
          redirectUri: redirectUri,
          authorizationCode: code,
          tokenUrl: tokenUrl,
        );

        // Set the access token in the ArcGIS Authentication Manager
        ArcGISAuthenticationManager.instance.setDefaultAccessToken(
          tokenResponse.accessToken,
        );
      }
    } catch (e) {
      debugPrint('Authentication failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Map')),
      body: ArcGISMapView(
        controllerProvider: () {
          _controller = ArcGISMapView.createController()
            ..arcGISMap = ArcGISMap.withBasemapStyle(
              BasemapStyle.arcGISImagery,
            );
          return _controller;
        },
      ),
    );
  }
}
