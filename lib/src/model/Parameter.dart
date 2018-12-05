class Parameter {
  String _name;
  String _value;

  Parameter(this._name, this._value);

  String get name => _name;

  String get value => _value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Parameter &&
              runtimeType == other.runtimeType &&
              _name == other._name &&
              _value == other._value;

  @override
  int get hashCode =>
      _name.hashCode ^
      _value.hashCode;

  @override
  String toString() {
    return 'Parameter{_name: $_name, _value: $_value}';
  }
}

class Value extends Parameter {
  Value(String value) : super("VALUE", value) {}

}