// Máscaras para inputs brasileiros

export const masks = {
  cpf: '999.999.999-99',
  cnpj: '99.999.999/9999-99',
  phone: '(99) 99999-9999',
  cep: '99999-999',
  date: '99/99/9999',
  rg: '99.999.999-9',
}

// Remove formatação de strings
export function removeMask(value: string): string {
  return value.replace(/\D/g, '')
}

// Aplica máscara de CPF
export function applyCpfMask(value: string): string {
  const numbers = removeMask(value)
  return numbers
    .replace(/(\d{3})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d{1,2})$/, '$1-$2')
}

// Aplica máscara de CNPJ
export function applyCnpjMask(value: string): string {
  const numbers = removeMask(value)
  return numbers
    .replace(/(\d{2})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d)/, '$1.$2')
    .replace(/(\d{3})(\d)/, '$1/$2')
    .replace(/(\d{4})(\d{1,2})$/, '$1-$2')
}

// Aplica máscara de telefone
export function applyPhoneMask(value: string): string {
  const numbers = removeMask(value)
  if (numbers.length <= 10) {
    // Formato: (99) 9999-9999
    return numbers
      .replace(/(\d{2})(\d)/, '($1) $2')
      .replace(/(\d{4})(\d)/, '$1-$2')
  } else {
    // Formato: (99) 99999-9999
    return numbers
      .replace(/(\d{2})(\d)/, '($1) $2')
      .replace(/(\d{5})(\d)/, '$1-$2')
  }
}

// Aplica máscara de CEP
export function applyCepMask(value: string): string {
  const numbers = removeMask(value)
  return numbers.replace(/(\d{5})(\d)/, '$1-$2')
}

// Aplica máscara de data (DD/MM/YYYY)
export function applyDateMask(value: string): string {
  const numbers = removeMask(value)
  return numbers
    .replace(/(\d{2})(\d)/, '$1/$2')
    .replace(/(\d{2})(\d)/, '$1/$2')
    .replace(/(\d{4}).*/, '$1')
}

// Aplica máscara de moeda (R$)
export function applyCurrencyMask(value: string): string {
  const numbers = removeMask(value)
  const amount = parseFloat(numbers) / 100
  return amount.toLocaleString('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  })
}

// Valida CPF
export function isValidCpf(cpf: string): boolean {
  const numbers = removeMask(cpf)

  if (numbers.length !== 11) return false
  if (/^(\d)\1{10}$/.test(numbers)) return false // Todos dígitos iguais

  // Validação dos dígitos verificadores
  let sum = 0
  let remainder

  for (let i = 1; i <= 9; i++) {
    sum += parseInt(numbers.substring(i - 1, i)) * (11 - i)
  }

  remainder = (sum * 10) % 11
  if (remainder === 10 || remainder === 11) remainder = 0
  if (remainder !== parseInt(numbers.substring(9, 10))) return false

  sum = 0
  for (let i = 1; i <= 10; i++) {
    sum += parseInt(numbers.substring(i - 1, i)) * (12 - i)
  }

  remainder = (sum * 10) % 11
  if (remainder === 10 || remainder === 11) remainder = 0
  if (remainder !== parseInt(numbers.substring(10, 11))) return false

  return true
}

// Valida CNPJ
export function isValidCnpj(cnpj: string): boolean {
  const numbers = removeMask(cnpj)

  if (numbers.length !== 14) return false
  if (/^(\d)\1{13}$/.test(numbers)) return false // Todos dígitos iguais

  // Validação dos dígitos verificadores
  let length = numbers.length - 2
  let digits = numbers.substring(0, length)
  const check = numbers.substring(length)
  let sum = 0
  let pos = length - 7

  for (let i = length; i >= 1; i--) {
    sum += parseInt(digits.charAt(length - i)) * pos--
    if (pos < 2) pos = 9
  }

  let result = sum % 11 < 2 ? 0 : 11 - (sum % 11)
  if (result !== parseInt(check.charAt(0))) return false

  length = length + 1
  digits = numbers.substring(0, length)
  sum = 0
  pos = length - 7

  for (let i = length; i >= 1; i--) {
    sum += parseInt(digits.charAt(length - i)) * pos--
    if (pos < 2) pos = 9
  }

  result = sum % 11 < 2 ? 0 : 11 - (sum % 11)
  if (result !== parseInt(check.charAt(1))) return false

  return true
}

// Valida CEP
export function isValidCep(cep: string): boolean {
  const numbers = removeMask(cep)
  return numbers.length === 8 && /^\d{8}$/.test(numbers)
}

// Formata nome (primeira letra maiúscula)
export function formatName(name: string): string {
  return name
    .toLowerCase()
    .split(' ')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ')
}
