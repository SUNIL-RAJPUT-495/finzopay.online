import 'package:flutter/material.dart';
import 'package:rp_app/views/buy_rp_tab_screen.dart';
import 'package:rp_app/views/home_tab_screen.dart';
import 'package:rp_app/views/profile_screen.dart';
import 'package:rp_app/views/sell_rp_tab_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    HomeTabScreen(),
    BuyRPTabScreen(),
    SellRPTabScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _screens.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _screens[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
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
