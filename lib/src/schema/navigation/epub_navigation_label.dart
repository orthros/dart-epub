class EpubNavigationLabel {
  String Text;

  @override
  int get hashCode => Text.hashCode;

  bool operator ==(other) {
    var otherAs = other as EpubNavigationLabel;
    if (otherAs == null) return false;
    return Text == otherAs.Text;
  }

  String toString() {
    return Text;
  }
}
