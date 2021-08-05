import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasura_flutter/model/employee_model.dart';

import 'change_variables_model.dart';

class EmployeeService {
  String subsEmployeesTxt = '...';

  HasuraConnect hasura = HasuraConnect(
      'https://hasura-flutter-sample.herokuapp.com/v1/graphql',
      headers: {
        'content-type': 'application/json',
        'x-hasura-admin-secret': 'teste',
      });

  Future<List<EmployeeModel>> getEmployeesListQuery() async {
    final query = r'''
          query MyQuery {
            employees {
              id
              name
            }
          }
    ''';

    final Map<String, dynamic> result = await hasura.query(
      query,
      // variables: {"order_by": "asc", "name": "%ar%"},
    );

    final employeesList = (result['data']['employees'] as List)
        .map((employee) => EmployeeModel.fromMap(employee))
        .toList();

    print("FUNCIONARIO ${result.toString()}");

    return employeesList;
  }

  Future<Snapshot<List<EmployeeModel>>> getEmployeesListSubscription() async {
    final subscription = r'''
          subscription MySubscription {
            employees {
              id
              name
            }
          }
    ''';

    // ignore: close_sinks
    final Snapshot<dynamic> result = await hasura.subscription(
      subscription,
    );

    result.listen((data) {
      final foo = (data['data']['employees'] as List)
          .map((employee) => EmployeeModel.fromMap(employee));
      subsEmployeesTxt = foo.first.name;
    }).onError((err) {
      print(err);
    });

    return result.map((event) {
      if (event == null) {
        return <EmployeeModel>[];
      }
      return (event['data']['employees'] as List)
          .map((employee) => EmployeeModel.fromMap(employee))
          .toList();
    });
  }
}
