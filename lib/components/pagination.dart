class Pagination {
  int page = 1;
  int offset = 0;
  int size = 50;

  void increase() {
    page++;
    offset = page * size - size;
  }

  void reset() {
    page = 1;
    offset = 0;
  }
}
