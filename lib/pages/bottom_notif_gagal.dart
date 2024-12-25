import 'package:flutter/material.dart';

import '../component/color.dart';

void bottomSheetGagal({
  required BuildContext context,
  required String title,
  required String subtitle,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            )),
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.remove_circle_outline_sharp,
                    color: AppColors.threeorange,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 22)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.threeorange, fontSize: 12)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 14),
                          child: Text('OK',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        )),
                  )
                ]),
          ),
        ),
      );
    },
  );
}
