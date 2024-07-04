import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/common/resources/colors.dart';


class MyClassesScreenLocked extends StatefulWidget {
  const MyClassesScreenLocked({Key? key}) : super(key: key);

  @override
  State<MyClassesScreenLocked> createState() => _MyClassesScreenLockedState();
}

class _MyClassesScreenLockedState extends State<MyClassesScreenLocked>
    with TickerProviderStateMixin {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  double width = 0.0;
  double height = 0.0;
  late int _startingTabCount;
  final List<Tab> _tabs = <Tab>[];
  late TabController _tabController;
  late TextEditingController _searchController;

  List<String> previousTeachers = [
    'Teacher 1',
    'Teacher 2',
    'Teacher 3',
    'Teacher 4',
    'Teacher 5',
  ];
  List<String> savedTeachers = [
    'Teacher 1',
    'Teacher 3',
    'Teacher 5',
    'Teacher 7',
    'Teacher 9',
    'Teacher 11',
  ];

  // List<String> displayedTeachers = [];
  List<String> displayedTeachersForPrevious = [];
  List<String> displayedTeachersForSaved = [];

  bool isSearchValid = true;
  bool isSearchTapped = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    displayedTeachersForPrevious.addAll(previousTeachers);
    displayedTeachersForSaved.addAll(savedTeachers);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(
      primary: AppColors.primaryColor, // Set the primary color of the theme
      onPrimary: Colors.white, // Set the text color on the primary color
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select a date',
      // Optional, provide a help text
      cancelText: 'Cancel',
      // Optional, customize the cancel button text
      confirmText: 'OK',
      // Optional, customize the confirm button text
      errorFormatText: 'Invalid date format',
      // Optional, customize the error message for invalid date format
      errorInvalidText: 'Invalid date',
      // Optional, customize the error message for invalid date
      fieldLabelText: 'Date',
      // Optional, customize the label text for the date input field
      fieldHintText: 'Month/Date/Year',
      // Optional, customize the hint text for the date input field
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(colorScheme: colorScheme),
          // Apply the custom color scheme
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String getMonthName() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM');
    final String monthName = formatter.format(now);
    return monthName;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: const Text('Locked'),
      ),
    );
  }
}
