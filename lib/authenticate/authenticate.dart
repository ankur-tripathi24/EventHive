import 'package:eventhive/screens/register.dart';
import 'package:flutter/material.dart';

class authtnticate extends StatefulWidget {
  const authtnticate({super.key});

  @override
  State<authtnticate> createState() => _authtnticateState();
}

class _authtnticateState extends State<authtnticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyRegister(),
    );  
  }
}