from fastapi import FastAPI
from routers import health

app = FastAPI(
    title="API Finanças",
    description="API de finanças integradas ao Oracla",
    version="1.0.0"
)

app.include_router(health.router)

@app.get("/")
def root():
    return {"status": "API Finanças online", "versao": "1.0.0"}