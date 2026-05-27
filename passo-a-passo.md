# 📘 Documento 1 — Passo a Passo para Configurar uma API com FastAPI

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
DB_NAME=db_time
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

class Time(Base):
    __tablename__ = "tb_times"

    cod_time = Column(Integer, primary_key=True, index=True)
    nome_time = Column(String(100), nullable=False)
    sigla_time = Column(String(17), nullable=False)
    estado_time = Column(String(50), nullable=False)
    pais_time = Column(String(50), nullable=False)
```

---

## 8. Criar o arquivo `schemas.py`

Crie os modelos de validação de dados com Pydantic:

```python
from pydantic import BaseModel

class TimeBase(BaseModel):
    nome_time: str
    sigla_time: str
    estado_time: str
    pais_time: str

class TimeCreate(TimeBase):
    pass

class TimeResponse(TimeBase):
    cod_time: int

    class Config:
        from_attributes = True
```

---

## 9. Criar o arquivo `main.py`

```python
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List

import models
import schemas
from database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="API Sistema Futebolístico", description="Operações do banco db_time")

# Configuração aberta de CORS (Compartilhamento de Recursos de Origem Cruzada)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/times/", response_model=List[schemas.TimeResponse])
def listar_times(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    lista = db.query(models.Time).offset(skip).limit(limit).all()
    return lista

@app.post("/times/", response_model=schemas.TimeResponse, status_code=201)
def criar_time(time: schemas.TimeCreate, db: Session = Depends(get_db)):
    novo_time = models.Time(
        nome_time=time.nome_time,
        sigla_time=time.sigla_time,
        estado_time=time.estado_time,
        pais_time=time.pais_time
    )
    db.add(novo_time)
    db.commit()
    db.refresh(novo_time)
    return novo_time

@app.get("/times/{cod_time}", response_model=schemas.TimeResponse)
def buscar_time(cod_time: int, db: Session = Depends(get_db)):
    time = db.query(models.Time).filter(models.Time.cod_time == cod_time).first()
    if time is None:
        raise HTTPException(status_code=404, detail="Time Inexistente.")
    return time

@app.put("/times/{cod_time}", response_model=schemas.TimeResponse)
def atualizar_time(cod_time: int, time_novo: schemas.TimeCreate, db: Session = Depends(get_db)):
    time = db.query(models.Time).filter(models.Time.cod_time == cod_time).first()
    if time is None:
        raise HTTPException(status_code=404, detail="Time Inexistente.")
    
    time.nome_time = time_novo.nome_time
    time.sigla_time = time_novo.sigla_time
    
    db.commit()
    db.refresh(time)
    return time

@app.delete("/times/{cod_time}", status_code=204)
def deletar_time(cod_time: int, db: Session = Depends(get_db)):
    time = db.query(models.Time).filter(models.Time.cod_time == cod_time).first()
    if time is None:
        raise HTTPException(status_code=404, detail="Time Inexistente.")
    
    db.delete(time)
    db.commit()
    return None
```

---

## 10. Rodar a aplicação

```
uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## 11. Testar a API

Acesse **[https://hoppscotch.io/](https://hoppscotch.io/)** para consumir e testar os endpoints da API.
