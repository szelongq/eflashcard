import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ConsumeString = Function(String? value);    // Consumer function takes in
// String
// and returns void

class WritingSystemsDropdown extends StatefulWidget {
  final void Function(String a, String b) notifyParent;

  // UI Constants
  final int elevation = 16;
  final double height = 2;

  // Attr
  final Map<String, String> writingSystems;
  final Map<String, String> reversedWS;


  WritingSystemsDropdown({Key? key, required this.writingSystems, required
  this.notifyParent}) :
        reversedWS = writingSystems.map((k, v) => MapEntry(v, k)),
  // https://stackoverflow.com/a/52059899
        super(key: key);

  @override
  State<WritingSystemsDropdown> createState() => _WritingSystemsDropdownState();

}

class _WritingSystemsDropdownState extends State<WritingSystemsDropdown> {
  // State
  late String frontValue;
  late String backValue;


  @override
  void initState() {
    super.initState();
    frontValue = widget.writingSystems.keys
      .toList(growable: false).first;
    backValue = widget.writingSystems.keys.toList(growable: false)[1];
    widget.notifyParent(frontValue, backValue);
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildDropdown(context, frontValue, backValue, (newValue) => {
          setState(() {
            frontValue = widget.reversedWS[newValue]!; // use ! only if sure
            // it will nvr be null
            print(frontValue + " <---> " + backValue);
            // suppress warnings strikes again
            widget.notifyParent(frontValue, backValue);
          })
        }),
        _buildDropdown(context, backValue, frontValue, (newValue) => {
          setState(() {
            backValue = widget.reversedWS[newValue]!;
            print(frontValue + " <---> " +  backValue);
            widget.notifyParent(frontValue, backValue);
          })
        }),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, String selectedValue,
      String unselectableValue, ConsumeString onChange) {
    return DropdownButton<String>(
        value: widget.writingSystems[selectedValue],
        icon: const Icon(Icons.arrow_downward),
        elevation: widget.elevation,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(height: widget.height, color: Colors.deepPurpleAccent),
        onChanged: onChange,
        items:
        widget.writingSystems.values.toList()
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
              value: value,
              enabled: (value == widget.writingSystems[unselectableValue]) ? false :
              true,
              child: Text(value),
              );
            }).toList(), // returns list of dropdown menu items
    );
  }

}
