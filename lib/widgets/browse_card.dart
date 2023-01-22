// import '../screens/browse_tag_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:transparent_image/transparent_image.dart';

// class BrowseCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//   const BrowseCard({super.key, required this.data});

//   String get getTitle {
//     return data["text"]
//         .toString()
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
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).pushNamed(
//           BrowseTagScreen.routeName,
//           arguments: data["text"],
//         );
//       },
//       child: Card(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(5),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: FadeInImage(
//                   placeholder: MemoryImage(
//                     kTransparentImage,
//                   ),
//                   image: CachedNetworkImageProvider(
//                     data["wide_image_url"],
//                   ),
//                   fit: BoxFit.cover,
//                   fadeInDuration: const Duration(milliseconds: 200),
//                   fadeInCurve: Curves.easeIn,
//                 ),
//               ),
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Theme.of(context).colorScheme.surface,
//                         Colors.transparent,
//                       ],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 40,
//                 width: MediaQuery.of(context).size.width * 4 / 5,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(
//                           data["tall_image_url"],
//                         ),
//                         radius: 30,
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 2),
//                         child: Text(
//                           getTitle,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontFamily: "Roboto",
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(2.0),
//                         child: Text(
//                           data["description"],
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.normal,
//                             color: Color.fromRGBO(243, 198, 105, 1),
//                             height: 1.2,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
