class QueryMutation {
  // Query for Insert the employee detail
  String addEmployee(String company_id, String name, String designation) {
    return ("""mutation AddEmployee{
                insert_employee(objects: {name: "$name", company_id: "$company_id", designation: "$designation"}) {
                  returning {
                               name
                               company_id
                               designation
             }
                }
                    }""");
  }

  // Query for Update the employee detail
  String editEmployee(String company_id, String name, String designation) {
    return ("""mutation UpdateEmployee{
           update_employee(where: {company_id: {_eq: "$company_id"}}, _set: {name: "$name", designation: "$designation"}) {
              returning {
                          name
                          designation              
                       }
                   }
                }""");
  }

  // Query for Fetch the all employee
  String getAll() {
    return """ 
      {
        employee(order_by: {name: asc}){
          name
          company_id
          designation
        }
      }
    """;
  }

  // Query for delete the employee
  String deleteEmployee(company_id) {
    return ("""mutation DeleteEmployee{       
           delete_employee(where: {company_id: {_eq: "$company_id"}}) {
          returning {
                      company_id
                     }
                       }
                         }""");
  }
}
