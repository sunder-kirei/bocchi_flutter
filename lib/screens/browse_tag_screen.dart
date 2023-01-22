// import "dart:convert";

// import '../providers/user_preferences.dart';
// import '../widgets/hentai_card.dart';
// import '../widgets/search_button.dart';
// import '../widgets/sort_options.dart';
// import 'package:flutter/material.dart';

// import '../helpers/http_helper.dart';
// import 'package:provider/provider.dart';

// class BrowseTagScreen extends StatefulWidget {
//   static const routeName = "/browse/tag";
//   const BrowseTagScreen({super.key});

//   @override
//   State<BrowseTagScreen> createState() => _BrowseTagScreenState();
// }

// class _BrowseTagScreenState extends State<BrowseTagScreen> {
//   bool isLoading = true;
//   int page = 0;
//   List<dynamic>? fetchedData;
//   OrderBy? orderBy;
//   Ordering? ordering;

//   @override
//   void didChangeDependencies() {
//     orderBy = Provider.of<UserPreferences>(context).orderBy;
//     ordering = Provider.of<UserPreferences>(context).ordering;
//     fetchData();
//     super.didChangeDependencies();
//   }

//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });

//     final response = await HttpHelper.getTag(
//       tag: ModalRoute.of(context)?.settings.arguments as String,
//       orderBy: orderBy!,
//       ordering: ordering!,
//       page: page,
//     );
//     setState(() {
//       isLoading = false;
//       fetchedData = json.decode(response.body)["hentai_videos"];
//     });
//   }

//   void orderByCallback(OrderBy order) {
//     Navigator.of(context).pop();
//     setState(() {
//       orderBy = order;
//     });
//     fetchData();
//     return;
//   }

//   void orderingCallback(Ordering order) {
//     Navigator.of(context).pop();
//     setState(() {
//       ordering = order;
//     });
//     fetchData();
//     return;
//   }

//   String getTitle(String title) {
//     return title
//         .split(' ')
//         .map((element) {
//           if (element == "bdsm" ||
//               element == "3d" ||
//               element == "hd" ||
//               element == "ntr" ||
//               element == "pov") {
//             return element.toUpperCase();
//           }
//           return element.toUpperCase()[0] + element.substring(1);
//         })
//         .toList()
//         .join(' ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           getTitle(ModalRoute.of(context)?.settings.arguments as String),
//         ),
//         actions: [
//           if (page > 0)
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   page = page - 1;
//                 });
//                 fetchData();
//               },
//               icon: const Icon(Icons.arrow_upward_rounded),
//               tooltip: "Next Page",
//               key: const ValueKey("Down"),
//             ),
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 page = page + 1;
//               });
//               fetchData();
//             },
//             icon: const Icon(Icons.arrow_downward_rounded),
//             tooltip: "Next Page",
//             key: const ValueKey("Up"),
//           ),
//           SortOptions(
//             orderByCallback: orderByCallback,
//             orderingCallback: orderingCallback,
//             curOrderBy: orderBy!,
//             curOrdering: ordering!,
//           ),
//         ],
//       ),
//       floatingActionButton: const SearchButton(),
//       body: fetchedData == null || isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).colorScheme.onBackground,
//               ),
//             )
//           : ListView.builder(
//               itemBuilder: (context, index) => HentaiCard(
//                 data: fetchedData![index],
//               ),
//               itemCount: fetchedData!.length,
//             ),
//     );
//   }
// }
