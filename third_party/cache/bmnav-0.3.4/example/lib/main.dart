import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

void main() {
  runApp(MaterialApp(
    title: 'Bottom Nav Demo',
    home: MainWidget(),
    theme: ThemeData(primaryColor: Colors.green),
  ));
}

class MainWidget extends StatefulWidget {
  @override
  MainWidgetState createState() => MainWidgetState();
} 

class MainWidgetState extends State<MainWidget> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomeScreen(),
    WorkoutsScreen(),
    AccountScreen(),
    SettingsScreen()
  ];
  Widget currentScreen = HomeScreen();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Nav Demo', style: TextStyle(color: Colors.black)),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: PageStorage(child: currentScreen, bucket: bucket),
      bottomNavigationBar: bmnav.BottomNav(
        index: currentTab,
        labelStyle: bmnav.LabelStyle(visible: false),
        onTap: (i) {
          setState(() {
            currentTab = i;
            currentScreen = screens[i];
          });
        },
        items: [
          bmnav.BottomNavItem(Icons.home, label: 'Home'),
          bmnav.BottomNavItem(Icons.fitness_center, label: 'Workouts'),
          bmnav.BottomNavItem(Icons.person, label: 'Account'),
          bmnav.BottomNavItem(Icons.view_headline, label: 'Settings')
        ],
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
 HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(50.0),
        child: Text('Home', style: TextStyle(color: Colors.white, fontSize: 24.0)),
      ),
    );
  }
}

// Workouts Screen
class WorkoutsScreen extends StatefulWidget {
  WorkoutsScreen();
  @override
 WorkoutsScreenState createState() => WorkoutsScreenState();
}

class WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Container(
        color: Colors.red,
        padding: EdgeInsets.all(50.0),
        child: Text('Workouts', style: TextStyle(color: Colors.white, fontSize: 24.0)),
      ),
    );
  }
}

// Account Screen
class AccountScreen extends StatefulWidget {
  AccountScreen();
  @override
 AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Container(
        color: Colors.yellow[600],
        padding: EdgeInsets.all(50.0),
        child: Text('Account', style: TextStyle(color: Colors.white, fontSize: 24.0)),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatefulWidget {
  SettingsScreen();
  @override
 SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Container(
        color: Colors.green,
        padding: EdgeInsets.all(50.0),
        child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24.0)),
      ),
    );
  }
}