import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

String connectString =
    'mongodb+srv://babyboo:Oluwapelumi@testing.ga2xojt.mongodb.net/?retryWrites=true&w=majority';
Handler middleware(Handler handler) {
  return (context) async {
    final db = await Db.create(connectString);

    if (!db.isConnected) {
      await db.open();
    }

    final response = await handler.use(provider<Db>((_) => db)).call(context);
    await db.close();
    return response;
  };
}
