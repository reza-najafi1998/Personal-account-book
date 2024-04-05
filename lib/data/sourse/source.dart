abstract class DataSource<T>{
  Future<List<T>> getall({String searchKeyword});
  Future<void> deleteall();
  Future<void> delete(T data);
  Future<void> deleteById(id);
  Future<T> createOrSave(T data);
}