import 'package:flutter/material.dart';

class NewsAgencyHeader extends StatelessWidget {
  const NewsAgencyHeader({
    super.key,
    required this.imageSize,
    this.textColor,
  });

  final double imageSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        height: 61,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: imageSize,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CNN Philippines',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: textColor, fontWeight: FontWeight.w900,fontSize: 20),
                ),
                Text(
                  '10 minutes ago',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
