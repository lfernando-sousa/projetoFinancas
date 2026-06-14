from fastapi import APIRouter

router = APIRouter(prefix="/health", tags=["Health"])

@router.get("/")
def nhealth_check():
    """Verifica se API está no ar."""
    return{
        "api": "ok" ,
        "mensagem": "API Finanças está funcionando"
    }