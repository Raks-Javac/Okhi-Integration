import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okhi_flutter/okhi_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeOKhi();
  }

//this method initializes the okHi service with the brandid and clientId from the sand box dashboard
  void initializeOKhi() async {
    final config = OkHiAppConfiguration(
      branchId: "<my_branch_id>",
      clientKey: "<my_client_key>",
      //you can set this enum to OkHiEnv  to production if you arent on testing/staging mode e.g OhHiEnv.prod
      env: OkHiEnv.sandbox,
      notification: OkHiAndroidNotification(
        title: "Verification in progress",
        text: "Verifying your address",
        channelId: "okhi",
        channelName: "OkHi",
        channelDescription: "Verification alerts",
      ),
    );
    try {
      var result = await OkHi.initialize(config);
      print(result); // returns true if initialization is successfull
    } on MissingPluginException {
      if (kDebugMode) {
        print("Missing platform exception");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //send your own long and lat to okhi without verifying from theirs
  verifyWithOwnLocationCredentials() async {
    final location = OkHiLocation(
      id: "<valid_okhi_location_id>",
      lat: -1.313,
      lon: 34.389,
    );
    await OkHi.startVerification(userTobeVerifiedCredentials, location, null);
  }

//this contain the user initial credentials
  OkHiUser userTobeVerifiedCredentials = OkHiUser(
    phone: "+254712345678",
    firstName: "Testing Name",
    lastName: "T",
    //this can be a unique identifier specific to your brand/company
    id: "74784874784",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Create an address"),
      ),
      body: OkHiLocationManager(
        user: userTobeVerifiedCredentials,
        onError: (error) {
          if (kDebugMode) {
            print("error okhi service");
            print(error.code);
            print(error.message);
          }
        },
        onCloseRequest: () {
          if (kDebugMode) {
            print("Cant reach okhi service");
          }
        },
        onSucess: (response) async {
          if (kDebugMode) {
            print("Sucess");

            print(response.user); // user information
            print(response.location); // address information
          }
        },
        //add your own app custom configuration
        //you can set this to only home if you only need home addresss by setting [wtihHomeAddressType] = true and [withWorkAddressType] = false
        configuration: OkHiLocationManagerConfiguration(
          withHomeAddressType: true,
          withWorkAddressType: false,
          color: "#333",
          logoUrl: "https://mydomain.com/logo.png",
        ),
      ),
    ));
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
