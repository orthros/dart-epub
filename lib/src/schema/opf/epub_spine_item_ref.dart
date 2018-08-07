import 'package:quiver/core.dart';

class EpubSpineItemRef {
  String IdRef;
  bool IsLinear;

  @override
  int get hashCode => hash2(IdRef.hashCode, IsLinear.hashCode);

  bool operator ==(other) {
    var otherAs = other as EpubSpineItemRef;
    if (otherAs == null) {
      return false;
    }

    return IdRef == otherAs.IdRef && IsLinear == otherAs.IsLinear;
  }

  String toString() {
    return "IdRef: ${IdRef}";
  }
}
