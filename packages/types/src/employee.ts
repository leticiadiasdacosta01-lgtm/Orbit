export interface Employee {
  id: string
  registration: string
  name: string
  cpf: string
  email?: string
  phone?: string
  birthDate: string
  status: EmployeeStatus
  role: {
    id: string
    name: string
  }
  department: {
    id: string
    name: string
  }
  salary: number
  contractType: string
  admissionDate: string
  terminationDate?: string
}

export enum EmployeeStatus {
  ACTIVE = 'ACTIVE',
  ON_VACATION = 'ON_VACATION',
  ON_LEAVE = 'ON_LEAVE',
  TERMINATED = 'TERMINATED',
}

export interface CreateEmployeeInput {
  name: string
  cpf: string
  email?: string
  birthDate: string
  roleId: string
  departmentId: string
  salary: number
  contractType: string
  admissionDate: string
}
