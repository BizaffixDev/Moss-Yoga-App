import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moss_yoga/app/utils/common_functions.dart';
import 'package:moss_yoga/common/resources/colors.dart';

// class SearchPage extends StatefulWidget {
//   SearchPage({required this.isMyTeachersTab});
//
//   bool isMyTeachersTab;
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isValid = true;
//   bool _isTapped = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_validateInput);
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _validateInput() {
//     String trimmedText = _searchController.text.trim();
//     setState(() {
//       _isValid = trimmedText.isNotEmpty;
//     });
//   }
//
//   void _checkValidity() {
//     setState(() {
//       _isValid = true;
//     });
//   }
//
//   void _handleTap() {
//     setState(() {
//       _isTapped = true;
//     });
//   }
//
//   void _handleFocusChange() {
//     setState(() {
//       _isTapped = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: CommonFunctions.deviceHeight(context) * 0.08,
//       child: Row(
//         children: [
//           SizedBox(
//             width: widget.isMyTeachersTab
//                 ? CommonFunctions.deviceWidth(context) * 0.75
//                 : CommonFunctions.deviceWidth(context) * 0.9,
//             height: 40,
//             child: TextFormField(
//               controller: _searchController,
//               onChanged: (value) {
//                 _checkValidity();
//               },
//               onTap: _handleTap,
//               focusNode: FocusNode()..addListener(_handleFocusChange),
//               onFieldSubmitted: (value) {
//                 if (_isValid) {
//                   // Perform search logic here
//                   print('Search: ${_searchController.text}');
//                 }
//               },
//               decoration: InputDecoration(
//                 isCollapsed: true,
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 hintText: 'Teachers, Yoga Styles or Guide A-Z',
//                 hintStyle: TextStyle(fontSize: 14),
//                 errorText: !_isValid && _isTapped ? 'Input is invalid' : null,
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 4, top: 8, right: 0, bottom: 8),
//                   child: Image.asset(
//                     'assets/images/search_icon.png',
//                     fit: BoxFit.contain,
//                     width: 20,
//                     height: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           widget.isMyTeachersTab
//               ? const SizedBox(
//                   width: 10,
//                 )
//               : SizedBox.shrink(),
//           widget.isMyTeachersTab
//               ? Container(
//                   decoration: BoxDecoration(
//                       color: AppColors.darkGreenSecondary,
//                       borderRadius: BorderRadius.circular(5)),
//                   padding: const EdgeInsets.all(10),
//                   child: Image.asset(
//                     'assets/images/search_filter.png',
//                     width: 20,
//                     height: 18,
//                   ),
//                 )
//               : SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
class SearchPage extends StatelessWidget {
  const SearchPage({super.key, 
    required this.isMyTeachersTab,
    required this.onSearch,
    required this.onSearchTap,
    required this.onSearchFocusChange,
    required this.isSearchValid,
    required this.isSearchTapped,
    required this.searchController,
    this.filterTap,
  });

  final bool isMyTeachersTab;
  final ValueChanged<String> onSearch;
  final VoidCallback onSearchTap;
  final VoidCallback onSearchFocusChange;
  final bool isSearchValid;
  final bool isSearchTapped;
  final VoidCallback? filterTap;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      height: 100.h,
      width: 390.w,
      color: Color(0xffDBDBDB).withOpacity(0.4),// Adjust the height as needed
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Card(

              elevation: 5,
              color: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: isMyTeachersTab
                    ? CommonFunctions.deviceWidth(context) * 0.89
                    : CommonFunctions.deviceWidth(context) * 0.76,
                // Adjust the width as needed

                child: TextField(
                  controller: searchController,
                  onChanged: onSearch,
                 // onTap: onSearchTap,
                 // focusNode: FocusNode()..addListener(onSearchFocusChange),
                 /* onFieldSubmitted: (value) {
                    if (isSearchValid) {
                      onSearch(value);
                    }
                  },*/
                  onSubmitted: (value){
                    if (isSearchValid) {
                      onSearch(value);

                    }
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding:
                         EdgeInsets.symmetric(vertical: 16.h, horizontal: 9.w),
                    hintText: 'Teachers, Yoga Styles or Guide A-Z',
                    hintStyle: const TextStyle(fontSize: 14),
                    errorText: !isSearchValid && isSearchTapped
                        ? 'Input is invalid'
                        : null,
                    border: InputBorder.none,
                 /*   OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),*/
                    enabledBorder:InputBorder.none,
                    /*OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),*/
                    focusedBorder: InputBorder.none,
                    /*OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),*/
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, top: 8, right: 0, bottom: 8),
                      child: Image.asset(
                        'assets/images/search_icon.png',
                        fit: BoxFit.contain,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          isMyTeachersTab ? const SizedBox.shrink() : const SizedBox(width: 10),
          isMyTeachersTab
              ? const SizedBox.shrink()
              : GestureDetector(
                 onTap: filterTap,
                child: Container(

                    decoration: BoxDecoration(
                        color: Color(0xFF7C8364),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/images/search_filter.svg',
                      height: 22.h,
                      width: 22.w,
                    ),
                  ),
              ),
        ],
      ),
    );
  }
}
