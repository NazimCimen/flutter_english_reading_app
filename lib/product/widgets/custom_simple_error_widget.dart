import 'package:flutter/material.dart';

class CustomSimpleErrorWidget extends StatelessWidget {
  final String error;
  const CustomSimpleErrorWidget({
    super.key,
    this.error = 'Something went wrong',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'An error occurred: $error',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
