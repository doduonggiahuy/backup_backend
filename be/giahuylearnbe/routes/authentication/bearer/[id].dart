import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:giahuylearnbe/repository/user/user_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUser(context, id),
    HttpMethod.patch => _updateUser(context, id),
    HttpMethod.delete => _deleteUser(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getUser(RequestContext context, String id) async {
  final user = await context.read<UserRepository>().userFromId(id);

  if (user == null) {
    return Response(statusCode: HttpStatus.forbidden);
  } else {
    if (user.id != id) {
      return Response(statusCode: HttpStatus.forbidden);
    }
    return Response.json(
      body: {
        'id': user.id,
        'name': user.name,
        'username': user.username,
      },
    );
  }
}

Future<Response> _updateUser(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (name != null || username != null || password != null) {
    await context.read<UserRepository>().updateUser(
          id: id,
          name: name,
          username: username,
          password: password,
        );
    return Response(statusCode: HttpStatus.noContent);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _deleteUser(RequestContext context, String id) async {
  final user = await context.read<UserRepository>().userFromId(id);
  if (user == null) {
    return Response(statusCode: HttpStatus.forbidden);
  } else {
    if (user.id != id) {
      return Response(statusCode: HttpStatus.forbidden);
    }

    context.read<UserRepository>().deleteUser(id);

    return Response(statusCode: HttpStatus.noContent);
  }
}
