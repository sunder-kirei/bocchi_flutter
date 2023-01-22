// import 'dart:convert';

// import '../helpers/http_helper.dart';
// import '../widgets/hentai_card.dart';
// import '../widgets/search_button.dart';
// import '../widgets/sort_options.dart';
// import 'package:flutter/material.dart';

// class BrowseBrandScreen extends StatefulWidget {
//   const BrowseBrandScreen({super.key});
//   static const routeName = "/brand";

//   @override
//   State<BrowseBrandScreen> createState() => _BrowseBrandScreenState();
// }

// class _BrowseBrandScreenState extends State<BrowseBrandScreen> {
//   bool isLoading = true;
//   int page = 0;
//   dynamic brand;
//   dynamic brandName;
//   dynamic fetchedData;
//   OrderBy orderBy = OrderBy.released_at_unix;
//   Ordering ordering = Ordering.desc;

//   @override
//   void didChangeDependencies() {
//     brand = ((ModalRoute.of(context)?.settings.arguments
//         as Map<String, dynamic>)["brand_slug"] as String);
//     brandName = ((ModalRoute.of(context)?.settings.arguments
//         as Map<String, dynamic>)["brand"] as String);
//     fetchData();
//     super.didChangeDependencies();
//   }

//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });
//     final response = await HttpHelper.getBrand(
//       brand: brand,
//       orderBy: orderBy,
//       ordering: ordering,
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(brandName),
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
//             curOrderBy: orderBy,
//             curOrdering: ordering,
//           ),
//         ],
//       ),
//       floatingActionButton: const SearchButton(),
//       body: fetchedData == null || isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                   color: Theme.of(context).colorScheme.onBackground),
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
