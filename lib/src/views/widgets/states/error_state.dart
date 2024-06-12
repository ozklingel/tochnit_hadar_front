import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState(
    this.error, {
    super.key,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error.toString()));
  }
}
