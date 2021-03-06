require 'test/unit'
require 'time'
# Nosso sistema
require_relative '../Trabalho 1/src/Employee.rb'
require_relative '../Trabalho 1/src/Sector.rb'
require_relative '../Trabalho 1/src/Job.rb'
# Sistema dos colegas
require_relative '../Trabalho Colegas/src/classes/Empregado.rb'

def lookup_Sector(sector, name)
    for s in sector.each 
        if s.get_sector_name() == name
            return s
        end
    end
    return nil
end

def lookup_Job(jobs, name)
    for j in jobs.each
        if j.get_name() == name
            return j
        end
    end
    return nil
end

class SystemsIntegrationTest < Test::Unit::TestCase

    def setup
        # Setores são iguais para ambos os sistemas
        @setores = [
            Sector.new('financas', ['administrador', 'contador', 'economista']),
            Sector.new('marketing', ['comunicador', 'administrador', 'mercadologo']),
            Sector.new('tecnologia', ['engenheiro_de_computacao', 'engenheiro_de_sistemas', 'engenheiro_de_informacao']),
            Sector.new('normatividade', ['advogado', 'comunicador', 'contador']),
            Sector.new('design', ['designer_grafico', 'designer_multimedia', 'engenheiro_social'])
        ]
        # Cargos são iguais para ambos os sistemas
        @cargos = [
            Job.new('auxiliar', 1500),
            Job.new('tecnico', 3000),
            Job.new('profissional', 6500),
            Job.new('diretor_setor', 9500),
            Job.new('diretor_operacoes', 13000),
            Job.new('diretor_executivo', 18000)
        ]
        # Cria um empregado no sistema dos colegas
        @empregado = Empregado.new
        @empregado.novoEmpregado('Kléber', 29, '10/11/1989', '012593556-24', 'auxiliar', '01/02/2016', 'designer_grafico')
        # Cria um empregado em nosso sistema
        @employee = Employee.new(name: 'Jose', birth_date: Time.parse('25/03/1997'), cpf: '111.111.111-00', join_date: Time.parse('10/02/2005'), bonus: 350.00 ,sector: @setores[0].get_sector_name, role: @cargos[0].get_name)

    end

    def test_import
        # Importa o empregado do outro sistema para o nosso
        new_employee = Employee.import_Employee(@empregado.getInfo())
        # cargo e setor vem separados por conta de diferenças nos sistemas
        job_name = @empregado.getInfo()['cargo']
        setor_name = @empregado.getInfo()['setor']
        # Encontra os objetos Cargo e Setor apropriados
        job = lookup_Job(@cargos, job_name)
        sector = lookup_Sector(@setores, setor_name)
        # Tenta adicionar informações
        new_employee.set_Job(job) if job != nil
        sector.add_employee(new_employee) if sector != nil

        # Verifica se importou corretamente   
        assert(new_employee.instance_of?(Employee))
        assert_equal('Kléber', new_employee.get_name())
        assert_equal('10/11/1989', new_employee.get_birth_date())
        assert_equal(@empregado.getInfo()['cargo'], new_employee.get_role())
    end

    def test_export
      # Exportando o empregado
      export_employee = Employee.export_employee(@employee)

      # Importando os valores pertinentes para o outro arquivo
      @exported_employee = Empregado.new
      @exported_employee.getInfo['nome'] = export_employee.get_name
      @exported_employee.getInfo['idade'] = export_employee.get_age
      @exported_employee.getInfo['data_nascimento'] = export_employee.get_birth_date
      @exported_employee.getInfo['cpf'] = export_employee.get_cpf
      @exported_employee.getInfo['cargo'] = export_employee.get_Job
      @exported_employee.getInfo['data_entrada'] = export_employee.get_join_date
      # Acho que isso pode ser considerado uma gambiarra, corrigir isso aqui depois
      @exported_employee.getInfo['profissao'] = @setores[0].get_allowed_professions[0]
      
      # Verificando se exportou corretamente
      assert(@exported_employee.instance_of?(Empregado))
      assert_equal('Jose', @exported_employee.getInfo['nome'])
      assert_equal(21, @exported_employee.getInfo['idade'])
      assert_equal('25/03/1997', @exported_employee.getInfo['data_nascimento'])
      assert_equal('111.111.111-00', @exported_employee.getInfo['cpf'])
      assert_equal('auxiliar', @exported_employee.getInfo['cargo'])
      assert_equal('10/02/2005', @exported_employee.getInfo['data_entrada'])
      assert_equal('administrador', @exported_employee.getInfo['profissao'])
    end
end