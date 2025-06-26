import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
/*
 HOW TO USE:
1. Annotate your DateTime field with @TimestampConverter()
  Example:
     @TimestampConverter()
     DateTime createdAt;
2. Ensure your model class is annotated with @JsonSerializable()
  Example:
    @JsonSerializable()
    class YourModel {
     @TimestampConverter()
      DateTime createdAt;
      // Other fields...
    }
3. Run the build_runner command to generate the necessary code
  dart run build_runner build
*/
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
