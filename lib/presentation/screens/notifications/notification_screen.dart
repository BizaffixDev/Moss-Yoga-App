import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moss_yoga/common/resources/colors.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  RemoteMessage? message;

  NotificationsScreen({Key? key, this.message}) : super(key: key);

  @override
  _NotificationsScreeenState createState() => _NotificationsScreeenState();
}

class _NotificationsScreeenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // int _selectedIndex = 0;
  // // Widget currentScreen = Settings();
  // final List<Widget> _screens = [
  //   const PersonalPage(),
  //   BuildOpportunitiesScreen(),
  //   BuildMainpageScreen(),
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await ref
      //     .read(notificationResponseProvider.notifier)
      //     .getUserNotifications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Text(widget.message?.notification?.title.toString() ??
              'No Title to show'),
          Text(widget.message?.notification?.body.toString() ??
              'No Body to show'),
          DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      print("Tapped");
                      print("refreshed Tab Providers");
                      context.pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(25, 85, 350, 0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                //
                Padding(
                  padding: const EdgeInsets.fromLTRB(77, 10, 78, 10),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: const Color(0xffF8F8F8).withOpacity(1),
                    ),
                    child: TabBar(
                      onTap: (index) {
                        print('tapped at this index: $index');
                        if (index == 1) {
                          print('tabController.index == 1');
                          // ref.read(notificationForceChangeTab1Provider.notifier).state = true;
                          setState(() {});
                        }
                        // if(ref.watch(notificationForceChangeTab1Provider) == true && index== 0)
                        // {
                        //   print('Tab1Provider is now ${ref.watch(notificationForceChangeTab1Provider)} ');
                        //   ref.read(notificationForceChangeTab2Provider.notifier).state = true;
                        //   setState(() {});
                        // }
                      },
                      indicatorColor: Colors.grey,
                      unselectedLabelColor: AppColors.greyColor,
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xffEAEAEA)),
                      ),
                      tabs: const [
                        Tab(
                            child: Text(
                          'common',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        )
                            // icon: Icon(Icons.people),
                            ),
                        Tab(
                            child: Text(
                          'investments',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ))
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      ///Common Screen

                      ///Investment Screen
                      // InvestmentScreenWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Consumer(
          //   builder: (context, ref, _) {
          //     // final screenState = ref.watch(notificationResponseListTodayProvider);
          //     final screenState = ref.watch(notificationResponseListTodayProvider);
          //     if (screenState is Loading) {
          //       return const Loader();
          //     }
          //     return const SizedBox.shrink();
          //   },
          // ),
          // Widget build(BuildContext context) {
          //  Scaffold(
          //   body: Center(
          //     child: _screens[_selectedIndex],
          //   ),
          //   bottomNavigationBar: BottomAppBar(
          //     child: bottomTabs(context),
          //   ),
          // ),
          // }
        ],
      ),
    );
  }
}
