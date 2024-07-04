import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/screens/students_screens/student_profile_setting/components/arrow_container.dart';


class TeacherMyAccount extends StatefulWidget {
  const TeacherMyAccount({super.key});

  @override
  State<TeacherMyAccount> createState() => _TeacherMyAccountState();
}

class _TeacherMyAccountState extends State<TeacherMyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 844.h,
        width: 390.w,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(37),
            topRight: Radius.circular(37),
          ),
          image: DecorationImage(
            image: AssetImage(Drawables.authPlainBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.symmetric(
                horizontal: 20.w, vertical: 20.h),
            height: 780.h,
            width: 390.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(37),
                topRight: Radius.circular(37),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap:(){
                        context.pop();
                      },
                      child: const HeroIcon(
                        HeroIcons.arrowLeft,
                        color: Colors.black,
                      ),
                    ),
                    const  SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'My Account',
                      style: TextStyle(
                        color: Color(0xFF202526),
                        fontSize: 21,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        // height: 26.40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),


                ArrowContainer(title: "Change Password", icon: HeroIcons.key, onTap: (){
                  context.push(PagePath.teacherChangePassword);
                }),


                const SizedBox(
                  height: 20,
                ),

                ArrowContainer(title: "Delete Account", icon: HeroIcons.trash, onTap: (){
                  context.push(PagePath.teacherDeleteAccount);

                }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
