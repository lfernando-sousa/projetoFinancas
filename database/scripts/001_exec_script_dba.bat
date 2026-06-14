@echo off
setlocal EnableDelayedExpansion

set SCRIPTS_DIR=%~dp0dba
set ARQ=LOG_DBA.txt
set CONTAINER=DB_FINANCAS
::set CONN=financeiro_adm/abc13245@localhost:1521/FREEPDB1
set CONN=sys/abc13245@localhost:1521/FREEPDB1 as sysdba

echo Inicio da Execucao > %ARQ%
echo ================================================ >> %ARQ%
echo Scripts DBA >> %ARQ%
echo Origem: %SCRIPTS_DIR% >> %ARQ%
echo ================================================ >> %ARQ%


::Verificar de existem arquivos .sql
set EXISTE_SCRIPT=N
for %%F in (%SCRIPTS_DIR%\*.sql) do set EXISTE_SCRIPT=S

if %EXISTE_SCRIPT%==N (
    echo ============================== >> %ARQ%
    echo  - Nenhum script encontrado -  >> %ARQ%
    echo ============================== >> %ARQ%
    exit /b 0
)

:: Loop pelos arquivos .sql em ordem alfabetica
for %%F in (%SCRIPTS_DIR%\*.sql) do (
    
    echo ------------------------------------------------ >> %ARQ%
    set ORIGEM=%%~nxF
    set DESTINO=/tmp/%%~nxF
    :: COPIAR
    echo Arquivo %%~nxF >> %ARQ%
    echo 1/3 : Copiando... >> %ARQ%
    ::echo docker cp "%%F" %CONTAINER%:"!DESTINO!" >> %ARQ%
    docker cp "%%F" %CONTAINER%:"!DESTINO!"
    if !errorlevel! neq 0 (
        echo ERRO ao copiar !ORIGEM! >> %ARQ%
        exit /b 1
    )

    :: EXECUTAR
    echo 2/3 : Executando...>> %ARQ%
    ::echo docker exec -it %CONTAINER% sh -c 'sqlplus -s "%CONN%" @!DESTINO!' >> %ARQ%
    docker exec -i %CONTAINER% sqlplus -s %CONN% @!DESTINO! >> %ARQ% 2>&1
    if !errorlevel! neq 0 (
        echo ERRO: Falha ao executar !ORIGEM!
        echo Limpando arquivo remoto antes de sair...
        ::docker exec -u 0 %CONTAINER% rm "!DESTINO!"
        exit /b 1
    )

    :: EXCLUIR
    echo 3/3 : Excluindo... >> %ARQ%
    ::echo docker exec -u 0 %CONTAINER% rm "!DESTINO!" >> %ARQ%
    docker exec -u 0 %CONTAINER% rm "!DESTINO!"
    if !errorlevel! neq 0 (
        echo AVISO: Nao foi possivel remover !DESTINO! do container.
    )
    
    echo Executado com sucesso! >> %ARQ%

)

echo ================================================ >> %ARQ%
echo  - Arquivos no Diretorio de origem - >> %ARQ%
echo ------------------------------------------------ >> %ARQ%
docker exec DB_FINANCAS ls /tmp >> %ARQ% 2>&1
echo ================================================ >> %ARQ%

::pause
