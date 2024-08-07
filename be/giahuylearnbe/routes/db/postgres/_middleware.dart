import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'learnbe',
      username: 'postgres',
      password: 'admin',
    );

    // Open the connection
    await connection.open();

    // Add the connection to the context
    final response = await handler
        .use(provider<PostgreSQLConnection>((_) => connection))
        .call(context);

    // Close the connection
    await connection.close();

    return response;
  };
}
