import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';
import 'package:moss_yoga/common/resources/drawables.dart';
import 'package:moss_yoga/common/resources/page_path.dart';
import 'package:moss_yoga/presentation/providers/login_provider.dart';


import '../../../../../data/models/user_role.dart';
import 'role_buttons.dart';
import 'select_your_role_text.dart';

class Body extends ConsumerStatefulWidget {
  const Body({
    super.key,
  });

  @override
  ConsumerState<Body> createState() => _BodyState();
}


class _BodyState extends ConsumerState<Body> {
  bool isTapped1 = false;
  bool isTapped2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Drawables.selectRoleBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Expanded(
                child: SvgPicture.asset(Drawables.appName,),
              ),
              Container(
                height:430.h,
                width: 390.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),

                ),
                child: Column(
                  children: [
                     SizedBox(
                      height: 34.h,
                    ),
                    //TODO: select your role tet
                    const SelectYourRoleText(),

                    SizedBox(
                      height: 35.h,
                    ),
                    //Choose Role Container

                    RoleButtons(
                      id: 1,
                      icon:isTapped1 ? Drawables.teacherChooseRoleIconWhite: Drawables.teacherChooseRoleIconBlack,
                      text: "Teacher",
                      border: Border.all(
                        color: isTapped1 ?AppColors.white : AppColors.primaryColor ,
                        width: 1,
                      ),
                      onTap: (){

                        setState(() {
                          ref.read(userRoleProvider.notifier).state =
                              UserRoleModel(
                                  userRole: UserRole.Teacher);
                          isTapped1 = !isTapped1;
                          isTapped2 = false;
                        });
                        Future.delayed(const Duration(milliseconds: 1000),()=>context.push(PagePath.signUpTeacher));
                        print( ref.read(userRoleProvider.notifier).state.userRole.name);
                      },
                      bgColor: isTapped1 ?  AppColors.primaryColor: AppColors.white,
                      txtColor: isTapped1 ? AppColors.white : AppColors.primaryColor,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    RoleButtons(
                      id: 1,
                      icon:isTapped2 ? Drawables.studentChooseRoleIconWhite : Drawables.studentChooseRoleIconBlack ,
                      text: "Student",
                      border: Border.all(
                        color:isTapped1 ?AppColors.white : AppColors.primaryColor ,
                        width: 1,
                      ),
                      onTap: (){
                        ref.read(userRoleProvider.notifier).state =
                            UserRoleModel(
                                userRole: UserRole.Student);
                        print( ref.read(userRoleProvider.notifier).state.userRole.name);
                        setState(() {
                          setState(() {
                            isTapped2 = !isTapped2;
                            isTapped1 = false;
                          });
                        });

                        Future.delayed(const Duration(milliseconds: 1000),()=>context.push(PagePath.signUp));
                      },
                      bgColor: isTapped2 ?  AppColors.primaryColor: AppColors.white,
                      txtColor: isTapped2 ? AppColors.white : AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),






        );
  }
}
