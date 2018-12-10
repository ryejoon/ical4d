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

  String toICalendarString() {
    return '$_name=$_value';
  }

  @override
  String toString() {
    return 'Parameter{_name: $_name, _value: $_value}';
  }

  /**
   * parameter values can be escaped by surrounding the value in double-quotes. Parameter values must be escaped if they contain any of the following characters:
      ; - semicolon
      : - colon
      , - comma

      Property parameter values MUST NOT contain the DQUOTE character. The DQUOTE character is used as a delimiter for parameter values that contain restricted characters or URI text.
   */
  static Parameter fromICalendarString(String iCalendarString) {

  }
}

class Value extends Parameter {
  Value(String value) : super("VALUE", value) {}

}