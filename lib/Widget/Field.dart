import 'package:flutter/material.dart';

//This is the field used in the App as it used multiple times so it is better paractice to make a general purpose field so that
//you dont have to write the duplicate code
class Field extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool obsecureText;
  final TextEditingController controller;
  const Field({
    Key key,
    this.hintText,
    this.icon,
    this.obsecureText = false,
    this.controller,
  }) : super(key: key);
  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: size.height * 0.075,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: Colors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.left,
              controller: widget.controller,
              obscureText: widget.obsecureText,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 15,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
