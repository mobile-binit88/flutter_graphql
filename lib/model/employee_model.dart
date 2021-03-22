class Employee {
  Employee(this.company_id, this.name, this.designation);

  final String company_id;
  final String name;
  final String designation;

  getCompanyId() => this.company_id;

  getName() => this.name;

  getDesignation() => this.designation;
}
