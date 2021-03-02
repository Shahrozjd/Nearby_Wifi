import 'dart:convert';

//This is Model of Wifi class you can add more properties in it as required
class Wifi {
  final String wifiName;
  final double signalStrength;
  Wifi({
    this.wifiName,
    this.signalStrength,
  });
//This method is used to copy different properties into each other kinda merging two wifi objects into one
  Wifi copyWith({
    String wifiName,
    double signalStrength,
  }) {
    return Wifi(
      wifiName: wifiName ?? this.wifiName,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }

//This method is crucial becuase you cant just send date to firebase in an Dart class format you have to convert it into the json format
//this method is used to convert dart class into json format to send to the server
  Map<String, dynamic> toMap() {
    return {
      'wifiName': wifiName,
      'signalStrength': signalStrength,
    };
  }

//similarly this method is used to convert json format from firebase to dart class to used in the app
  factory Wifi.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Wifi(
      wifiName: map['wifiName'],
      signalStrength: map['signalStrength'],
    );
  }

// These are just extension methods of above methods
  String toJson() => json.encode(toMap());

  factory Wifi.fromJson(String source) => Wifi.fromMap(json.decode(source));

  @override
  String toString() =>
      'Wifi(wifiName: $wifiName, signalStrength: $signalStrength)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Wifi &&
        o.wifiName == wifiName &&
        o.signalStrength == signalStrength;
  }

  @override
  int get hashCode => wifiName.hashCode ^ signalStrength.hashCode;
}
