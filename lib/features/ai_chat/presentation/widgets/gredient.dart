import 'package:flutter/material.dart';

LinearGradient getLinearGradient({bool vertically = true}) => LinearGradient(
      stops: const [
        0.0,
        0.5,
        1.0,
      ],
      colors: const [
        Color(0XFFD1F258),
        Color(0XFFE3E3DE),
        Color(0XFF9166FF),
      ],
      begin:
          vertically ? const Alignment(0.5, -1.0) : const Alignment(-1.0, 0.0),
      end: vertically ? const Alignment(0.5, 1.0) : const Alignment(1.0, 0.0),
    );
