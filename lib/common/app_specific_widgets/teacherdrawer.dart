import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../resources/colors.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.black,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    bottomLeft: Radius.circular(24.0),
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/teacher_avatar.png'),
                    radius: 25,
                  ),
                ),
                SizedBox(
                    width:
                    10), // Adjust the spacing between the profile picture and the name
                Text(
                  "Jenny Luke",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            accountEmail: null,
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded, color: Colors.white),
            title: const Text(
              'My Profile',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const Icon(Icons.notifications_none_outlined, color: Colors.white),
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading: const HeroIcon(HeroIcons.clipboardDocumentList, color: Colors.white),
            title: const Text(
              'Guide',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const Icon(Icons.schedule_outlined, color: Colors.white),
            title: const Text(
              'My Classes',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.currencyDollar, color: Colors.white),
            title: const Text(
              'Earnings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.power, color: Colors.white),
            title: const Text(
              'Switch to Student',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.cog8Tooth, color: Colors.white),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.questionMarkCircle, color: Colors.white),
            title: const Text(
              'Help & Support',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.arrowLeftOnRectangle, color: Colors.white),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          const SizedBox(height: 20,),
          ListTile(
            leading:
            const HeroIcon(HeroIcons.atSymbol, color: Colors.white),
            title: const Text(
              'mossyoga@help.com',
              style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 14),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
        ],
      ),
    );
  }
}
