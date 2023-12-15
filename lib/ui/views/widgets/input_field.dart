
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import '../../../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  TextStyle get titleStyle => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: b,
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8, right: 14),
            width: SizeConfig.screenHeight,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    style: subTitleStyle,
                    cursorColor: Colors.grey[700],
                    readOnly: widget != null ? true : false,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: b,
                          width: 0,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: b,
                          width: 0,
                        ))),
                  ),
                ),
                widget ?? Container(), // if widget is null put empty container
              ],
            ),
          ),
        ],
      ),
    );
    
  }
  
}
