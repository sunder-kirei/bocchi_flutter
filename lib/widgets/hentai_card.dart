// import '../screens/details_screen.dart';
// import 'package:flutter/material.dart';

// class HentaiCard extends StatelessWidget {
//   final dynamic data;
//   const HentaiCard({super.key, this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(5),
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: GestureDetector(
//                     child: Image.network(data["poster_url"]),
//                     onTap: () {
//                       if (FocusScope.of(context).hasFocus) {
//                         FocusScope.of(context).unfocus();
//                       }
//                       Navigator.of(context).pushNamed(
//                         DetailsScreen.routeName,
//                         arguments: {
//                           "slug": data["slug"],
//                           "poster": data["poster_url"],
//                           "cover_url": data["cover_url"],
//                           "tag": data["slug"],
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   height: 60,
//                 ),
//               ],
//             ),
//             Positioned(
//               bottom: 10,
//               left: 5,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   boxShadow: <BoxShadow>[
//                     BoxShadow(
//                       offset: Offset(1, -2),
//                       blurRadius: 10,
//                       color: Colors.black26,
//                     ),
//                   ],
//                 ),
//                 height: 130,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(5),
//                   child: Hero(
//                     tag: data["slug"],
//                     child: Image.network(
//                       data["cover_url"],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 100,
//               child: SizedBox(
//                 height: 60,
//                 width: MediaQuery.of(context).size.width - 110,
//                 child: Flex(
//                   direction: Axis.horizontal,
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       flex: 1,
//                       child: Text(
//                         data["name"],
//                         maxLines: 2,
//                         style: Theme.of(context).textTheme.titleSmall,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Chip(
//                       label: Text(
//                         data["brand"],
//                         style: const TextStyle(
//                           color: Color.fromRGBO(243, 198, 105, 1),
//                         ),
//                       ),
//                       avatar: const Icon(
//                         Icons.copyright_rounded,
//                         color: Color.fromRGBO(243, 198, 105, 1),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
