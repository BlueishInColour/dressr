import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) {
  //
  final parameters = context.request.uri.queryParameters;

  final id = parameters['id'] ?? '';

  //
  if (id.isNotEmpty) {
    _getOneStories(context);
  }

  return switch (context.request.method) {
    HttpMethod.get => _getStories(context),
    HttpMethod.post => _createStories(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getOneStories(RequestContext context) async {
  final short = await context.read<Db>().collection('stories').findOne(['id']);
  return Response.json(body: short.toString());
}

Future<Response> _getStories(RequestContext context) async {
  final short = await context.read<Db>().collection('stories').find().toList();
  return Response.json(body: short);
}

Future<Response> _createStories(RequestContext context) async {
  final storiesJson = await context.request.json() as Map<String, dynamic>;
  //can manipulate the data
  final res =
      await context.read<Db>().collection('stories').insertOne(storiesJson);

  return Response.json(body: {'id': res.id});
}
