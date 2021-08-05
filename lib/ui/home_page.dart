import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasura_flutter/model/employee_model.dart';
import 'package:hasura_flutter/service/employees_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = EmployeeService();
  late Future<List<EmployeeModel>> listEmployees;

  @override
  void initState() {
    super.initState();
    listEmployees = service.getEmployeesListQuery();
    service.subsEmployeesTxt =
        service.getEmployeesListSubscription().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funcionários'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: FutureBuilder(
                    future: listEmployees,
                    builder: (_, AsyncSnapshot<List<EmployeeModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        final employee = snapshot.data;
                        return ListView.builder(
                            itemCount: employee!.length,
                            itemBuilder: (ctx, index) {
                              return Text('${employee[index].name}');
                            });
                      }
                    }),
              ),
              Expanded(flex: 1, child: Text('${service.subsEmployeesTxt}')),
              // Expanded(
              //   child: ,),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.assignment_ind_outlined),
        onPressed: () => service.getEmployeesListQuery(),
      ),
    );
  }
}
