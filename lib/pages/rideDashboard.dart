import 'package:flutter/material.dart';
import 'package:ridex_owner/global/global_var.dart';
class RideDashboard extends StatefulWidget {
  const RideDashboard({super.key});

  @override
  State<RideDashboard> createState() => _RideDashboardState();
}
class _RideDashboardState extends State<RideDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainTheme,
      appBar: AppBar(),
      body: const Center(
        child: Text("Welcome On Board"),
      ),
    );
  }
}
