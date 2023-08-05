import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:kidscan_app/pages/child_graph.dart';
import 'package:kidscan_app/pages/show_record_list.dart';

class HomePage extends StatefulWidget {
  final int childId;
  const HomePage({super.key, required this.childId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late int childId;
  late TabController _tabController;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    childId = widget.childId;
    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _selectedIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Home')),
      extendBody: true,
      // body: getBodyPage().elementAt(_selectedIndex),

      body: TabBarView(
        controller: _tabController,
        physics: const PageScrollPhysics(),
        children: getBodyPage(),
      ), //혹시 넘기는 모션이 로드부담이 될 가능성..
      bottomNavigationBar: TabBar(
        controller: _tabController,
        onTap: _onItemTapped,
        tabs: const [
          Tab(icon: Icon(MaterialSymbols.home_outlined)),
          Tab(icon: Icon(Icons.description_outlined)),
          Tab(icon: Icon(MaterialSymbols.stethoscope)),
          Tab(icon: Icon(MaterialSymbols.person)),
          Tab(icon: Icon(MaterialSymbols.chat_bubble)),
        ],
        labelColor: Colors.green,
        unselectedLabelColor: Colors.amber,
        indicatorColor: Colors.purple,
        dividerColor: Colors.red,
      ),
    );
  }

  List<Widget> getBodyPage() {
    int idx = childId;
    return [
      ChildGraph(childId: idx),
      ShowRecordList(childId: idx),
      Center(
          child: Container(
        color: Colors.blue,
        width: 30,
        height: 20,
        child: Text('$idx', textAlign: TextAlign.center),
      )),
      Center(
          child: Container(
        color: Colors.blue,
        width: 30,
        height: 20,
      )),
      Center(
          child: Container(
        color: Colors.blue,
        width: 30,
        height: 20,
      )),

      // ChatBot(),

      // ChatBot(),
    ];
  }
}





// BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             // fixedColor: Colors.red,
//             selectedItemColor: Colors.red,
//             unselectedItemColor: Colors.blue,
//             backgroundColor: Colors.orange[200],
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(MaterialSymbols.home_outlined),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.description_outlined),
//                 label: 'Child Record',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(MaterialSymbols.stethoscope),
//                 label: 'chatbot',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(MaterialSymbols.person),
//                 label: 'information',
//               ),
//             ],
//           )