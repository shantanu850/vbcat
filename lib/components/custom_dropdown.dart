import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final title;
  final selected;
  const CustomDropdown({Key key, this.title, this.selected}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color:Colors.amber,width:2)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.title}"),
          Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width:120,child: Text("${widget.selected}",overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,)),
              Icon(Icons.arrow_drop_down)
            ],
          ))
        ],
      ),
    );
  }
}
