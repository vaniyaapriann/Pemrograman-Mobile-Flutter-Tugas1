import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int _selectedIndex = 0;

  // Function to show logout confirmation dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                // Add your logout logic here
                // For example, navigate to login page
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Home',
              style: GoogleFonts.urbanist(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Profile Icon
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 28, 95, 30),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add User'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/add');
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('List User'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/listuser');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // Add logout icon
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                showLogoutDialog(context); // Show logout confirmation dialog
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                // Search Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SearchThing(),
                ),
                SizedBox(height: 20),
                // More Widgets Here
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/addtabungan');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/transaksi');
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Tabungan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transaksi',
          ),
        ],
      ),
    );
  }
}
