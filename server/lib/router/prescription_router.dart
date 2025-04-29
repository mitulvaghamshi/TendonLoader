import 'package:server/controllers/prescription_controller.dart';
import 'package:server/statements/prescription_statements.dart';
import 'package:shelf_router/shelf_router.dart';

extension PrescriptionRouter on PrescriptionStatements {
  Router get prescriptionRouter =>
      Router()
        // curl -X GET http://localhost:8080/prescriptions
        ..get('/', queryHandler)
        // curl -X GET http://localhost:8080/prescriptions/1
        ..get('/<id>', selectHandler)
        // curl -X GET http://localhost:8080/prescriptions/search/term
        ..get('/search/<term>', searchHandler)
        // curl -X POST http://localhost:8080/prescriptions -H 'Content-Type: application/json' -d '{}'
        ..post('/', insertHandler)
        // curl -X PATCH http://localhost:8080/prescriptions/1 -H 'Content-Type: application/json' -d '{}'
        ..patch('/<id>', updateHandler)
        // curl -X DELETE http://localhost:8080/prescriptions/1
        ..delete('/<id>', deleteHandler);
}
