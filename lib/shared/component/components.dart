import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultTextFormField({
  required TextEditingController controler,
  required TextInputType input,
  required String?Function(String?) validate,
  required String lable,
  required IconData icon,
  bool isPassword=false,
  Function(String)? onSubmitted,
  Function(String)? onChange,
  IconData? sufixIcon,
  VoidCallback? suffixWork,
})=>TextFormField(
  controller: controler,
  keyboardType: input,
  obscureText: isPassword,
  onFieldSubmitted: onSubmitted,
  onChanged: onChange,
  validator: validate,
  decoration: InputDecoration(
    labelText: lable,
    prefixIcon: Icon(
      icon,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        sufixIcon,
      ),
      onPressed: suffixWork,
    ),
    border: OutlineInputBorder(),
  ),
);

Widget defaultButton({
  required VoidCallback  function,
  double width=double.infinity,
  Color color=Colors.blue,
  bool isUpperCase =true,
  required String text,
})=>Container(
  width: width,
  color: color,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase? text.toUpperCase():text,
      style: TextStyle(color: Colors.white),
    ),
  ),
);

Widget deafultTextButtom ({
  required VoidCallback function,
  required String text,
})=>TextButton(
    onPressed: function,
    child: Text(
        '$text'
    ));

Widget myDividor()=>Container(height: 3.0,color: Colors.grey[300],);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);


void navigateAndDelete(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (Route<dynamic> route)=>false,//To delete all the store routes
);

void showToast({
  required String? messege,
  required ToastStates state,

})=>Fluttertoast.showToast(
    msg: "${messege}",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}