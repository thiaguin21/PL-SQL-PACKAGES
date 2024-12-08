-- Pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE PKG_ALUNO IS
    -- Procedure de exclusão de aluno
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER);

    -- Cursor de listagem de alunos maiores de 18 anos
    CURSOR c_alunos_maiores_de_18 IS
        SELECT nome, data_nascimento
        FROM alunos
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;

    -- Cursor com filtro por curso
    CURSOR c_alunos_por_curso(p_id_curso IN NUMBER) IS
        SELECT a.nome
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_curso = p_id_curso;
END PKG_ALUNO;
/

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO IS
    -- Implementação da procedure de exclusão de aluno
    PROCEDURE excluir_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        DELETE FROM matriculas WHERE id_aluno = p_id_aluno;
        DELETE FROM alunos WHERE id_aluno = p_id_aluno;
        COMMIT;
    END excluir_aluno;
END PKG_ALUNO;
/

-- Pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA IS
    -- Procedure para cadastro de disciplina
    PROCEDURE cadastrar_disciplina(
        p_nome IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER
    );

    -- Cursor para total de alunos por disciplina
    CURSOR c_total_alunos_por_disciplina IS
        SELECT d.id_disciplina, d.nome, COUNT(m.id_aluno) AS total_alunos
        FROM disciplinas d
        JOIN matriculas m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.id_disciplina, d.nome
        HAVING COUNT(m.id_aluno) > 10;

    -- Cursor para média de idade por disciplina
    CURSOR c_media_idade_por_disciplina(p_id_disciplina IN NUMBER) IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;

    -- Procedure para listar alunos de uma disciplina
    PROCEDURE listar_alunos_por_disciplina(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA IS
    -- Implementação da procedure para cadastrar disciplina
    PROCEDURE cadastrar_disciplina(
        p_nome IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER
    ) IS
    BEGIN
        INSERT INTO disciplinas (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);

        COMMIT;
    END cadastrar_disciplina;

    -- Implementação da procedure para listar alunos por disciplina
    PROCEDURE listar_alunos_por_disciplina(p_id_disciplina IN NUMBER) IS
    BEGIN
        FOR aluno IN (
            SELECT a.nome
            FROM alunos a
            JOIN matriculas m ON a.id_aluno = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || aluno.nome);
        END LOOP;
    END listar_alunos_por_disciplina;
END PKG_DISCIPLINA;
/

-- Pacote PKG_PROFESSOR

CREATE OR REPLACE PACKAGE PKG_PROFESSOR IS
    -- Cursor para total de turmas por professor
    CURSOR c_total_turmas_por_professor IS
        SELECT p.nome, COUNT(t.id_turma) AS total_turmas
        FROM professores p
        JOIN turmas t ON p.id_professor = t.id_professor
        GROUP BY p.nome
        HAVING COUNT(t.id_turma) > 1;

    -- Função para total de turmas de um professor
    FUNCTION total_turmas_por_professor(p_id_professor IN NUMBER) RETURN NUMBER;

    -- Função para professor de uma disciplina
    FUNCTION professor_por_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR IS
    -- Implementação da function para total de turmas de um professor
    FUNCTION total_turmas_por_professor(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total_turmas NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total_turmas
        FROM turmas
        WHERE id_professor = p_id_professor;

        RETURN v_total_turmas;
    END total_turmas_por_professor;

    -- Implementação da function para professor de uma disciplina
    FUNCTION professor_por_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM professores p
        JOIN disciplinas d ON p.id_professor = d.id_professor
        WHERE d.id_disciplina = p_id_disciplina;

        RETURN v_nome_professor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Professor não encontrado';
    END professor_por_disciplina;
END PKG_PROFESSOR;
/