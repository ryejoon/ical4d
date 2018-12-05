class Parameter {
  String name;
  String value;

  @override
  String toString() {
    return 'Parameter{$name:$value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Parameter &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              value == other.value;

  @override
  int get hashCode =>
      name.hashCode ^
      value.hashCode;
}

class Value extends Parameter {
  Value() {
    name = "VALUE";
  }



}