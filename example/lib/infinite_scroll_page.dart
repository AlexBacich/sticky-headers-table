import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:table_sticky_headers/table_sticky_headers.dart';

class InfiniteScrollPage extends StatefulWidget {
  @override
  State<InfiniteScrollPage> createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  // List<Breed> listBreeds = [];
  final scrollController = ScrollController();
  String dataUrl = 'https://catfact.ninja/breeds';
  bool hasMore = true;
  bool isLoading = false;

  final legendCell = 'Breed';
  List<String> titleColumn = ['Country', 'Origin', 'Coat', 'Pattern'];
  List<String> titleRow = [];
  List<List<String>> matrixBreeds = [];

  @override
  void initState() {
    super.initState();

    fetchData();

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll with Network Data'),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            // TODO Refresh isn't working
            onRefresh: refreshData,
            child: StickyHeadersTable(
              scrollControllers:
                  ScrollControllers(verticalBodyController: scrollController),
              columnsLength: titleColumn.length,
              rowsLength: titleRow.length,
              columnsTitleBuilder: (i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(titleColumn[i],
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              rowsTitleBuilder: (i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(titleRow[i],
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              contentCellBuilder: (i, j) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(matrixBreeds[j][i]),
              ),
              legendCell: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(legendCell,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              cellAlignments: CellAlignments.fixed(
                contentCellAlignment: Alignment.topLeft,
                stickyColumnAlignment: Alignment.topLeft,
                stickyRowAlignment: Alignment.centerLeft,
                stickyLegendAlignment: Alignment.centerLeft,
              ),
              cellDimensions: CellDimensions.fixed(
                contentCellWidth: screenWidth / 3.3,
                contentCellHeight: 50, // TODO Not all fits in a cell
                stickyLegendWidth: screenWidth / 3.3,
                stickyLegendHeight: 50,
              ),
            ),
          ),
          // hasMore
          isLoading
              // TODO Not working after the first load
              ? Center(child: const CircularProgressIndicator())
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    if (isLoading) return;
    if (dataUrl.isEmpty) return;
    isLoading = true;

    try {
      final response = await Dio().get(
        dataUrl,
        queryParameters: {
          'accept': 'application/json',
          'X-CSRF-TOKEN': 'Ff5zTFjNYMSMeRLz30Pq0CDAK09rvbLVg65Bo73h',
        },
      );
      Breeds newBreedsData = Breeds.fromJson(response.data);
      final List<Breed> newListBreeds = newBreedsData.data ?? [];

      newListBreeds.forEach((e) {
        titleRow.add(e.breed ?? '');
        matrixBreeds.add(
            [e.country ?? '', e.origin ?? '', e.coat ?? '', e.pattern ?? '']);
      });

      setState(() {
        dataUrl = newBreedsData.nextPageUrl ?? '';
        isLoading = false;

        if (newBreedsData.currentPage == newBreedsData.lastPage) {
          hasMore = false;
          // TODO Appears when loading the last portion, but not exactly at the end
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No more data to load')));
        }

        // listBreeds.addAll(newListBreeds);
        matrixBreeds;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Occur data loading error. Please try latter')));
      print('Loading error: $e');
    }

    print(legendCell);
    print(titleColumn);
    print(titleRow);
    print(matrixBreeds);
    print(matrixBreeds.isNotEmpty
        ? matrixBreeds[matrixBreeds.length - 1]
        : 'matrixBreeds is blank');
    print(matrixBreeds.length);
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      dataUrl = 'https://catfact.ninja/breeds';
      // listBreeds.clear();
      matrixBreeds.clear();
    });

    fetchData();
  }
}

class Breeds {
  int? currentPage;
  List<Breed>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Breeds(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  factory Breeds.fromJson(Map<String, dynamic> json) {
    return Breeds(
      currentPage: json['current_page'],
      data: json['data'] != null
          ? json['data'].map<Breed>((json) => Breed.fromJson(json)).toList()
          : null,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: json['links'] != null
          ? json['links'].map<Link>((json) => Link.fromJson(json)).toList()
          : null,
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Breed {
  String? breed;
  String? country;
  String? origin;
  String? coat;
  String? pattern;

  Breed({this.breed, this.country, this.origin, this.coat, this.pattern});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      breed: json['breed'],
      country: json['country'],
      origin: json['origin'],
      coat: json['coat'],
      pattern: json['pattern'],
    );
  }
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
