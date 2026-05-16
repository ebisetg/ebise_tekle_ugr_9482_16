class Helpers {
  static String imageFallback(String? url) {
    return url ?? 'https://via.placeholder.com/400x200?text=No+Image';
  }
}