class EnumFromString<T> {
  List<T> enumValues;

  EnumFromString(List<T> this.enumValues);

  T get(String value) {
    value = "$T.$value";
    try {
      var x = this
          .enumValues
          .firstWhere((f) => f.toString().toUpperCase() == value.toUpperCase());
      return x;
    } catch (e) {
      return null;
    }
  }
}
