import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //THEMES
    var theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(microseconds: 400),
      width: _folded ? width * 0.14 : width * 0.8,
      height: height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32), //medua query se karna
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 16),
            child: _folded
                ? null
                : TextField(
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: theme.primaryColor),
                        border: InputBorder.none),
                  ),
          )),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            //Fixing the splash
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                //Fixing the border radius of the splash
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: theme.primaryColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
