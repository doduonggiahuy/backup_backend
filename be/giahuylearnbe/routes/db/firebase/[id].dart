import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firedart.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  try {
    await Firestore.instance
        .collection('tasklists')
        .document(id)
        .update({'name': name});

    return Response(body: 'Update successful with id: $id');
  } catch (e) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Error: $e');
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  try {
    await Firestore.instance.collection('tasklists').document(id).delete();
    return Response(body: 'Delete successful with id: $id');
  } catch (e) {
    return Response(statusCode: HttpStatus.badRequest, body: 'Error: $e');
  }
}
