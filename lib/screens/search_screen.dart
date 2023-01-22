import 'dart:convert';

import 'package:anime_api/widgets/row_item.dart';

import '../widgets/filter_modal.dart';
import '../widgets/sort_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/http_helper.dart';
import '../providers/user_preferences.dart';
import '../widgets/search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const routeName = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  int page = 0;
  TextEditingController? _controller;
  Map<String, dynamic>? fetchedData;
  FocusNode? _focusNode;

  void fetchData(String query) async {
    setState(() {
      isLoading = true;
    });
    final response = await HttpHelper.searchApi(
      query: _controller!.text,
    );
    setState(() {
      isLoading = false;
      fetchedData = response;
    });
    print(fetchedData);
  }

  // void orderByCallback(OrderBy order) {
  //   Navigator.of(context).pop();
  //   setState(() {
  //     orderBy = order;
  //   });
  //   fetchData(_controller!.text);
  //   return;
  // }

  // void orderingCallback(Ordering order) {
  //   Navigator.of(context).pop();
  //   setState(() {
  //     ordering = order;
  //   });
  //   fetchData(_controller!.text);
  //   return;
  // }

  // Widget buildFilterTab({
  //   required FilterType filterType,
  //   required IconData iconData,
  //   required String title,
  // }) {
  //   return Flexible(
  //     child: OutlinedButton.icon(
  //       onPressed: () {
  //         if (_focusNode!.hasFocus) _focusNode!.unfocus();
  //         buildFilterOptions(
  //           context: context,
  //           filterType: filterType,
  //         );
  //       },
  //       icon: Icon(iconData),
  //       label: FittedBox(
  //         child: Text(title),
  //       ),
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // orderBy = Provider.of<UserPreferences>(context, listen: false).orderBy;
    // ordering = Provider.of<UserPreferences>(context, listen: false).ordering;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      _focusNode?.requestFocus();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
          // actions: [
          //   if (page > 0)
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           page = page - 1;
          //         });
          //         fetchData(_controller!.text);
          //       },
          //       icon: const Icon(Icons.arrow_upward_rounded),
          //       tooltip: "Next Page",
          //       key: const ValueKey("Down"),
          //     ),
          //   IconButton(
          //     onPressed: () {
          //       setState(() {
          //         page = page + 1;
          //       });
          //       fetchData(_controller!.text);
          //     },
          //     icon: const Icon(Icons.arrow_downward_rounded),
          //     tooltip: "Next Page",
          //     key: const ValueKey("Up"),
          //   ),
          //   SortOptions(
          //     orderByCallback: orderByCallback,
          //     orderingCallback: orderingCallback,
          //     curOrderBy: orderBy!,
          //     curOrdering: ordering!,
          //   )
          // ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      cursorColor: const Color.fromRGBO(243, 198, 105, 1),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      onEditingComplete: () {
                        _focusNode!.unfocus();
                        fetchData(_controller!.text);
                      },
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(243, 198, 105, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // SizedBox(
                    //   height: 50,
                    //   child: Flex(
                    //     direction: Axis.horizontal,
                    //     children: [
                    //       buildFilterTab(
                    //         filterType: FilterType.tag,
                    //         iconData: Icons.sell_outlined,
                    //         title: "Tags",
                    //       ),
                    //       const SizedBox(
                    //         width: 5,
                    //       ),
                    //       buildFilterTab(
                    //         filterType: FilterType.brand,
                    //         iconData: Icons.copyright_outlined,
                    //         title: "Brands",
                    //       ),
                    //       const SizedBox(
                    //         width: 5,
                    //       ),
                    //       buildFilterTab(
                    //         filterType: FilterType.blacklist,
                    //         iconData: Icons.filter_list_rounded,
                    //         title: "Blacklist",
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Divider(),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (!_focusNode!.hasFocus) {
                          _focusNode!.requestFocus();
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        fetchData(_controller!.text);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromRGBO(243, 198, 105, 1),
                        ),
                      ),
                      icon: const Icon(Icons.search_outlined),
                      label: const Text("Search"),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            if (isLoading)
              SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            if (fetchedData != null && isLoading == false)
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 250,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final data = fetchedData!["results"][index];

                    return SizedBox(
                      child: Stack(
                        children: [
                          RowItem(
                            title: data["title"],
                            tag: data["id"],
                            image: data["image"],
                            id: data["id"],
                            disabled: data["status"] == "Not yet aired",
                          ),
                          Positioned(
                            top: 20,
                            right: 4,
                            child: FittedBox(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(5),
                                  ),
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Text(
                                  data["type"],
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: fetchedData!["results"].length,
                ),
              ),
          ],
        ));
  }

  // Future<dynamic> buildFilterOptions({
  //   required BuildContext context,
  //   required FilterType filterType,
  // }) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (context) => FilterModal(
  //       filterType: filterType,
  //       fetchData: () {
  //         Navigator.of(context).pop();
  //         fetchData(_controller!.text);
  //       },
  //     ),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(5),
  //         topRight: Radius.circular(5),
  //       ),
  //     ),
  //   );
  // }
}
