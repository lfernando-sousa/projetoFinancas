create or replace package pck_usuario as
    
    type t_usuario is record(
        nome       usuario.nome%type      ,
        email      usuario.email%type     ,
        username   usuario.username%type  ,
        senha_hash usuario.senha_hash%type) ;

    g_t_usuario t_usuario ;

    procedure inserir(
        p_usuario in t_usuario       ,
        p_erro    out nocopy varchar2) ;

    procedure inativar_por_email(
        p_email   in usuario.email%type,
        p_erro    out nocopy varchar2  ) ;

    procedure inativar_por_username(
        p_username   in usuario.username%type,
        p_erro       out nocopy varchar2     ) ;

end pck_usuario ;

/

create or replace package body pck_usuario as

    -- Privada
    procedure inativar(
        p_usuario in t_usuario       ,
        p_erro    out nocopy varchar2) is
        
        pragma autonomous_transaction ;

    begin

        if p_usuario.email is null and p_usuario.username is null then

            p_erro := 'Informe o e-mail ou nome do usuario' ;
            return ;

        end if ;

        update usuario
        set    status         = 0 ,
               data_alteracao = systimestamp
        where email    = p_usuario.email 
        or    username = p_usuario.username ;

        commit ;
    
    exception when others then
        rollback ;
        p_erro := 'Falha ao inativas usuario: ' || sqlerrm ;
    
    end inativar ;

    procedure inserir(
        p_usuario in t_usuario       ,
        p_erro    out nocopy varchar2) is

        pragma autonomous_transaction ;

    begin

        insert into usuario(
            nome      , 
            email     , 
            username  , 
            senha_hash)
        values(
            p_usuario.nome      , 
            p_usuario.email     , 
            p_usuario.username  ,
            p_usuario.senha_hash);
        commit ;

    exception 
        when dup_val_on_index then
            p_erro := 'Usuario ja possui cadastrado'; 
        when others then
            rollback ;
            p_erro := 'Erro ao inserir Usuario'; 
    end inserir ;

    procedure inativar_por_email(
        p_email   in usuario.email%type,
        p_erro    out nocopy varchar2  ) is

    begin
        g_t_usuario := null ;
        g_t_usuario.email := p_email ;

        inativar(g_t_usuario , p_erro) ;

    end inativar_por_email ;

    procedure inativar_por_username(
        p_username   in usuario.username%type,
        p_erro       out nocopy varchar2     ) is

    begin
        g_t_usuario := null ;
        g_t_usuario.username := p_username ;

        inativar(g_t_usuario , p_erro) ;

    end inativar_por_username ;

end pck_usuario ;

/

create or replace public synonym pck_usuario for financeiro_adm.pck_usuario ;

exit ;