# 🎤 Documento 2 — Guia do Palestrante: O Que Cada Arquivo e Comando Faz

> **Este documento é exclusivo para os palestrantes. Não distribua aos alunos.**
> Use-o no dia anterior ao workshop para contextualizar a estrutura do projeto antes de partir para a prática.

---

## Por que usamos FastAPI?

FastAPI é um framework moderno para criar APIs em Python de forma rápida, organizada e com documentação automática. Ele gerencia rotas, requisições HTTP, validação de dados e gera uma interface interativa de testes automaticamente no caminho `/docs`.

---

## O que cada biblioteca instalada faz

| Biblioteca | Função |
|---|---|
| **FastAPI** | Framework principal. Cria rotas/endpoints, processa requisições HTTP e valida dados automaticamente. |
| **Uvicorn** | Servidor ASGI que executa a aplicação. É ele quem "liga" a API para receber requisições. |
| **SQLAlchemy** | ORM (Object Relational Mapper). Permite manipular o banco de dados usando objetos Python, sem escrever SQL puro o tempo todo. |
| **PyMySQL** | Driver de conexão entre Python e o banco de dados MySQL. É a "ponte" que permite a comunicação. |
| **python-dotenv** | Carrega variáveis sensíveis (senha, host, porta) de um arquivo `.env`, mantendo-as fora do código-fonte. |
| **Pydantic** | Valida e tipifica os dados que entram e saem da API. Integrado ao FastAPI, rejeita automaticamente dados no formato errado. |

---

## Por que criar um ambiente virtual?

O ambiente virtual (`venv`) isola as dependências do projeto do restante do sistema. Isso evita conflitos entre versões de bibliotecas em projetos diferentes e mantém o projeto portátil e reproduzível.

---

## O arquivo `.env` — guardando segredos com segurança

O arquivo `.env` armazena credenciais sensíveis (usuário, senha, host do banco) fora do código. Sem ele, essas informações ficariam expostas diretamente nos arquivos Python, o que é uma má prática de segurança. A biblioteca `python-dotenv` carrega essas variáveis na memória em tempo de execução.

---

## `database.py` — A ponte com o banco de dados

Este arquivo é responsável por toda a comunicação com o MySQL. Sem ele, nenhuma outra parte da aplicação consegue acessar o banco.

**O que ele faz, passo a passo:**

- **`load_dotenv()`** — carrega as variáveis do `.env` para a memória.
- **`URL_BANCO`** — monta a string de conexão no formato exigido pelo SQLAlchemy:
  ```
  mysql+pymysql://usuario:senha@host:porta/banco
  ```
- **`create_engine()`** — cria o motor de conexão com o banco.
- **`sessionmaker()`** — configura sessões seguras de acesso ao banco (autocommit desligado para controle manual das transações).
- **`get_db()`** — função geradora que abre uma sessão antes de cada requisição e a fecha automaticamente ao final, evitando vazamentos de conexão.

---

## `models.py` — O mapa das tabelas

Este arquivo ensina ao Python como as tabelas do banco estão estruturadas, usando o conceito de ORM.

**O que ele faz:**

- Define uma classe Python para cada tabela do banco.
- Mapeia cada atributo da classe a uma coluna da tabela.
- Informa o tipo de dado de cada coluna (`Integer`, `String`, etc.).
- Define a chave primária da tabela.

**Exemplo:**
```python
cod_estado = Column(Integer, primary_key=True)
```
Isso diz ao SQLAlchemy que `cod_estado` é um número inteiro e é a chave principal da tabela `estados`.

Sem `models.py`, o Python não entende a estrutura do banco e o CRUD não funciona.

---

## `schemas.py` — As regras de validação dos dados

Este arquivo define o "contrato" da API: quais dados ela aceita e quais ela devolve. Ele usa Pydantic para garantir que apenas dados no formato correto entrem e saiam.

**O que ele faz:**

- **Modelos de entrada** (`EstadoCreate`) — define o que o cliente precisa enviar para criar ou atualizar um registro.
- **Modelos de resposta** (`EstadoResponse`) — define o que a API retorna ao cliente.
- **Validação automática** — se um campo esperado como `str` receber um número, o FastAPI rejeita a requisição e retorna um erro de validação antes mesmo de tocar no banco de dados.

Sem `schemas.py`, a API aceita praticamente qualquer dado, aumentando o risco de erros e inconsistências.

---

## `main.py` — O coração da aplicação

Este é o arquivo principal. Ele inicializa o FastAPI e registra todos os endpoints HTTP da API.

**O que ele contém:**

- **`app = FastAPI()`** — cria a instância da aplicação.
- **`CORSMiddleware`** — configura quais origens externas (outros sistemas, frontends) podem acessar a API. Sem isso, chamadas de um frontend seriam bloqueadas pelo navegador.
- **Rotas HTTP** — cada função decorada com `@app.get`, `@app.post`, `@app.put` ou `@app.delete` cria um endpoint que responde a um método HTTP específico.

**Os quatro verbos HTTP e o que representam no CRUD:**

| Método HTTP | Operação | Exemplo |
|---|---|---|
| `GET` | Consultar dados | Listar todos os estados |
| `POST` | Criar dados | Cadastrar um novo estado |
| `PUT` | Atualizar dados | Editar o nome de um estado |
| `DELETE` | Remover dados | Excluir um estado |

Sem `main.py`, não existe aplicação FastAPI rodando.

---

## O comando para rodar a aplicação

```
uvicorn main:app --host 0.0.0.0 --port 8000
```

- **`uvicorn`** — o servidor que executa a aplicação.
- **`main:app`** — instrui o uvicorn a importar o objeto `app` do arquivo `main.py`.
- **`--host 0.0.0.0`** — torna a API acessível na rede local (não apenas no próprio computador).
- **`--port 8000`** — define a porta onde a API vai escutar requisições.

---

## Hoppscotch — testando a API como o mercado faz

**[https://hoppscotch.io/](https://hoppscotch.io/)** é uma ferramenta online similar ao Postman, usada para testar e consumir APIs REST. Simula o que um sistema externo (como um frontend ou app mobile) faria ao se comunicar com a API. É uma forma prática de mostrar aos alunos como o mercado de trabalho consome APIs.

---

## Fluxo geral do projeto

```
.env
  └─ database.py  (lê credenciais, conecta ao banco)
       └─ models.py   (mapeia as tabelas)
       └─ schemas.py  (valida os dados)
            └─ main.py    (cria os endpoints e orquestra tudo)
```

Cada arquivo tem uma responsabilidade única e clara. Essa separação é uma boa prática de organização de código, muito comum em projetos reais com FastAPI.
