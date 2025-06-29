import 'package:flutter/material.dart';

class Profilestats extends StatelessWidget {
  final int postcount;
  final int followersCount;
  final int followingCount;
  final void Function()? ontap;

  const Profilestats({
    super.key,
    required this.postcount,
    required this.followersCount,
    required this.followingCount,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                followersCount.toString(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Followers"),
            ],
          ),
          Column(
            children: [
              Text(
                followingCount.toString(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Following"),
            ],
          ),
          Column(
            children: [
              Text(
                postcount.toString(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("    Posts"),
            ],
          ),
        ],
      ),
    );
  }
}
