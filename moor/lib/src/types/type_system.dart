import 'package:moor/src/types/sql_types.dart';

/// Manages the set of [SqlType] known to a database. It's also responsible for
/// returning the appropriate sql type for a given dart type.
class SqlTypeSystem {
  final List<SqlType> types;

  const SqlTypeSystem(this.types);

  const SqlTypeSystem.withDefaults()
      : this(const [
          BoolType(),
          StringType(),
          IntType(),
          DateTimeType(),
          BlobType()
        ]);

  /// Returns the appropriate sql type for the dart type provided as the
  /// generic parameter.
  SqlType<T> forDartType<T>() {
    return types.singleWhere((t) => t is SqlType<T>) as SqlType<T>;
  }
}
