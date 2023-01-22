// import '../providers/user_preferences.dart';
// import '../widgets/row_item.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FavouritesScreen extends StatelessWidget {
//   const FavouritesScreen({super.key});
//   static const routeName = "/favourites";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Favourites"),
//       ),
//       body: FutureBuilder(
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(
//                   color: Theme.of(context).colorScheme.onBackground),
//             );
//           }
//           final data = snapshot.data;
//           if (data!.isEmpty) {
//             return Center(
//               child: Text(
//                 "No favourites, yet!",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             );
//           }

//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisExtent: 250,
//             ),
//             itemBuilder: (context, index) => RowItem(
//               title: data[index]["title"],
//               coverUrl: data[index]["coverUrl"],
//               slug: data[index]["slug"],
//               posterUrl: data[index]["posterUrl"],
//               tag: data[index]["tag"],
//             ),
//             itemCount: data.length,
//           );
//         },
//         future: Provider.of<UserPreferences>(context).fetchFromDB(),
//       ),
//     );
//   }
// }
