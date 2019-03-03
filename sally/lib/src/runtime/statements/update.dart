import 'dart:async';

import 'package:sally/sally.dart';
import 'package:sally/src/runtime/components/component.dart';

class UpdateStatement<T, D> extends Query<T, D> {
  UpdateStatement(QueryEngine database, TableInfo<T, D> table)
      : super(database, table);

  Map<String, dynamic> _updatedFields;

  @override
  void writeStartPart(GenerationContext ctx) {
    // TODO support the OR (ROLLBACK / ABORT / REPLACE / FAIL / IGNORE...) thing

    ctx.buffer.write('UPDATE ${table.$tableName} SET ');

    var first = true;
    _updatedFields.forEach((columnName, variable) {
      if (!first) {
        ctx.buffer.write(', ');
      } else {
        first = false;
      }

      ctx.buffer..write(columnName)..write(' = ');

      variable.writeInto(ctx);
    });
  }

  /// Writes all non-null fields from [entity] into the columns of all rows
  /// that match the set [where] and limit constraints. Warning: That also
  /// means that, when you're not setting a where or limit expression
  /// explicitly, this method will update all rows in the specific table.
  Future<int> write(D entity) async {
    if (!table.validateIntegrity(entity, false)) {
      throw InvalidDataException(
          'Invalid data: $entity cannot be written into ${table.$tableName}');
    }

    _updatedFields = table.entityToSql(entity)
      ..remove((_, value) => value == null);

    if (_updatedFields.isEmpty) {
      // nothing to update, we're done
      return Future.value(0);
    }

    final ctx = constructQuery();
    final rows = await ctx.database.executor.doWhenOpened((e) async {
      return await e.runUpdate(ctx.sql, ctx.boundVariables);
    });

    if (rows > 0) {
      database.markTableUpdated(table.$tableName);
    }

    return rows;
  }
}
