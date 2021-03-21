import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/networking/services/search_service.dart';
import 'package:manga_reader/screens/Lelscan/manga_details.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/search_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

class SearchManga extends SearchDelegate {
  String source;
  SearchManga(this.source);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    SizeConfig().init(context);
    //context.read<SearchProvider>().getSearchResults(source, query, 1);
    return FutureBuilder(
        future: searchService.searchManga(source, query, 1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.black,
              child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 2.5,
                    right: SizeConfig.blockSizeHorizontal * 2.5,
                    top: SizeConfig.blockSizeVertical * 4,
                    bottom: SizeConfig.blockSizeVertical * 4,
                  ),
                  crossAxisSpacing: SizeConfig.blockSizeHorizontal * 2,
                  mainAxisSpacing: SizeConfig.blockSizeVertical,
                  children: List.generate(snapshot.data.length, (index) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ScaleRoute(
                                        page: LelscanDetail(
                                      manga: snapshot.data[index],
                                    )));
                              },
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index].thumbnailUrl
                                        .startsWith("//")
                                    ? "https:" + snapshot.data[index].thumbnailUrl
                                    : snapshot.data[index].thumbnailUrl
                                        .replaceAll('http', "https"),
                                width: double.infinity,
                                height: 350,
                                errorWidget: (context, text, data) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          ScaleRoute(
                                              page: LelscanDetail(
                                            manga: snapshot.data[index],
                                          )));
                                    },
                                    child: Image.asset(
                                      Assets.errorImage,
                                      width: double.infinity,
                                      height: 350,
                                    ),
                                  );
                                },
                                //fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical),
                            child: Text(
                              snapshot.data[index].title,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
            );
          } else {
            return Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
