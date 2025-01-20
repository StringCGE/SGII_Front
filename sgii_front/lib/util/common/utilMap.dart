class UtilMap{
  bool mapEquals(Map<dynamic, dynamic> aMap, Map<dynamic, dynamic> bMap) {
    if (aMap.length != bMap.length) {
      return false;
    }
    for (var entry in aMap.entries) {
      String key = entry.key;
      dynamic value = entry.value;
      if (!bMap.containsKey(key)) {
        return false;
      }
      dynamic bValue = bMap[key];
      if (value is Map && bValue is Map) {
        if (!mapEquals(value, bValue)) {
          return false;
        }
      } else {
        if (value != bValue) {
          return false;
        }
      }
    }
    return true;
  }
}