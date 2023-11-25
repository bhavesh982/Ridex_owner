import 'package:flutter/material.dart';
class RideFinish extends StatefulWidget {
  const RideFinish({super.key});

  @override
  State<RideFinish> createState() => _RideFinishState();
}

class _RideFinishState extends State<RideFinish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.blue,
        ),
      ),
    );
  }
}
