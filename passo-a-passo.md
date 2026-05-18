# 📘 Documento 1 — Guia do Aluno: Passo a Passo para Configurar uma API com FastAPI

---

## 1. Criar a pasta do projeto e abrir no VS Code

Crie uma pasta para o projeto e abra-a no VS Code.

---

## 2. Criar o ambiente virtual (venv)

**No PowerShell:**
```
python -m venv venv
```

**No Git Bash:**
```
python3 -m venv venv
```

---

## 3. Liberar permissões e ativar o ambiente virtual

**Se estiver usando PowerShell**, rode este comando para liberar a política de execução:
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

**Ativar o ambiente:**

- No PowerShell:
```
venv\Scripts\activate
```

- No Git Bash:
```
source venv/bin/activate
```

---

## 4. Instalar as bibliotecas necessárias

```
pip install fastapi uvicorn sqlalchemy pymysql python-dotenv pydantic
```

---

## 5. Criar o arquivo `.env`

Na raiz do projeto, crie um arquivo chamado `.env` com o seguinte conteúdo:

```
DB_USER=root
DB_PASSWORD=''
DB_HOST=localhost
DB_PORT=3306
DB_NAME=bd_escola
```

---

## 6. Criar o arquivo `database.py`

```python
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

URL_BANCO = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(URL_BANCO)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

---

## 7. Criar o arquivo `models.py`

Crie a classe que representa a tabela do banco de dados. Exemplo com a tabela de estados:

```python
from sqlalchemy import Column, Integer, String
from database import Base

class Estado(Base):
    __tablename__ = "estados"

    cod_estado = Column(Integer, primary_key=True)
    nome_estado = Column(String(100))
```

---

## 8. Criar o arquivo `schemas.py`

Crie os modelos de validação de dados com Pydantic:

```python
from pydantic import BaseModel

class EstadoCreate(BaseModel):
    nome_estado: str

class EstadoResponse(BaseModel):
    cod_estado: int
    nome_estado: str

    class Config:
        from_attributes = True
```

---

## 9. Criar o arquivo `main.py`

```python
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import models, schemas
from database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/estados/", response_model=list[schemas.EstadoResponse])
def listar_estados(db: Session = Depends(get_db)):
    return db.query(models.Estado).all()

@app.post("/estados/", response_model=schemas.EstadoResponse)
def criar_estado(estado: schemas.EstadoCreate, db: Session = Depends(get_db)):
    novo = models.Estado(nome_estado=estado.nome_estado)
    db.add(novo)
    db.commit()
    db.refresh(novo)
    return novo

@app.put("/estados/{cod}", response_model=schemas.EstadoResponse)
def atualizar_estado(cod: int, estado: schemas.EstadoCreate, db: Session = Depends(get_db)):
    obj = db.query(models.Estado).filter(models.Estado.cod_estado == cod).first()
    if not obj:
        raise HTTPException(status_code=404, detail="Estado não encontrado")
    obj.nome_estado = estado.nome_estado
    db.commit()
    db.refresh(obj)
    return obj

@app.delete("/estados/{cod}")
def deletar_estado(cod: int, db: Session = Depends(get_db)):
    obj = db.query(models.Estado).filter(models.Estado.cod_estado == cod).first()
    if not obj:
        raise HTTPException(status_code=404, detail="Estado não encontrado")
    db.delete(obj)
    db.commit()
    return {"mensagem": "Estado deletado com sucesso"}
```

---

## 10. Rodar a aplicação

```
uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## 11. Testar a API

Acesse **[https://hoppscotch.io/](https://hoppscotch.io/)** para consumir e testar os endpoints da API.
