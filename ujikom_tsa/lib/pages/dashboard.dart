// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:ujikom_tsa/build/panel.dart';
import 'package:ujikom_tsa/pages/login_page.dart';
import 'package:ujikom_tsa/pages/profile.dart';
import 'package:ujikom_tsa/pages/users.dart';
import 'package:ujikom_tsa/utils/bottomnav.dart';
import 'package:ujikom_tsa/utils/constant.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController searchLocation = TextEditingController();

  String userNama = '';
  Position position = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );
  bool loading = false;
  String address = 'Tidak diketahui';

  @override
  void initState() {
    super.initState();
    getUser();
    getLocation();
  }

  void getUser() async {
    getAuth().then((value) {
      if (value == null) {
        navigatorPushReplace(context, page: Login());
      } else {
        setState(() {
          userNama = value.value['nama'];
        });
      }
    });
  }

  void goToLocation() async {
    const searchLocation = 'Menantea GM253 Jember';

    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      loading = true;
    });

    var intent = AndroidIntent(
      action: 'action_view',
      data: 'google.navigation:q=${searchLocation}',
    );
    await intent.launch();
  }

  getLocation() async {
    setState(() {
      loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      notif(context, text: 'service lokasi tidak tersedia', color: Colors.red);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        notif(context, text: 'Akses lokasi tidak diizinkan');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      notif(context, text: 'Akses lokasi tidak diizinkan secara permanen');
    }

    var location = await Geolocator.getCurrentPosition();
    var placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    var place = placemarks[0];

    setState(() {
      position = location;
      loading = false;
      address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: '',
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hai',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7),
                Text(
                  userNama,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Welcome to Menantea Dashboard',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Panel(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Outlet Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Jl. Gajah Mada, Patimura, Jember Kidul, Kec. Kaliwates, Kabupaten Jember, Jawa Timur',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: kPrimaryColor,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: goToLocation,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Text(
                            'Find Best Route',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Panel(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Koordinat:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(loading
                    ? 'Loading...'
                    : "${position.latitude},${position.longitude}"),
                SizedBox(height: 20),
                Text(
                  'Address:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  loading ? 'Loading...' : address,
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: kPrimaryColor,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: getLocation,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Text(
                            'Get Koordinat',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({
    Key? key,
    this.body,
    this.title,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget? body;
  final String? title;
  final Widget? floatingActionButton;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  String userUsername = '';
  String userNama = '';
  String userNumber = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    cekUser();
  }

  void cekUser() {
    getAuth().then((value) {
      if (value.value != null) {
        setState(() {
          userUsername = value.value['username'];
          userNama = value.value['nama'];
          userNumber = value.value['nomorTelepon'];
          userRole = value.value['role'];
        });
      }
    });
  }

  logout() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    await session.clear();

    navigatorPushReplace(context, page: Login());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
        elevation: 0,
      ),
      bottomNavigationBar: BottomNav(),
      body: Stack(
        children: [
          Container(
            height: size.height * .25,
            width: size.width,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
          ),
          widget.body as Widget,
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: kShadowColor,
                      size: 30,
                    )
                  ],
                ),
              ),
              accountEmail: Text(userNumber),
              accountName: Text(userNama),
            ),
            userRole == '1'
                ? ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text('Data User'),
                    onTap: () {
                      navigatorPush(context, page: User());
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                navigatorPush(context, page: Profil());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: Text("Are you sure to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            navigatorPop(context);
                          },
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: logout,
                          child: Text('LOGOUT'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
