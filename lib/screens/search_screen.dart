import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';
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
  final FocusNode _focusNode = FocusNode();

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
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  focusNode: _focusNode,
                  onEditingComplete: () {
                    _focusNode.unfocus();
                    fetchData(_controller!.text);
                  },
                  decoration: InputDecoration(hintText: "Search"),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                Focus(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (!_focusNode.hasFocus) {
                        _focusNode.requestFocus();
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      fetchData(_controller!.text);
                    },
                    icon: const Icon(Icons.search_outlined),
                    label: const Text("Search"),
                  ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2 / 3,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final data = fetchedData!["results"][index];
                return SearchCard(
                  callback: () => FocusScope.of(context).unfocus(),
                  title: data["title"],
                  type: data["type"],
                  image: data["image"],
                  id: data["id"],
                  disabled: data["status"] == "Not yet aired" ||
                      data["malId"] == null,
                );
              },
              childCount: fetchedData!["results"].length,
            ),
          ),
      ],
    );
  }
}
