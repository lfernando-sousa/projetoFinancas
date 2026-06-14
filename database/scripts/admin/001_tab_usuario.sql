-- Criação da tabela de usuarios do sistema

drop table usuario ;

drop public synonym usuario ;

create table usuario (
   nome          varchar2(150) not null,
   email         varchar2(255) not null unique,
   username      varchar2(100) not null unique,
   senha_hash    varchar2(255) not null,
   status        number(1) default 1 not null ,
   data_criacao   timestamp default systimestamp not null,
   data_alteracao timestamp default systimestamp not null,
   ultimo_login   timestamp
);

create or replace public synonym usuario for financeiro_adm.usuario ;

exit ;