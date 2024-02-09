import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) {
  //
  final parameters = context.request.uri.queryParameters;

  final id = parameters['id'] ?? '';

  //
  if (id.isNotEmpty) {
    _getOnePost(context);
  }

  return switch (context.request.method) {
    HttpMethod.get => _getPost(context),
    HttpMethod.post => _createPost(context),
    HttpMethod.delete => _deletePost(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getOnePost(RequestContext context) async {
  final short = await context.read<Db>().collection('cart').findOne(['goodId']);
  return Response.json(body: short.toString());
}

Future<Response> _getPost(RequestContext context) async {
  final short = await context.read<Db>().collection('cart').find().toList();
  return Response.json(body: short);
}

Future<Response> _createPost(RequestContext context) async {
  final cartJson = await context.request.json() as Map<String, dynamic>;
  //can manipulate the data
  final res = await context.read<Db>().collection('cart').insertOne(cartJson);

  return Response.json(body: {'id': res.id});
}

Future<Response> _deletePost(RequestContext context, String id) async {
  final cartItem = await context.read<Db>().collection('cart').deleteOne([id]);
  return Response();
}
