class ListComponentItem {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  ListComponentItem({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  @override
  String toString() => 'item { id: $id }';
}
