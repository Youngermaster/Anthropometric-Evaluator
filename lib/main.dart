import 'package:flutter/material.dart';
import 'package:anthropometric_evaluator/pages/man.dart';
import 'package:anthropometric_evaluator/pages/woman.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _pageIndex = 0;

  final Man _menPage = Man();
  final Woman _womenPage = Woman();

  Widget _showPage = Man();

  _pageChooser(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _menPage;
        break;
      case 1:
        return _womenPage;
        break;
      case 2:
        return _menPage;
        break;
      default:
    }
  }

  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(
              MdiIcons.humanMale,
              size: 30,
              color: Colors.redAccent[700],
            ),
            Icon(
              MdiIcons.humanFemale,
              size: 30,
              color: Colors.redAccent[700],
            ),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.grey[900],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 350),
          onTap: (index) {
            setState(() {
              _showPage = _pageChooser(index);
            });
          },
        ),
        body: Container(
          color: Colors.orangeAccent,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
