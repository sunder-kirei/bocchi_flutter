// import '../widgets/search_button.dart';
// import 'package:flutter/material.dart';

// import '../widgets/browse_card.dart';
// import '../models/browse_page_data.dart';

// class BrowseScreen extends StatelessWidget {
//   static const routeName = "/browse";
//   const BrowseScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Browse"),
//       ),
//       floatingActionButton: const SearchButton(),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           childAspectRatio: 16 / 9,
//         ),
//         itemBuilder: (context, index) {
//           final data = BrowsePageData.tags[index];
//           return BrowseCard(
//             data: data,
//           );
//         },
//         itemCount: BrowsePageData.tags.length,
//         padding: const EdgeInsets.all(5),
//       ),
//     );
//   }
// }
