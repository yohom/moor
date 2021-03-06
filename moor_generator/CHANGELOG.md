## 1.3.0
- Moor now supports table joins
  - Added table aliases
- Default values for columns: Just use the `withDefault` method when declaring a column
  - added expressions that resolve to the current date or time
- Fixed a crash that would occur if the first operation was a transaction
- Better support for custom expressions as part of a regular query
- Faster hashcode implementation in generated data classes

## 1.2.0
- Blob data type
- Generated classes now use lazy getters instead of recalculating fields on each access
- Custom Constraints
- Data classes can be converted from and to json

## 1.1.0
- The generated data classes now implement `toString()`

## 1.0.0
- Initial version of the Moor generator