import 'package:flutter/material.dart';
import '../../tabPages/earning-tab.dart';
import '../../tabPages/home_tab.dart';
import '../../tabPages/rating_tab.dart';
import '../profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List pages = [
    const HomeTabPage(),
    const RatingsTabPage(),
    const EarningsTabPage(),
    const ProfilePage()
  ];

  void onTapNav(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor:  Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        currentIndex: _selectedIndex,
        onTap: onTapNav,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),
            label: "History",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}