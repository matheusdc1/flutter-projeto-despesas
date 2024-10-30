import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomAppBarFloatingButton extends StatelessWidget {
  const AppBottomAppBarFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go("/add-expense");
      },
      child: CircleAvatar(
        backgroundColor: Colors.green[200],
        radius: 24,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.green[900],
            ),
          ),
        ),
      ),
    );
  }
}
