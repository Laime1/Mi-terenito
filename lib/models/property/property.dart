class Property {
  final String name;
  final String description;
  final double size;
  final double minPrice;
  final double maxPrice;
  final List<ImageItem> images;

  Property({
    required this.name,
    required this.description,
    required this.size,
    required this.minPrice,
    required this.maxPrice,
    required this.images,
  });
}

class ImageItem {
  final String url;

  ImageItem({required this.url});
}
