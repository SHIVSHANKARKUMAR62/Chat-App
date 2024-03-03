import 'package:flutter/material.dart';
class Button extends StatelessWidget {

  final VoidCallback onTap;
  final String title;
  final bool loading;

  const Button({Key? key,required this.onTap,required this.title,this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onLongPress: (){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.white38,
            content: Center(child: Text('Sign In',style: TextStyle(color: Colors.black),))));
      },
      onTap: onTap,
      child: Container(
        height: height*0.06,
        width: width*0.5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: loading ? const CircularProgressIndicator(strokeWidth: 6,color: Colors.white,) : Text(title,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25))),
      ),
    );
  }
}
