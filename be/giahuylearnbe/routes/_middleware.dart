import 'package:dart_frog/dart_frog.dart';
import 'package:giahuylearnbe/repository/items/items_repository.dart';
import 'package:giahuylearnbe/repository/lists/lists_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        requestLogger(),
      )
      .use(provider<TaskListRepository>((context) => TaskListRepository()))
      .use(provider<TaskItemRepository>((context) => TaskItemRepository()));
}
