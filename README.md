
# Scripts de Pacotes SQL - Oracle

Este projeto contém scripts para criação de pacotes no Oracle que implementam funcionalidades relacionadas a alunos, disciplinas, professores e turmas.

---

## Pacotes Disponíveis

### 1. **PKG_ALUNO**
- **Procedure excluir_aluno**: Remove um aluno e todas as suas matrículas com base no ID fornecido.
- **Cursor c_alunos_maiores_de_18**: Lista o nome e a data de nascimento de todos os alunos maiores de 18 anos.
- **Cursor c_alunos_por_curso**: Recebe o ID de um curso e lista os nomes dos alunos matriculados nele.

### 2. **PKG_DISCIPLINA**
- **Procedure cadastrar_disciplina**: Cadastra uma nova disciplina no banco, recebendo nome, descrição e carga horária como parâmetros.
- **Cursor c_total_alunos_por_disciplina**: Lista as disciplinas com mais de 10 alunos matriculados, mostrando o nome e o total de alunos.
- **Cursor c_media_idade_por_disciplina**: Calcula a média de idade dos alunos matriculados em uma disciplina específica.
- **Procedure listar_alunos_por_disciplina**: Exibe os nomes dos alunos matriculados em uma disciplina com base no ID fornecido.

### 3. **PKG_PROFESSOR**
- **Cursor c_total_turmas_por_professor**: Lista o nome dos professores e o total de turmas que cada um leciona, exibindo apenas aqueles responsáveis por mais de uma turma.
- **Function total_turmas_por_professor**: Recebe o ID de um professor como parâmetro e retorna o número de turmas que ele leciona.
- **Function professor_por_disciplina**: Recebe o ID de uma disciplina como parâmetro e retorna o nome do professor responsável.

---

## Como Executar os Scripts

1. **Configuração Prévia**
   - Certifique-se de que as tabelas necessárias estão criadas no banco de dados com os relacionamentos apropriados:
     - **Tabelas necessárias**:
       - `alunos`, `disciplinas`, `matriculas`, `cursos`, `professores` e `turmas`.
     - **Relacionamentos**:
       - `turmas.id_professor` está relacionado a `professores.id_professor`.
       - `disciplinas.id_professor` está relacionado a `professores.id_professor`.

2. **Execução dos Scripts**
   - Use o SQL*Plus, SQL Developer ou outra ferramenta de sua preferência.
   - Carregue os arquivos correspondentes aos pacotes (`pkg_aluno.sql`, `pkg_disciplina.sql`, `pkg_professor.sql`) e execute-os para criar os pacotes e seus corpos.

3. **Uso dos Pacotes**
   - Após a execução, você pode utilizar os cursos, procedures e funções em blocos PL/SQL ou integrá-los ao seu sistema.

---

## Exemplos de Uso

### 1. **Cursor `c_alunos_maiores_de_18` (PKG_ALUNO)**
```sql
BEGIN
    FOR aluno IN PKG_ALUNO.c_alunos_maiores_de_18 LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || aluno.nome || ', Data de Nascimento: ' || aluno.data_nascimento);
    END LOOP;
END;
/
```

### 2. **Procedure `listar_alunos_por_disciplina` (PKG_DISCIPLINA)**
```sql
BEGIN
    PKG_DISCIPLINA.listar_alunos_por_disciplina(101);
END;
/
```

### 3. **Function `total_turmas_por_professor` (PKG_PROFESSOR)**
```sql
DECLARE
    v_total_turmas NUMBER;
BEGIN
    v_total_turmas := PKG_PROFESSOR.total_turmas_por_professor(101);
    DBMS_OUTPUT.PUT_LINE('Total de Turmas: ' || v_total_turmas);
END;
/
```

### 4. **Cursor `c_total_turmas_por_professor` (PKG_PROFESSOR)**
```sql
BEGIN
    FOR professor IN PKG_PROFESSOR.c_total_turmas_por_professor LOOP
        DBMS_OUTPUT.PUT_LINE('Professor: ' || professor.nome || ', Total Turmas: ' || professor.total_turmas);
    END LOOP;
END;
/
```
