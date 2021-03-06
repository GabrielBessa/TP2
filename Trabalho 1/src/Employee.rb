require_relative "Job"
require 'time'

class Employee
	@@curr_id = 0

	def initialize(name:, birth_date:, cpf:, join_date:  Time.now, bonus:  0, formation: [], sector: nil, role: nil)
		# ID is auto incremental field. Not strictly necessary, though.
		@@curr_id += 1
		@id = @@curr_id
		@name = name
		@birth_date = birth_date
		@cpf = cpf 
		@join_date = join_date
		@salary_bonus = bonus.to_i
    @sector = sector
		@role = role
		@formation = formation
	end
	
	def get_salary()
		return @role.get_salary() + @salary_bonus
	end

	def set_bonus( bonus)
		return @salary_bonus = bonus
	end

	def get_age()
		now = Time.now
		age = now.year - @birth_date.year
		# Precise age
		if ((now.month < @birth_date.month) or (now.month == @birth_date.month and now.day < @birth_date.day))
			age -= 1
		end
		return age
	end

	def get_name()
		return @name
	end

	def get_birth_date()
		return @birth_date.strftime("%d/%m/%Y")
	end
	
  	def get_cpf()
		return @cpf
  	end

	def get_join_date()
		return @join_date.strftime("%d/%m/%Y")
	end

	def get_id()
		return @id
	end 

	def get_sector()
		return @sector
  	end
  
	def set_sector(new_sector)
		@sector = new_sector
	end

	# Returns the name of the Job this Employee has
	def get_role()
		if @role == nil
			return nil
		end
		return @role.get_name()
	end

	# Returns a reference to the Job this Employee has
	def get_Job()
		return @role
  end
  
  def get_bonus
    return @salary_bonus
  end

	def set_Job( new_job )
		if !new_job.instance_of? Job
			raise ArgumentError, "Parameter is not of class Job."
		else
			@role = new_job
		end
	end

	def get_formation()
		return @formation
	end

	def add_training( new_training )
		@formation.push( new_training )
	end

	def self.import_Employee(other_employee)
    # Verificação dos argumentos básicos
		raise ArgumentError "Nome informado não é uma string" unless other_employee['nome'].is_a? String
		raise ArgumentError "CPF não é string" unless other_employee['cpf'].is_a? String
		raise ArgumentError "Profissão informada não é string" unless other_employee['profissao'].is_a? String
		raise ArgumentError "Bonus informado não é um número" unless other_employee['vale_transporte'].is_a? Numeric
		# Verificação de argumentos de data
		begin
			data_nascimento = Time.parse(other_employee['data_nascimento'])
		rescue ArgumentError
			raise ArgumentError "Data de nascimento informada não é valida."
		end
		begin
			data_entrada = Time.parse(other_employee['data_entrada'])
		rescue ArgumentError
			raise ArgumentError "Data de entrada informada não é valida."
		end
		# Cria o Employee
		return Employee.new(name: other_employee['nome'], birth_date: data_nascimento, cpf: other_employee['cpf'], join_date: data_entrada, bonus: other_employee['vale_transporte'], formation:[other_employee['profissao']])
  end
  
  def self.export_employee(our_employee)
    # Verifieing basic arguments
    raise ArgumentError "Nome informado não é uma string" unless our_employee.get_name.is_a? String
		raise ArgumentError "CPF não é string" unless our_employee.get_cpf.is_a? String
    raise ArgumentError "Profissão informada não é string" unless our_employee.get_Job.is_a? String
    raise ArgumentError "Bonus informado não é um número" unless our_employee.get_bonus.is_a? Numeric
    # Verifieing data arguments
    begin
			data_nascimento = Time.parse(our_employee.get_birth_date)
    rescue ArgumentError
      raise ArgumentError "Data de nascimento informada nao eh valida."
    end
    begin
      data_entrada = Time.parse(our_employee.get_join_date)
    rescue ArgumentError
      raise ArgumentError "Data de entrada informada nao eh valida."
    end
    # Returning the employee to export
    return our_employee
  end
end


def Employee_sort(employees)
	n = employees.length
	employees.sort! { |a, b|  a.get_age <=> b.get_age }
end

