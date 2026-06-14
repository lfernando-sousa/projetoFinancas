-- Executado automaticamente pelo container na primeira inicializacao
-- Roda como SYS no CDB - precisa mudar para o PDB antes de criar o usuario

alter session set container = freepdb1;

-- usuario FINANCEIRO_ADM
create user financeiro_adm identified by abc13245
   default tablespace users
   temporary tablespace temp
   quota unlimited on users;

-- usuario FINANCEIRO_LOGIN
create user financeiro_login identified by abc13245
   default tablespace users
   temporary tablespace temp
   quota unlimited on users;

-- grants para o FINANCEIRO_ADM
grant connect,resource to financeiro_adm;
-- objetos não contidos no resource
grant create table,
   create view,
   create synonym,
   create public synonym,   -- permite criar sinonimos publicos (sem prefixo de schema)
   drop public synonym,     -- permite dropar sinonimos publicos criados por ele
   create job,
   create materialized view,
   create trigger
to financeiro_adm;
-- Privilégios de financeiro_admistração de usuários
grant create user to financeiro_adm;
grant alter user to financeiro_adm;
grant drop user to financeiro_adm;
-- Privilégios de gerenciar privilégios
grant grant any privilege to financeiro_adm;
grant grant any role to financeiro_adm;
-- Permitir apenas se financeiro_adm precisar gerenciar objetos de outros usuários
grant select any table to financeiro_adm;         -- Consultar qualquer tabela
--grant insert any table to financeiro_adm;         -- Inserir em qualquer tabela
grant update any table to financeiro_adm;         -- Atualizar qualquer tabela
grant delete any table to financeiro_adm;         -- Deletar de qualquer tabela
grant execute any procedure to financeiro_adm;    -- Executar qualquer procedure
-- Permitir alterar e apagar objetos de outros schemas
grant alter any table to financeiro_adm;          -- Alterar estrutura de tabelas
grant drop any table to financeiro_adm;           -- Apagar tabelas
grant alter any procedure to financeiro_adm;      -- Alterar procedures
grant drop any procedure to financeiro_adm;       -- Apagar procedures
--Privilégios de debug
grant debug connect session to financeiro_adm;
grant debug any procedure to financeiro_adm;
--Revogar privilégios perigosos (se foram concedidos acidentalmente)
revoke sysdba from financeiro_adm;
revoke sysoper from financeiro_adm;

-- role de acesso para o FINANCEIRO_LOGIN
-- agrupa privilégios que podem ser concedidos via role
create role financeiro_app_role;

-- consumir qualquer procedure, function, package do banco
grant execute any procedure to financeiro_app_role;

-- leitura de sequences
grant select any sequence   to financeiro_app_role;

-- IMPORTANTE: grants ANY para DML precisam ser diretos ao usuario, nao ao role,
-- pois o Oracle nao ativa privilegios do sistema concedidos via role por padrao
grant select any table      to financeiro_login;
grant insert any table      to financeiro_login;
grant update any table      to financeiro_login;
grant delete any table      to financeiro_login;

-- privilegios para o FINANCEIRO_LOGIN
grant create session        to financeiro_login;
grant create synonym        to financeiro_login;  -- permite criar sinonimos privados no proprio schema
--grant financeiro_app_role   to financeiro_login;

commit;

exit ;