import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        onPressed: onPress,
        minWidth: double.infinity,
        height: 50,
        child: Text(title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)),
        color: Colors.black,
      ),
    );
  }
}
