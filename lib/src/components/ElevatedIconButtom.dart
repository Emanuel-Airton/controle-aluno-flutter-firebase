import 'package:flutter/material.dart';

class ElevatedIconButtom extends StatefulWidget {
  Color? color;
  IconData? iconData;
  Function()? onpressed;
  String? texto;
  ElevatedIconButtom(
      {super.key,
      required this.color,
      required this.iconData,
      required this.onpressed,
      required this.texto});

  @override
  State<ElevatedIconButtom> createState() => _IconButtomState();
}

class _IconButtomState extends State<ElevatedIconButtom> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: widget.onpressed,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(40),
            backgroundColor: widget.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        label: Text(
          widget.texto!,
          style: const TextStyle(color: Colors.white),
        ),
        icon: Icon(
          widget.iconData,
          color: Colors.white,
        ));
  }
}
