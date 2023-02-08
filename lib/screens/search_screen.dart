import 'package:anime_api/widgets/bocchi_rich_text.dart';
import 'package:flutter/material.dart';

import '../helpers/http_helper.dart';
import '../widgets/preferences_modal.dart';
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
  void didChangeDependencies() {
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
          title: const BocchiRichText(),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const PreferencesModal(),
                );
              },
              icon: const Icon(
                Icons.more_vert_rounded,
              ),
            ),
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              child: CustomScrollView(
                slivers: [
                  if (isLoading)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  if (fetchedData != null && isLoading == false)
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  suffixIcon: const Icon(
                    Icons.search_outlined,
                  ),
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                  labelStyle: Theme.of(context).textTheme.displayLarge,
                  labelText: "Search",
                  floatingLabelStyle:
                      Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                ),
                controller: _controller,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                    ),
                textCapitalization: TextCapitalization.sentences,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  fetchData(_controller!.text);
                },
              ),
            ),
          ],
        ));
  }
}
