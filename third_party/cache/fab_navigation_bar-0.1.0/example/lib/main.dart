import 'package:fab_navigation_bar/fab_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(
      MaterialApp(
        home: FabNavigationBar(
          itens: [
            FabNavigationBarIcon(
              name: 'Messages',
              icon: FontAwesomeIcons.facebookMessenger,
              callback: () {
                print('Messages');
              },
            ),
            FabNavigationBarIcon(
              name: 'Notifications',
              icon: FontAwesomeIcons.solidBell,
              callback: () {
                print('Notifications');
              },
            ),
            FabNavigationBarIcon(
              name: 'Profile',
              icon: FontAwesomeIcons.solidUser,
              callback: () {
                print('Profile');
              },
            ),
            FabNavigationBarIcon(
              name: 'Settings',
              icon: Icons.settings,
              callback: () {
                print('Settings');
              },
            ),
          ],
          fabCallback: () {
            print('Cliquei no FAB!');
          },
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.4,
            centerTitle: true,
            brightness: Brightness.light,
            title: Text(
              'Home',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          fabIconColor: Colors.white,
          fabBackgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorPalette.appThemedGradientColorsPremium,
          ),
        ),
      ),
    );
