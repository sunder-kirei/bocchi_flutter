// import "dart:convert";

// import 'package:chewie/chewie.dart';
// import '../helpers/http_helper.dart';
// import '../providers/user_preferences.dart';
// import "package:flutter/material.dart";
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class CustomPlayer extends StatefulWidget {
//   final String slug;
//   const CustomPlayer({super.key, required this.slug});

//   @override
//   State<CustomPlayer> createState() => _CustomPlayerState();
// }

// class _CustomPlayerState extends State<CustomPlayer> {
//   int? quality;
//   bool hasLoaded = false;

//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _controller;

//   @override
//   void initState() {
//     initPlayer(
//       index: Provider.of<UserPreferences>(context, listen: false).quality.index,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     _controller?.dispose();
//     super.dispose();
//   }

//   Future<Map<String, dynamic>> fetchVideo() async {
//     final response = await HttpHelper.getVideo(slug: widget.slug);
//     return json.decode(response.body);
//   }

//   Future<void> toggleQuality(int index) async {
//     _videoPlayerController?.pause();
//     final position = await _controller?.videoPlayerController.position;
//     setState(() {
//       hasLoaded = false;
//     });
//     initPlayer(index: index, position: position!);
//     return;
//   }

//   void initPlayer({
//     Duration position = Duration.zero,
//     required int index,
//   }) async {
//     final data = await fetchVideo();
//     final streams = data["streams"];

//     if (streams[0]["kind"] == "premium_alert") {
//       index = index + 1;
//     }

//     if (streams[index]["kind"] == "premium_alert") {
//       setState(() {
//         quality = index + 1;
//       });
//     } else {
//       setState(() {
//         quality = index;
//       });
//     }

//     _videoPlayerController = VideoPlayerController.network(
//       streams[quality!]["url"],
//     );

//     await _videoPlayerController!.initialize();

//     _controller = customChewieController(position, streams);

//     setState(() {
//       hasLoaded = true;
//     });
//   }

//   ChewieController customChewieController(Duration position, streams) {
//     return ChewieController(
//       videoPlayerController: _videoPlayerController!,
//       showControlsOnInitialize: true,
//       deviceOrientationsAfterFullScreen: [
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ],
//       startAt: position,
//       aspectRatio: 16 / 9,
//       materialProgressColors: ChewieProgressColors(
//         backgroundColor: Colors.grey[900] as Color,
//         bufferedColor: Colors.grey[300] as Color,
//         handleColor: const Color.fromRGBO(243, 198, 105, 1),
//         playedColor: const Color.fromRGBO(243, 198, 105, 1),
//       ),
//       additionalOptions: (context) => [
//         OptionItem(
//           onTap: () {
//             Navigator.of(context).pop();
//             showModalBottomSheet(
//               context: context,
//               builder: (context) => SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ...(streams as List<dynamic>).asMap().entries.map((item) {
//                       int index = item.key;
//                       dynamic height = item.value["height"];
//                       return ListTile(
//                         leading: Icon(
//                           Icons.check_rounded,
//                           color: quality == index
//                               ? Theme.of(context).colorScheme.onBackground
//                               : Colors.transparent,
//                         ),
//                         title: Text(height + 'p'),
//                         onTap: height == "1080"
//                             ? () {
//                                 Fluttertoast.cancel();
//                                 Fluttertoast.showToast(
//                                   msg: "Premium only",
//                                   backgroundColor: Colors.white,
//                                   textColor: Colors.black,
//                                 );
//                               }
//                             : () {
//                                 toggleQuality(index);
//                                 Navigator.of(context).pop();
//                               },
//                         trailing: height == "1080" || height == "720"
//                             ? Icon(
//                                 Icons.hd_outlined,
//                                 color: height == "1080"
//                                     ? const Color.fromRGBO(243, 198, 105, 1)
//                                     : Theme.of(context)
//                                         .colorScheme
//                                         .onBackground,
//                               )
//                             : null,
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             );
//           },
//           iconData: Icons.settings,
//           title: "Quality",
//           subtitle: "${streams[quality!]["height"]}p",
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return hasLoaded
//         ? Chewie(controller: _controller!)
//         : Container(
//             color: Theme.of(context).colorScheme.surface,
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).colorScheme.onBackground,
//               ),
//             ),
//           );
//   }
// }
