import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:rp_app/views/buy_rp.dart';
import 'package:rp_app/views/home_tab_screen.dart';
import 'package:rp_app/views/sell_rp.dart';
import 'package:rp_app/views/sell_rp_tab_screen.dart';
import '../controllers/home_controller.dart';
import 'buy_rp_tab_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeTabScreen(),
    // BuyRPScreen(),
    BuyRPTabScreen(),
    // SellRPScreen(),
    SellRPTabScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Get.put(HomeController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildRPIcon(isActive: false, isBuy: true),
            activeIcon: _buildRPIcon(isActive: true, isBuy: true),
            label: "Buy RP",
          ),
          BottomNavigationBarItem(
            icon: _buildRPIcon(isActive: false, isBuy: false),
            activeIcon: _buildRPIcon(isActive: true, isBuy: false),
            label: "Sell RP",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildRPIcon({required bool isActive, required bool isBuy}) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? Color(0xFF6A11CB)
              : (isBuy ? Colors.green.shade400 : Colors.red.shade400),
          width: 2,
        ),
      ),
      child: Text(
        "RP",
        style: TextStyle(
          color: isActive
              ? Color(0xFF6A11CB)
              : (isBuy ? Colors.green.shade400 : Colors.red.shade400),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
