
/*##############################################################################################################################################*/
INSERT INTO "BSCBD"."FUNCIONARIOS" (ID_FUNCIONARIO, NOME_FUNCIONARIO, DATA_NASCIMENTO, TELEMOVEL, GERENTE, MORADA, AGENCIA) VALUES ('1', 'RUI', TO_DATE('2015-10-15 13:44:26', 'YYYY-MM-DD HH24:MI:SS'), '123456789', '1' ,MORADA(1,1,1,'faro'), '1');
INSERT INTO "BSCBD"."AGENCIAS" (ID_AGENCIA, MORADA) VALUES (1, MORADA(1,1,1,'faro'));
INSERT INTO "BSCBD"."CLIENTES" (ID_CLIENTE, NIF, NOME, DATA_NASCIMENTO, TELEFONE, MORADA, PROFISSAO, AGENCIA) VALUES ('1', '123', 'TOMAS', TO_DATE('2008-10-15 13:56:25', , 'YYYY-MM-DD HH24:MI:SS'), '123456789', MORADA(1,1,1,'Faro'), 'developer', '1');
INSERT INTO "BSCBD"."CLIENTES" (ID_CLIENTE, NIF, NOME, DATA_NASCIMENTO, TELEFONE, MORADA, PROFISSAO, AGENCIA) VALUES ('2', '345', 'bernardo', TO_DATE('2008-10-15 13:56:25', 'YYYY-MM-DD HH24:MI:SS'), '123456789', MORADA(1,1,1,'Faro'), 'developer', '1');
/*##############################################################################################################################################*/


/*################  GRANT PRIVILEGES  ################*/
GRANT CREATE MATERIALIZED VIEW TO BSCBD;
GRANT SELECT ON view_name TO BSCBD;
GRANT UNLIMITED TABLESPACE TO user_name;



/*################  CREATE TABLESPACES  ################*/

CREATE TABLESPACE logs
    DATAFILE 'data_logs.dbf'
    SIZE 500m REUSE AUTOEXTEND ON NEXT 20M;

CREATE TABLESPACE c_moradas
    DATAFILE 'data_moradas'
    SIZE 1000m;

CREATE TABLESPACE i_funcionarios
    DATAFILE 'data_funcionarios'
    SIZE 400m REUSE AUTOEXTEND ON NEXT 20M; 
    
CREATE TABLESPACE i_clientes
    DATAFILE 'data_clientes'
    SIZE 1000m REUSE AUTOEXTEND ON NEXT 50M; 
    
CREATE TABLESPACE i_contas
    DATAFILE 'data_contas'
    SIZE 1200m REUSE AUTOEXTEND ON NEXT 50M;

CREATE TABLESPACE i_cartoes
    DATAFILE 'data_cartoes'
    SIZE 700m REUSE AUTOEXTEND ON NEXT 40M; 

CREATE TABLESPACE i_movimentos
    DATAFILE 'data_movimentos'
    SIZE 3000m REUSE AUTOEXTEND ON NEXT 100M;


/*################  CREATE TYPE MORADAS  ################*/

CREATE TYPE MORADA AS OBJECT (
    distrito NUMBER,
    concelho NUMBER, 
    codPostal NUMBER,
    detalhes VARCHAR(250)
);


/*################  CREATE SEQUENCE  ################*/
/*################  AUTO INCREMENTO  ################*/

/*PRODUTOS*/
CREATE SEQUENCE produtos_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER produtos_trigger
BEFORE INSERT ON produtos
FOR EACH ROW
BEGIN
  SELECT produtos_seq.NEXTVAL
  INTO :new.id_produto
  FROM dual;
END;
\


/*AGENCIAS*/
CREATE SEQUENCE agencias_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER agencias_trigger
BEFORE INSERT ON agencias
FOR EACH ROW
BEGIN
  SELECT agencias_seq.NEXTVAL
  INTO :new.id_agencia
  FROM dual;
END;
\


/*TIPO_MOVIMENTOS*/
CREATE SEQUENCE tipoMovimentos_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER tipoMovimentos_trigger
BEFORE INSERT ON tipoMovimentos
FOR EACH ROW
BEGIN
  SELECT tipoMovimentos_seq.NEXTVAL
  INTO :new.id_movimento
  FROM dual;
END;
\


/*FUNCIONARIOS*/
CREATE SEQUENCE funcionarios_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER funcionarios_trigger
BEFORE INSERT ON funcionarios
FOR EACH ROW
BEGIN
  SELECT funcionarios_seq.NEXTVAL
  INTO :new.id_funcionario
  FROM dual;
END;
\


/*CLIENTES*/
CREATE SEQUENCE clientes_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER clientes_trigger
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
  SELECT clientes_seq.NEXTVAL
  INTO :new.id_cliente
  FROM dual;
END;
\


/*LOGINS*/
CREATE SEQUENCE logins_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER logins_trigger
BEFORE INSERT ON logins
FOR EACH ROW
BEGIN
  SELECT logins_seq.NEXTVAL
  INTO :new.nif
  FROM dual;
END;
\


/*MOVIMENTOS*/
CREATE SEQUENCE movimentos_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER movimentos_trigger
BEFORE INSERT ON movimentos
FOR EACH ROW
BEGIN
  SELECT movimentos_seq.NEXTVAL
  INTO :new.id_movimento
  FROM dual;
END;
\


/*REGISTOS*/
CREATE SEQUENCE registos_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


CREATE OR REPLACE TRIGGER registos_trigger
BEFORE INSERT ON registos
FOR EACH ROW
BEGIN
  SELECT registos_seq.NEXTVAL
  INTO :new.id_registos
  FROM dual;
END;
\



/*################  CREATE TABLES  ################*/

CREATE TABLE produtos (
    id_produto NUMBER PRIMARY KEY,
    descricao VARCHAR(50)
);

CREATE TABLE tipoMovimentos (
    id_movimento NUMBER PRIMARY KEY,
    descricao VARCHAR(50)
);

CREATE TABLE funcionarios (
    id_funcionario NUMBER PRIMARY KEY,
    nome_funcionario VARCHAR(50) NOT NULL,
    data_nascimento DATE NOT NULL,
    telemovel NUMBER NOT NULL,
    gerente NUMBER NOT NULL,
    morada MORADA NOT NULL,
    agencia NUMBER NOT NULL,
    CONSTRAINT FK_AGENCIA FOREIGN KEY (agencia)
    REFERENCES agencias(id_agencia)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_funcionarios;

CREATE TABLE agencias (
    id_agencia NUMBER PRIMARY KEY,
    morada MORADA NOT NULL
);

CREATE TABLE clientes (
    id_cliente NUMBER,
    nif NUMBER PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone NUMBER NOT NULL,
    morada MORADA NOT NULL,
    profissao VARCHAR(50),
    agencia NUMBER NOT NULL,
    CONSTRAINT FK_AGENCIAID FOREIGN KEY (agencia)
    REFERENCES agencias(id_agencia)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_clientes;

CREATE TABLE logins (
    nif NUMBER PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    CONSTRAINT FK_NIF FOREIGN KEY (nif)
    REFERENCES clientes(nif)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_clientes;

CREATE TABLE contas (
    iban NUMBER PRIMARY KEY,
    saldo DECIMAL(8, 2),
    data_criacao DATE NOT NULL,
    tipo_produto NUMBER NOT NULL,
    CONSTRAINT FK_PRODUTO FOREIGN KEY (tipo_produto)
    REFERENCES produtos(id_produto)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_contas;

CREATE TABLE titulares (
    iban NUMBER,
    nif_cliente NUMBER,
    tipo_titular NUMBER,
    CONSTRAINT FK_IBAN FOREIGN KEY (iban)
    REFERENCES contas(iban)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_contas;

CREATE TABLE cartoes (
    numero_cartao NUMBER PRIMARY KEY,
    data_validade DATE NOT NULL,
    ccv NUMBER(3) NOT NULL,
    pin NUMBER(4) NOT NULL,
    plafond NUMBER,
    tipo_cartao VARCHAR(20) NOT NULL,
    iban NUMBER NOT NULL,
    proprietario NUMBER NOT NULL,
    CONSTRAINT FK_IBANC FOREIGN KEY (iban)
    REFERENCES contas(iban)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
) TABLESPACE i_cartoes;

CREATE TABLE movimentos (
    id_movimento NUMBER PRIMARY KEY,
    tipo_movimento NUMBER NOT NULL,
    montante DECIMAL(8, 2) NOT NULL,
    data_movimento DATE NOT NULL,
    numero_cartao NUMBER,
    titular NUMBER,
    contaOrigem NUMBER,
    contaDestino NUMBER,
    CONSTRAINT FK_CARTAO FOREIGN KEY (numero_cartao)
    REFERENCES cartoes(numero_cartao)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
    CONSTRAINT FK_TITULAR FOREIGN KEY (titular)
    REFERENCES clientes(nif)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
    CONSTRAINT FK_contaOrigem FOREIGN KEY (contaOrigem)
    REFERENCES contas(iban)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
    CONSTRAINT FK_contaDestino FOREIGN KEY (contaDestino)
    REFERENCES contas(iban)
    ON DELETE CASCADE -- Adicionado ON DELETE CASCADE
    CONSTRAINT FK_TIPOMOVIMENTO FOREIGN KEY (tipo_movimento)
    REFERENCES tipoMovimentos(id_movimento)
) TABLESPACE i_movimentos;


 
CREATE TABLE logs(
    id_registos NUMBER PRIMARY KEY,
    dataRegistos DATE,
    descricaoRegistos VARCHAR(200)
)TABLESPACE logs;



/*################  External Tables  ################*/

CREATE OR REPLACE DIRECTORY data_dir AS '/home/oracle/Desktop/ExternalFiles';

-- External Table para codPostal.txt
CREATE TABLE codpostal_external (
    codPostal CHAR(10),
    nomeFreguesia CHAR(50),
    concelhoCodigo CHAR(10),
    distritoCodigo CHAR(10)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('codPostal.txt')
)
REJECT LIMIT UNLIMITED;

-- External Table para concelhos.txt
CREATE TABLE concelhos_external (
    id_codigoConcelho CHAR(10),
    nomeConcelho CHAR(50),
    distritoCodigo CHAR(10)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('concelhos.txt')
)
REJECT LIMIT UNLIMITED;

-- External Table para distritos.txt
CREATE TABLE distritos_external (
    id_codigoDistrito CHAR(10),
    nomeDistrito CHAR(50)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('distritos.txt')
)
REJECT LIMIT UNLIMITED;



/*################  FUNCTIONS  ################*/

--FUNCAO PARA GERAR UMA MORADA ALEATORIA
create or replace FUNCTION obter_morada_aleatoria
RETURN MORADA IS
   v_distrito_cod codpostal_external.cod_distrito%TYPE;
   v_concelho_cod codpostal_external.cod_concelho%TYPE;
   v_cod_postal codpostal_external.cod_postal%TYPE;
   v_nome_freguesia codpostal_external.nome_freguesia%TYPE;
   v_morada MORADA; -- Modifique para o tipo MORADA
BEGIN
   -- Selecionar aleatoriamente valores da tabela
   SELECT cod_distrito, cod_concelho, cod_postal, nome_freguesia
   INTO v_distrito_cod, v_concelho_cod, v_cod_postal, v_nome_freguesia
   FROM (
       SELECT cod_distrito, cod_concelho, cod_postal, nome_freguesia
       FROM codpostal_external
       ORDER BY DBMS_RANDOM.VALUE
   )
   WHERE ROWNUM = 1;

   -- Preencher a instância do tipo "MORADA" com os valores selecionados
   v_morada := MORADA(v_distrito_cod, v_concelho_cod, v_cod_postal, v_nome_freguesia);

   -- Retornar a morada criada
   RETURN v_morada;
END;
\

--FUNCAO PARA INSERIR LOGS DE ERROS NA TABELA LOGS
create or replace FUNCTION inserir_log(p_descricaoRegistos VARCHAR2) RETURN NUMBER IS
BEGIN
    -- Tentativa de inserir um registro na tabela de logs
    INSERT INTO registos (dataRegistos, descricaoRegistos)
    VALUES (SYSDATE, p_descricaoRegistos);
    
    RETURN 1;
END registrar_erro;
\



/*################  PROCEDURES GENERICOS  ################*/

--PROCEDURE INSERT
create or replace PROCEDURE SP_INSERIR ( 

    p_nome_tabela IN VARCHAR2, 

    p_colunas IN VARCHAR2, 

    p_valores IN VARCHAR2 

) AS 

    v_sql VARCHAR2(1000); 

    v_cursor INTEGER; 

BEGIN 

    v_sql := 'INSERT INTO ' || p_nome_tabela || ' (' || p_colunas || ') VALUES (' || p_valores || ')'; 


    DBMS_OUTPUT.PUT_LINE(v_sql);
    
    
    EXECUTE IMMEDIATE v_sql;



    COMMIT; 

EXCEPTION 

    WHEN OTHERS THEN 

        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM); 

        ROLLBACK; 

END SP_INSERIR; 
\

--PROCEDURE UPDATE
create or replace PROCEDURE SP_ATUALIZAR ( 

    p_nome_tabela IN VARCHAR2, 

    p_set_clause IN VARCHAR2, 

    p_condicao IN VARCHAR2 

) AS 

    v_sql VARCHAR2(1000); 

    v_cursor INTEGER; 

BEGIN 

    v_sql := 'UPDATE ' || p_nome_tabela || ' SET ' || p_set_clause || ' WHERE ' || p_condicao; 



    v_cursor := DBMS_SQL.OPEN_CURSOR; 

    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE); 

    DBMS_SQL.CLOSE_CURSOR(v_cursor); 



    COMMIT; 

EXCEPTION 

    WHEN OTHERS THEN 

        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM); 

        ROLLBACK; 

END SP_ATUALIZAR;
\

--PROCEDURE DELETE
create or replace PROCEDURE SP_ELIMINAR ( 

    p_nome_tabela IN VARCHAR2, 

    p_condicao IN VARCHAR2 

) AS 

    v_sql VARCHAR2(1000); 

    v_cursor INTEGER; 

BEGIN 

    v_sql := 'DELETE FROM ' || p_nome_tabela || ' WHERE ' || p_condicao; 



    v_cursor := DBMS_SQL.OPEN_CURSOR; 

    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE); 

    DBMS_SQL.CLOSE_CURSOR(v_cursor); 



    COMMIT; 

EXCEPTION 

    WHEN OTHERS THEN 

        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM); 

        ROLLBACK; 

END SP_ELIMINAR;
\



/*################  PROCEDURES CLIENTES  ################*/

--PROCEDURE PARA INSERIR CLIENTES
create or replace PROCEDURE SP_CLIENTES_INSERIR ( 

    p_nif IN NUMBER, 

    p_nome IN VARCHAR2, 

    p_data_nascimento IN DATE, 

    p_telefone IN NUMBER, 

    p_morada in MORADA,

    p_profissao IN VARCHAR2, 

    p_agencia IN NUMBER

) AS 
    p_campos VARCHAR2(1000);
    p_valores VARCHAR2(1000);
    v_morada VARCHAR2(1000);
BEGIN 
    v_morada := 'MORADA(' || p_morada.distrito || ',' || p_morada.concelho || ',' || p_morada.codpostal || ',''' || p_morada.detalhes || ''')';
    
    p_campos := 'NIF, NOME, DATA_NASCIMENTO, TELEFONE, MORADA, PROFISSAO, AGENCIA';
    p_valores := ''|| p_nif || ',''' || p_nome || ''',TO_DATE(''' || p_data_nascimento || '''),' || p_telefone || ',' || v_morada || ',''' || p_profissao || ''',' || p_agencia;
    
    begin
    SP_INSERE_REGISTRO('CLIENTES',p_campos,p_valores);
    END;
    COMMIT; 

END SP_CLIENTES_INSERIR;
\

--PROCEDURE PARA UPDATE CLIENTES
create or replace PROCEDURE SP_CLIENTES_ATUALIZAR ( 

    p_nif IN NUMBER, 

    p_novo_nome IN VARCHAR2, 

    p_nova_data_nascimento IN DATE, 

    p_novo_telefone IN NUMBER, 

    p_morada IN MORADA, 

    p_nova_profissao IN VARCHAR2, 

    p_nova_agencia IN NUMBER 

) AS 

BEGIN 

    UPDATE CLIENTES 

    SET NOME = p_novo_nome, 

        DATA_NASCIMENTO = p_nova_data_nascimento, 

        TELEFONE = p_novo_telefone, 

        MORADA = p_morada, 

        PROFISSAO = p_nova_profissao, 

        AGENCIA = p_nova_agencia 

    WHERE NIF = p_nif; 



    COMMIT; 

END SP_CLIENTES_ATUALIZAR;
\

--PROCEDURE PARA DELETE CLIENTES
create or replace PROCEDURE SP_CLIENTES_ELIMINAR ( 

    p_nif IN NUMBER 

) AS 

BEGIN 

    DELETE FROM CLIENTES 

    WHERE NIF = p_nif; 



    COMMIT; 

END SP_CLIENTES_ELIMINAR;
\



/*################  PROCEDURES FUNCIONARIOS  ################*/

--PROCEDURE PARA INSERIR FUNCIONARIO
create or replace PROCEDURE SP_FUNCIONARIO_INSERIR (

    p_id_funcionario IN NUMBER,
    p_nome_funcionario IN VARCHAR2,
    p_data_nascimento IN DATE,
    p_telemovel IN NUMBER,
    p_gerente IN NUMBER,
    p_morada in MORADA,
    p_agencia IN NUMBER

) AS

    p_campos VARCHAR2(1000);
    p_valores VARCHAR2(1000);
    v_morada VARCHAR2(1000);

BEGIN

    v_morada := 'MORADA(' || p_morada.distrito || ',' || p_morada.concelho || ',' || p_morada.codpostal || ',''' || p_morada.detalhes || ''')';
    p_campos := 'ID_FUNCIONARIO, NOME, DATA_NASCIMENTO, TELEFONE, GERENTE, MORADA, AGENCIA';

    p_valores := ''|| p_id_funcionario || ',''' || p_nome_funcionario || ''',TO_DATE(''' || p_data_nascimento || '''),' || p_telemovel || ',' || p_gerente || ',' || v_morada || ',' || p_agencia;

    begin

    SP_INSERE_REGISTRO('FUNCIONARIO',p_campos,p_valores);

    END;

    COMMIT;

END SP_FUNCIONARIO_INSERIR;


--PROCEDURE PARA UPDATE FUNCIONARIOS
CREATE OR REPLACE PROCEDURE SP_FUNCIONARIO_ATUALIZAR (

    p_id_funcionario IN NUMBER,
    p_novo_nome_ IN VARCHAR2,
    p_nova_data_nascimento IN DATE,
    p_novo_telemovel IN NUMBER,
    p_novo_gerente IN NUMBER,
    p_morada IN MORADA,  
    p_nova_agencia IN NUMBER

) AS

BEGIN

    UPDATE funcionarios

    SET nome_funcionario = p_novo_nome_,  
        data_nascimento = p_nova_data_nascimento,
        telemovel = p_novo_telemovel,
        morada = p_morada,
        gerente = p_novo_gerente,
        agencia = p_nova_agencia

    WHERE id_funcionario = p_id_funcionario;

    COMMIT;

END SP_FUNCIONARIO_ATUALIZAR;


--PROCEDURE PARA DELETE FUNCIONARIOS
create or replace PROCEDURE SP_FUNCIONARIO_ELIMINAR (

    p_id_funcionario IN NUMBER
    
) AS

BEGIN

    DELETE FROM FUNCIONARIOS WHERE id_funcionario = p_id_funcionario;
    COMMIT;

END SP_FUNCIONARIO_ELIMINAR;



/*################  PROCEDURES AGENCIAS  ################*/

--PROCEDURE PARA INSERIR AGENCIA
create or replace PROCEDURE SP_AGENCIA_INSERIR (

    p_id_agencia IN NUMBER,
    p_morada in MORADA

) AS

    p_campos VARCHAR2(1000);
    p_valores VARCHAR2(1000);
    v_morada VARCHAR2(1000);

BEGIN

    v_morada := 'MORADA(' || p_morada.distrito || ',' || p_morada.concelho || ',' || p_morada.codpostal || ',''' || p_morada.detalhes || ''')';
    p_campos := 'ID_AGENCIA, MORADA';

    p_valores := ''|| p_id_agencia || ',' || v_morada || '';

    begin

    SP_INSERE_REGISTRO('AGENCIA',p_campos,p_valores);

    END;
    COMMIT;

END SP_AGENCIA_INSERIR;


--PROCEDURE PARA UPDATE AGENCIA
CREATE OR REPLACE PROCEDURE SP_AGENCIA_ATUALIZAR (

    p_id_agencia IN NUMBER,
    p_morada IN MORADA  

) AS

    p_campos VARCHAR2(1000);
    p_valores VARCHAR2(1000);
    v_morada VARCHAR2(1000);

BEGIN

    v_morada := 'MORADA(' || p_morada.distrito || ',' || p_morada.concelho || ',' || p_morada.codpostal || ',''' || p_morada.detalhes || ''')';

    UPDATE agencias SET morada = p_morada WHERE id_agencia = p_id_agencia;

    COMMIT;

END SP_AGENCIA_ATUALIZAR;


--PROCEDURE PARA DELETE AGENCIA
CREATE OR REPLACE PROCEDURE SP_AGENCIA_EXCLUIR (

    p_id_agencia IN NUMBER

) AS

BEGIN

    DELETE FROM agencias WHERE id_agencia = p_id_agencia;

    COMMIT;

END SP_AGENCIA_EXCLUIR;



/*################  PROCEDURES TITULARES  ################*/


--PROCEDURE PARA INSERIR TITULARES
CREATE OR REPLACE PROCEDURE SP_TITULARES_INSERIR (

    p_iban NUMBER,
    p_nif_cliente NUMBER,
    p_tipo_titular NUMBER

) AS

    p_campos VARCHAR2(1000);  
    p_valores VARCHAR2(1000);  

BEGIN

    p_campos := 'iban, nif_cliente, tipo_titular';
    p_valores := p_iban || ', ' || p_nif_cliente || ', ' || p_tipo_titular;

    BEGIN
        SP_INSERE_REGISTRO('TITULARES', p_campos, p_valores);
    END;

    COMMIT;

END SP_TITULARES_INSERIR;


--PROCEDURE PARA UPDATE TITULARES
create or replace PROCEDURE SP_TULARES_ATUALIZAR (

    p_iban NUMBER,
    p_nif_cliente NUMBER,
    p_tipo_titular NUMBER

) AS

BEGIN

    UPDATE TITULARES SET IBAN = p_iban, TIPO_TITULAR = p_tipo_titular WHERE nif_cliente = p_nif_cliente;
    COMMIT;

END SP_TULARES_ATUALIZAR;


--PROCEDURE PARA DELETE TITULARES
create or replace PROCEDURE SP_TITULARES_ELIMINAR (

    p_nif_cliente NUMBER

) AS

BEGIN

    DELETE FROM TITULARES WHERE nif_cliente = p_nif_cliente;
    COMMIT;

END SP_TITULARES_ELIMINAR;



/*################  MATERIALIZED VIEWS  ################*/

CREATE MATERIALIZED VIEW distritos_materialized
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT *
FROM DISTRITOS_EXTERNAL;

-- Atualize manualmente a exibição materializada
BEGIN
  DBMS_MVIEW.REFRESH('distritos_materialized');
END;
\


CREATE MATERIALIZED VIEW codpostal_materialized
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT *
FROM codpostal_external;

-- Atualize manualmente a exibição materializada
BEGIN
  DBMS_MVIEW.REFRESH('codpostal_materialized');
END;
\



/*################  VIEWS  ################*/

CREATE VIEW vw_clientes AS

SELECT

    v.id_cliente,
    v.nif,
    v.nome,
    v.data_nascimento,
    v.telefone,
    v.morada,
    v.profissao,
    v.agencia,
    a.id_agencia,
    a.morada AS agencia_morada

FROM clientes v

JOIN agencias a ON v.agencia = a.id_agencia;



CREATE VIEW vw_cartoes AS

SELECT

    ca.numero_cartao,
    ca.data_validade,
    ca.ccv,
    ca.pin,
    ca.plafond,
    ca.tipo_cartao,
    ca.iban,
    ca.proprietario,
    c.nome AS nome_proprietario,
    c.nif AS nif_proprietario

FROM cartoes ca

JOIN clientes c ON ca.proprietario = c.nif;

 

CREATE VIEW vw_movimentos AS

SELECT

    m.id_movimento,
    m.tipo_movimento,
    m.montante,
    m.data_movimento,
    m.numero_cartao,
    m.titular,
    m.contaOrigem,
    m.contaDestino,
    tm.descricao AS tipo_movimento_descricao

FROM movimentos m

JOIN tipoMovimentos tm ON m.tipo_movimento = tm.id_movimento;

 

CREATE VIEW vw_contas AS

SELECT

    co.iban,
    co.saldo,
    co.data_criacao,
    co.tipo_produto,
    t.tipo_titular,
    c.nome AS nome_titular

FROM contas co

JOIN titulares t ON co.iban = t.iban

JOIN clientes c ON t.nif_cliente = c.nif;



/*################  INSERTS  ################*/

BEGIN
  INSERT /*+ APPEND */ INTO produtos (id_produto, descricao) VALUES (1, 'CONTA ORDEM');
  INSERT /*+ APPEND */ INTO produtos (id_produto, descricao) VALUES (2, 'CONTA PRAZO');
  INSERT /*+ APPEND */ INTO produtos (id_produto, descricao) VALUES (3, 'CONTA POUPANCA');
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO tipoMovimentos (descricao) VALUES ('TRANSFERENCIA');
  INSERT /*+ APPEND */ INTO tipoMovimentos (descricao) VALUES ('DEPOSITO');
  INSERT /*+ APPEND */ INTO tipoMovimentos (descricao) VALUES ('LEVANTAMENTO');
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO funcionarios (nome_funcionario, data_nascimento, telemovel, gerente, morada, agencia) VALUES ('Funcionário A', TO_DATE('1990-01-01', 'YYYY-MM-DD'), obter_morada_aleatoria(), 1, 'Endereço A', 1);
  INSERT /*+ APPEND */ INTO funcionarios (nome_funcionario, data_nascimento, telemovel, gerente, morada, agencia) VALUES ('Funcionário B', TO_DATE('1990-02-02', 'YYYY-MM-DD'), obter_morada_aleatoria(), 0, 'Endereço B', 2);
  INSERT /*+ APPEND */ INTO funcionarios (nome_funcionario, data_nascimento, telemovel, gerente, morada, agencia) VALUES ('Funcionário C', TO_DATE('1990-03-03', 'YYYY-MM-DD'), obter_morada_aleatoria(), 0, 'Endereço C', 1);
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO agencias (morada) VALUES (obter_morada_aleatoria());
  INSERT /*+ APPEND */ INTO agencias (morada) VALUES (obter_morada_aleatoria());
  INSERT /*+ APPEND */ INTO agencias (morada) VALUES (obter_morada_aleatoria());
  COMMIT;
END;
/


BEGIN
  --INSERT /*+ APPEND */ INTO clientes (nif, nome, data_nascimento, telefone, morada, profissao, agencia) VALUES (3456789, 'Cliente A', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 987654321, obter_morada_aleatoria(), 'Profissão A', 1);
  --INSERT /*+ APPEND */ INTO clientes (nif, nome, data_nascimento, telefone, morada, profissao, agencia) VALUES (7654321, 'Cliente B', TO_DATE('1990-02-02', 'YYYY-MM-DD'), 123456789, obter_morada_aleatoria(), 'Profissão B', 2);
  --INSERT /*+ APPEND */ INTO clientes (nif, nome, data_nascimento, telefone, morada, profissao, agencia) VALUES (5555555, 'Cliente C', TO_DATE('1990-03-03', 'YYYY-MM-DD'), 555555555, obter_morada_aleatoria(), 'Profissão C', 1);
  SP_CLIENTES_INSERIR(3456789, 'Cliente A', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 987654321, obter_morada_aleatoria(), 'Profissão A', 1):
  SP_CLIENTES_INSERIR(7654321, 'Cliente B', TO_DATE('1990-02-02', 'YYYY-MM-DD'), 123456789, obter_morada_aleatoria(), 'Profissão B', 2):
  SP_CLIENTES_INSERIR(5555555, 'Cliente C', TO_DATE('1990-03-03', 'YYYY-MM-DD'), 555555555, obter_morada_aleatoria(), 'Profissão C', 1):
  
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO logins (nif, email, password) VALUES (123456789, 'clienteA@example.com', 'passwordA');
  INSERT /*+ APPEND */ INTO logins (nif, email, password) VALUES (987654321, 'clienteB@example.com', 'passwordB');
  INSERT /*+ APPEND */ INTO logins (nif, email, password) VALUES (555555555, 'clienteC@example.com', 'passwordC');
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO contas (iban, saldo, data_criacao, tipo_produto) VALUES (1, 1000.00, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 1);
  INSERT /*+ APPEND */ INTO contas (iban, saldo, data_criacao, tipo_produto) VALUES (2, 1500.50, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 2);
  INSERT /*+ APPEND */ INTO contas (iban, saldo, data_criacao, tipo_produto) VALUES (3, 2000.75, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 1);
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO titulares (iban, nif_cliente, tipo_titular) VALUES (1, 123456789, 1);
  INSERT /*+ APPEND */ INTO titulares (iban, nif_cliente, tipo_titular) VALUES (2, 987654321, 1);
  INSERT /*+ APPEND */ INTO titulares (iban, nif_cliente, tipo_titular) VALUES (3, 555555555, 1);
  COMMIT;
END;
/


BEGIN
  INSERT /*+ APPEND */ INTO cartoes (numero_cartao, data_validade, ccv, pin, plafond, tipo_cartao, iban, proprietario) VALUES (1, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 123, 1234, 2000.00, 'Débito', 1, 123456789);
  INSERT /*+ APPEND */ INTO cartoes (numero_cartao, data_validade, ccv, pin, plafond, tipo_cartao, iban, proprietario) VALUES (2, TO_DATE('2025-02-01', 'YYYY-MM-DD'), 456, 5678, 1500.50, 'Crédito', 2, 987654321);
  INSERT /*+ APPEND */ INTO cartoes (numero_cartao, data_validade, ccv, pin, plafond, tipo_cartao, iban, proprietario) VALUES (3, TO_DATE('2025-03-01', 'YYYY-MM-DD'), 789, 9012, 2000.75, 'Débito', 3, 555555555);
  COMMIT;
END;
/

BEGIN
    gerar_movimentos_aleatorios(25);
END;





