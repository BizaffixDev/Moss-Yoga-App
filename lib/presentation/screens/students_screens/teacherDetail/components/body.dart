import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moss_yoga/common/app_specific_widgets/custom_button.dart';
import 'package:moss_yoga/presentation/screens/students_screens/teacherDetail/components/section_heading.dart';

import '../../../../../common/resources/colors.dart';
import '../../../../../common/resources/text_styles.dart';
import '../../../../../data/models/teacher_specialty.dart';
import 'top_detail_section.dart';

class body extends ConsumerStatefulWidget {
  const body({
    super.key,
  });

  @override
  ConsumerState<body> createState() => _bodyState();
}

class _bodyState extends ConsumerState<body> {
  int? _value = 1;
  int? _selectedIndex;
  final List<Data> _choiceChipsList = [
    Data("Android", Colors.green),
    Data("Flutter", Colors.blue),
    Data("Ios", Colors.deepOrange),
    Data("Python", Colors.cyan),
    Data("React", Colors.pink)
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: AppColors.white,
        endDrawer: const Drawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: AppColors.black),

        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              const TopDetailSection(

              ),

              SizedBox(
                height: 10.h,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading(
                      title: 'ABOUT',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const AboutMe(),
                    const SizedBox(
                      height: 20,
                    ),
                    const SectionHeading(
                      title: 'SPECIALITIES',
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: teacherSpecialtyList.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,

                              childAspectRatio: 3),
                      itemBuilder: (context, index) {
                        return SpecialityChip(
                            title: teacherSpecialtyList[index].specialty);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SectionHeading(
                      title: 'BOOK SESSION',
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: DatePicker(
                        DateTime.now(),
                        height: 100.h,
                        width: 44.w,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: AppColors.primaryColor.withOpacity(0.7),
                        selectedTextColor: Colors.white,
                        dateTextStyle: manropeHeadingTextStyle.copyWith(
                            fontSize: 16.sp
                        ),

                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Morning"),
                    Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(
                        3,
                        (int index) {
                          return ChoiceChip(
                            backgroundColor: const Color.fromRGBO(104, 109, 67, 0.13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            label: Text('Item $index'),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Afternoon"),
                    Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(
                        3,
                        (int index) {
                          return ChoiceChip(
                            backgroundColor: const Color.fromRGBO(104, 109, 67, 0.13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            label: Text('Item $index'),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Evening"),
                    Wrap(
                      spacing: 5.0,
                      children: List<Widget>.generate(
                        3,
                        (int index) {
                          return ChoiceChip(
                            backgroundColor: const Color.fromRGBO(104, 109, 67, 0.13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            label: Text('Item $index'),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: "Book Now",
                      onTap: () {},
                      btnColor: Colors.black,
                      textColor: Colors.white,
                      m:10
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

        /*
      Stack(
       // alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [

          const TopDetailSection(),
          Positioned(
            top: CommonFunctions.deviceHeight(context) * 0.28,
            //200,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomRowContainers(),
                  BottomRowContainers(),
                  BottomRowContainers(),
                ],
              ),
            ),
          ),
          Positioned(
            top: CommonFunctions.deviceHeight(context) * 0.45,
            left: 0,
            //right: 0,
            //bottom: 10,
            child: Container(
             // height: 1000,
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: CommonFunctions.deviceWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const  SectionHeading(
                      title: 'About Me',
                    ),
                    const   SizedBox(
                      height: 10,
                    ),
                    AboutMe(),
                    const SizedBox(
                      height: 20,
                    ),
                    const  SectionHeading(
                      title: 'Specialty',
                    ),


                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: teacherSpecialtyList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          childAspectRatio: 2
                      ),
                      itemBuilder: (context,index){
                        return SpecialityChip(title: teacherSpecialtyList[index].specialty);
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const  SectionHeading(
                      title: 'Book Session',
                    ),



                    Wrap(
                      spacing: 6,
                      direction: Axis.horizontal,
                      children: choiceChips(),
                    ),


                  ],
                ),
              ),
            ),
          ),

        ],
      ),*/

        );
  }

  List<Widget> choiceChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _choiceChipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(_choiceChipsList[i].label),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: _choiceChipsList[i].color,
          selected: _selectedIndex == i,
          selectedColor: Colors.black,
          onSelected: (bool value) {
            setState(() {
              _selectedIndex = i;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}

class Data {
  String label;
  Color color;

  Data(this.label, this.color);
}

class AboutMe extends StatelessWidget {
  const AboutMe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sed ut perspiciatis unde omnis iste natus error sit voluptatem ...",
      style:
          kHintTextStyle.copyWith(fontSize: 14, color: AppColors.greyTextColor),
    );
  }
}

class SpecialityChip extends StatelessWidget {
  final String title;
  const SpecialityChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),side:
      const BorderSide(color: Colors.black12)),
      backgroundColor: Colors.white,
      label: Text(
        title,
        style: manropeHeadingTextStyle.copyWith(
          color: const Color(0XFF5B5B5B),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BottomRowContainers extends StatelessWidget {
  const BottomRowContainers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kAppBarColor)),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 49,
            decoration: const BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Image.asset("assets/images/watch.png"),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "246",
                style: kHeading3TextStyle,
              )),
          Container(
            padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
            child: Text(
              "Hours",
              style: kHeading3TextStyle.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
