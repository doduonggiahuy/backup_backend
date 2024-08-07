import 'package:equatable/equatable.dart';
import 'package:giahuylearnbe/hash_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'lists_repository.g.dart';

@visibleForTesting

///Data source - in memory cache
Map<String, TaskList> listdb = {};

@JsonSerializable()
class TaskList extends Equatable {
  ///Constructor
  const TaskList({
    required this.id,
    required this.name,
  });

  ///deserialization
  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  TaskList copyWith({String? id, String? name}) {
    return TaskList(id: id ?? this.id, name: name ?? this.name);
  }

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  ///serialization
  @override
  List<Object?> get props => [id, name];
}

/// Repository class for TaskList
class TaskListRepository {
  /// Check in the internal data source for a list with the given [id
  Future<TaskList?> listById(String id) async {
    return listdb[id];
  }

  /// Get all the lists from the data source
  Map<String, dynamic> getAllLists() {
    final formattedList = <String, dynamic>{};

    if (listdb.isNotEmpty) {
      listdb.forEach(
        (String id) {
          final currentList = listdb[id];
          formattedList[id] = currentList?.toJson();
        } as void Function(String key, TaskList value),
      );
    }
    return formattedList;
  }

  /// Create a new list with a given [name]
  String createList({required String name}) {
    /// dynamically generates the id
    final id = name.hashValue;

    /// create our new TaskList object and pass our two parameters
    final list = TaskList(id: id, name: name);

    /// add a new Tasklist object to our data source
    listdb[id] = list;
    return id;
  }

  /// Deletes the Tasklist object with the given [id]
  void deleteList(String id) {
    listdb.remove(id);
  }

  /// Update operation
  Future<void> updateList({required String id, required String name}) async {
    final currentList = listdb[id];

    if (currentList == null) {
      return Future.error(Exception('List not found'));
    }

    listdb[id] = TaskList(id: id, name: name);
  }
}
