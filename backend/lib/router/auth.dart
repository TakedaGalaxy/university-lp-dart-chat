import 'package:backend/database/database.dart';
import 'package:backend/middleware/auth.dart';
import 'package:backend/service/auth.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router routerAuth(DatabaseConnection databaseConnection) {
  final serviceAuth = ServiceAuth(databaseConnection: databaseConnection);

  final routerAuth = Router();

  routerAuth.post("/", (Request request) async {
    final response = serviceAuth.logIn(await request.readAsString());

    if (response.success) return Response.ok(response.toJsonString());

    return Response.internalServerError(body: response.toJsonString());
  });

  routerAuth.delete(
      "/",
      middlewareAuth(databaseConnection)((Request request) async {
        final response = serviceAuth.logOut(request.context);

        if (response.success) return Response.ok(response.toJsonString());

        return Response.internalServerError(body: response.toJsonString());
      }));

  return routerAuth;
}
