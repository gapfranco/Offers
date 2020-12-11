# Offers API

## Sumário

API para criação, manutenção e consulta de ofertas de cursos em Universidades.
Para montar o banco de dados de cunsulta foram criados os seguintes endpoints:

- Criação e manutenção de Universidades
- Criação e manutenção de campus de cada unversidade
- Criação e manutenção de cursos
- Criação e manutenção de ofertas de cursos

## Recursos

- Autenticação da API com JWT
- Endpoint para registro de usuários (sign-on)
- Endpoint para autenticação (sign-in)
- Todos os demais endpoints exigem autenticação por token JWT

## Implementação

Para testar localmente:

- Instalar as dependências com `mix deps.get`
- Criar e e migrar o banco de dados com `mix ecto.setup`
- Fazer a carga de dados para teste com `mix run priv/repo/seeds.exs`. Vai carregar os dados contidos no db.json que foi enviado.
- Iniciar o endpoint Phoenix com `mix phx.server`

Acessar os endpoints com um cliente API como o CURL ou Insomnia no endereço `localhost:4000`.

## Modelagem dos dados

O banco de dados possui a seguinte estrutura:

![modelagem](modelagem.png)

As seguintes entidades estão definidas:

### Users

Tabela de usuários

```
{
  "id": string,
  "email": string,
  "password_hash": string,
  "inserted_at": string,
  "updates_at": string,
}
```

### Universities

Tabela de universidades.

```
{
  "name": string,
  "score": float,
  "logo_url": string,
  "inserted_at": string,
  "updates_at": string,
}
```

### Campus

Tabela de campus das universidades

```
{
  "name": string,
  "city": string,
  "university_id": id,
  "inserted_at": string,
  "updates_at": string,
}
```

### Courses

Tabela de cursos oferecidos pelas universidades em seus campus.

Observação
: Apesar do registro do campus do curso já determinar a universidade, optei por denormalizar
: o campo university_id para facilitar as consultas. O campo university_id é preenchido automaticamente
: ao se informar o campus_id

```
{
  "name": string,
  "kind": string,
  "level": string,
  "shift": string
  "university_id": id,
  "campus_id": id,
  "inserted_at": string,
  "updates_at": string,
}
```

### Bids

Tabela de ofertas de cursos oferecidos pelas universidades em seus campus

Observação
: Apesar do registro do curso já determinar a universidade e o caampus, optei por denormalizar
: os campos university_id e campus_id para facilitar as consultas. O campos são preenchidoa automaticamente
: ao se informar o course_id na inclusão.

```
{
  "full_price": float,
  "price_with_discount": float,
  "discount_percentage": float,
  "start_date": string,
  "enrollment_semester": string,
  "enabled": boolean,
  "course_id": id,
  "university_id": id,
  "campus_id": id,
  "inserted_at": string,
  "updates_at": string,
}
```

## Chamadas de API

**Autenticação**

- [Novo usuário (sign-on)](#sign-on)
- [Conectar (sign-in)](#sign-in)

**Universidades**

- [Cadastrar uma universidade](#cadastrar-uma-universidade)
- [Consultar uma universidade](#consultar-uma-universidade)
- [Alterar uma universidade](#alterar-uma-universidade)
- [Excluir uma universidade](#excluir-uma-universidade)
- [Listar as universidades](#listar-as-universidades)

**Campus**

- [Cadastrar um campus de universidade](#cadastrar-um-campus-de-universidade)
- [Consultar um campus](#consultar-um-campus)
- [Alterar um campus](#alterar-um-campus)
- [Excluir um campus](#excluir-um-campus)
- [Listar os campus](#listar-os-campus)

**Cursos**

- [Cadastrar um curso](#cadastrar-um-curso)
- [Consultar um curso](#consultar-um-curso)
- [Alterar um curso](#alterar-um-curso)
- [Excluir um curso](#excluir-um-curso)
- [Listar os curso](#listar-os-cursos)

**Ofertas**

- [Cadastrar uma oferta](#cadastrar-uma-oferta)
- [Consultar uma oferta](#consultar-uma-oferta)
- [Alterar uma oferta](#alterar-uma-oferta)
- [Excluir uma oferta](#excluir-uma-oferta)
- [Listar as ofertas](#listar-as-ofertas)

## Autenticação

Para usar a API é preciso criar um usuário (sign-on) e conectar-se (sign-in).
A autenticação gera um token JWT que deverá ser incluido nas chamadas dos demais
endpoints para autenticar a solicitação.

## sign-on

Cria um novo usuário.

### Request

`POST /api/sign_on`

### Body

JSON com e-mail do usuário e senha. A senha deve ter pelo menos 6 caracteres.

```
{
  "email": "eu@algo.com",
  "password": "secreto",
}
```

### Response

JSON com campos do evento criado.

```
{
  "user": {
    "email": "eu@algo.com",
    "id": 123
  }
}
```

### Erros

Ocorrerá erro se o usuário já existir, se não informar uma senha ou se a senha tiver menos de 6 caracteres.
Nesses casos, a chamada retorna:

```
{
  "errors": [
    {
      "key": "email",
      "message": [
        "has already been taken"
      ]
    }
  ]
}
```

```
{
  "errors": [
    {
      "key": "password",
      "message": [
        "can't be blank"
      ]
    }
  ]
}
```

```
{
  "errors": [
    {
      "key": "password",
      "message": [
        "should be at least 6 character(s)"
      ]
    }
  ]
}
```

## sign-in

Conectar-se ao serviço

### Request

`POST /api/sign_in`

### Body

JSON com e-mail do usuário e senha.

```
{
  "email": "eu@algo.com",
  "password": "secreto",
}
```

### Response

JSON com o token JWT.

```
{
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJvZmZlcnMiLCJleHAiOjE2MDk4Njc0MTAsImlhdCI6MTYwNzQ0ODIxMCwiaXNzIjoib2ZmZXJzIiwianRpIjoiODAyNjQwNDEtODBjNS00NWIzLWJkNjctNGI3ZGFlYjAxNDFjIiwibmJmIjoxNjA3NDQ4MjA5LCJzdWIiOiIxOSIsInR5cCI6ImFjY2VzcyJ9.GGmy0jj-wkCgnyWU7mCLOD3h1zxga5T_kJQSBnFQB68jYspyIqN9r42YcsCutGPrhBtNRRFa5dZkDiZeSaTm0g"
}
```

### Erros

Ocorrerá erro se o usuário não existir ou a senha vor inválida.
Nesses casos, a chamada retorna:

```
{
  "error": "login_error"
}
```

## API de Universidades

Um usuário autenticado pode chamar os endpoints da API de universidades. Todas as chamadas
verificam o header **Authorization Bearer token**, onde token é JWT retornado na autenticação.

## Cadastrar uma universidade

### Request

`POST /api/universities`

### Body

JSON com os dados da universidade. Todos os campos são obrigatórios.

```
{
	"university": {
    "name": "OXFORD",
    "score": 4.5,
    "logo_url": "https://oxford.com/oxford.png"
	}
}
```

### Response

JSON com os dados incluidos.

```
{
  "data": {
    "id": 9,
    "logo_url": "https://oxford.com/oxford.png",
    "name": "OXFORD",
    "score": 4.5
  }
}
```

### Erros

Se ocorrer algum erro ele ser;a mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "logo_url",
      "message": [
        "can't be blank"
      ]
    }
  ]
}
```

## Consultar uma universidade

### Request

`GET /api/universities/:id`

:id é o código da universidade

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "id": 1,
    "logo_url": "https://www.tryimg.com/u/2019/04/16/unicsul.png",
    "name": "UNICSUL",
    "score": 4.1
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
    "detail": "Not Found"
  }
}
```

## Alterar uma universidade

### Request

`PUT /api/universities/:id`

:id é o código da universidade

### Body

JSON com os dados a alterar.

```
{
	"university": {
    "score": 4.5,
	}
}
```

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "id": 1,
    "logo_url": "https://www.tryimg.com/u/2019/04/16/unicsul.png",
    "name": "UNICSUL",
    "score": 4.5
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "score",
      "message": [
        "is invalid"
      ]
    }
  ]
}
```

## Excluir uma universidade

### Request

`DELETE /api/universities/:id`

:id é o código da universidade

### Response

Nenhum dado

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
     "detail": "Not Found"
  }
}
```

## Listar as universidades

### Request

`GET /api/universities`

### Response

JSON com a lista registros cadastrados.

```
{
  "data": [
    {
      "id": 1,
      "logo_url": "https://www.tryimg.com/u/2019/04/16/unicsul.png",
      "name": "UNICSUL",
      "score": 4.1
      },
    {
      "id": 3,
      "logo_url": "https://www.tryimg.com/u/2019/04/16/unip.png",
      "name": "UNIP",
      "score": 4.5
    },
    ...
}
```

## API de Campus

Um usuário autenticado pode chamar os endpoints da API de cursos. Todas as chamadas
verificam o header **Authorization Bearer token**, onde token é JWT retornado na autenticação.

## Cadastrar um campus de universidade

### Request

`POST /api/campus`

### Body

JSON com os dados do campos e o id da universidade. Todos os campos são obrigatórios.

```
{
	"campus": {
		"name": "Jaguaré",
    "university_id": 1,
    "city": "São Paulo"
	}
}
```

### Response

JSON com os dados incluidos.

```
{
  "data": {
    "city": "São Paulo",
    "id": 6,
    "name": "Jaguaré"
  }
}
```

### Erros

Se ocorrer algum erro ele ser;a mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "university",
      "message": [
        "does not exist"
      ]
    }
  ]
}
```

## Consultar um campus

### Request

`GET /api/campus/:id`

:id é o código do campus

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "city": "São José dos Campos",
    "id": 1,
    "name": "Jardim 2"
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
    "detail": "Not Found"
  }
}
```

## Alterar um campus

### Request

`PUT /api/campus/:id`

:id é o código do campus

### Body

JSON com os dados a alterar.

```
{
	"campus": {
		"name": "Alterado"
	}
}
```

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "city": "São José dos Campos",
    "id": 1,
    "name": "Jardim 2"
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "university",
      "message": [
        "does not exist"
      ]
    }
  ]
}
```

## Excluir um campus

### Request

`DELETE /api/campus/:id`

:id é o código do campus

### Response

Nenhum dado

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
     "detail": "Not Found"
  }
}
```

## Listar os campus

### Request

`GET /api/campus`

### Response

JSON com a lista registros cadastrados.

```
{
  "data": [
    {
      "city": "São José dos Campos",
      "id": 1,
      "name": "Jardim 2"
    },
    {
      "city": "São Paulo",
      "id": 6,
      "name": "Jaguaré"
    },
    {
      "city": "São José dos Campos",
      "id": 7,
      "name": "Jardim das Indústrias"
    }, ...
}
```

## API de Cursos

Um usuário autenticado pode chamar os endpoints da API de cursos. Todas as chamadas
verificam o header **Authorization Bearer token**, onde token é JWT retornado na autenticação.

## Cadastrar um curso

### Request

`POST /api/courses`

### Body

JSON com os dados do curso e o id do campus. Todos os campos são obrigatórios.

```
{
	"course": {
		"name": "Biomedicina2",
      "kind": "Presencial",
      "level": "Bacharelado",
      "shift": "Noite",
		  "campus_id": 1
	}
}
```

### Response

JSON com os dados incluidos.
Observar que, pelo código do campus ele já determina e inclui o código da universidade

```
{
  "data": {
    "campus_id": 1,
    "id": 26,
    "kind": "Presencial",
    "level": "Bacharelado",
    "name": "Biomedicina2",
    "shift": "Noite",
    "university_id": 3
  }
}
```

### Erros

Se ocorrer algum erro ele ser;a mostrado no retorno. Por exemplo:

```
{{
  "errors": [
    {
      "key": "kind",
      "message": [
        "invalid kind (should be Presencial or EaD)"
      ]
    }
  ]
}
```

## Consultar um curso

### Request

`GET /api/course/:id`

:id é o código do curso

### Response

JSON com os dados cadastrados.

````
{
  "data": {
    "campus_id": 1,
    "id": 1,
    "kind": "Presencial",
    "level": "Bacharelado",
    "name": "Engenharia Mecânica",
    "shift": "Noite",
    "university_id": 3
  }
}```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

````

{
"errors": {
"detail": "Not Found"
}
}

```

## Alterar um curso

### Request

`PUT /api/course/:id`

:id é o código do curso

### Body

JSON com os dados a alterar.

```

{
"course": {
"name": "Biomed Alterado"
}
}

```

### Response

JSON com os dados cadastrados.

```

{
"data": {
"campus_id": 1,
"id": 26,
"kind": "Presencial",
"level": "Bacharelado",
"name": "Biomed Alterado",
"shift": "Noite",
"university_id": 3
}
}```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "level",
      "message": [
        "invalid level (should be Bacharelado or Tecnólogo)"
      ]
    }
  ]
}
```

## Excluir um curso

### Request

`DELETE /api/course/:id`

:id é o código do curso

### Response

Nenhum dado

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
     "detail": "Not Found"
  }
}
```

## Listar os cursos

### Request

`GET /api/courses`

### Parâmetros

Aceita os seguintes parâmetros na URL para filtrar a consulta:

- university: nome da universidade
- course: nome do curso
- kind: tipo (Presencial/EaD)
- level: nível (Bacharelado/Tecnólogo)
- shuft: período (Manhã/Noite/Virtual)
- campus: nome do campus
- city: nome da cidade

Por exemplo, `/api/courses?kind=EaD&level=Bacharelado&city=Jacare%C3%AD` vai listar os cursos tipo EaD, Bacharelado em Jacareí.

### Response

JSON com a lista registros cadastrados.

```
{
  "data": [
    {
      "campus": {
        "city": "São José dos Campos",
        "id": 1,
        "name": "Jardim 2",
        "university_id": 3
      },
      "id": 1,
      "kind": "Presencial",
      "level": "Bacharelado",
      "name": "Engenharia Mecânica",
      "shift": "Noite",
      "university": {
        "id": 3,
        "logo_url": "https://www.tryimg.com/u/2019/04/16/unip.png",
        "name": "UNIP",
        "score": 4.5
      }
    },
    {
      "campus": {
        "city": "São José dos Campos",
        "id": 1,
        "name": "Jardim 2",
        "university_id": 3
      },
      "id": 4,
      "kind": "Presencial",
      "level": "Bacharelado",
      "name": "Jornalismo",
      "shift": "Noite",
      "university": {
        "id": 3,
        "logo_url": "https://www.tryimg.com/u/2019/04/16/unip.png",
        "name": "UNIP",
        "score": 4.5
      }
    }, ...
}
```

## API de Ofertas

Um usuário autenticado pode chamar os endpoints da API de cursos. Todas as chamadas
verificam o header **Authorization Bearer token**, onde token é JWT retornado na autenticação.

## Cadastrar uma oferta

### Request

`POST /api/bids`

### Body

JSON com os dados da oferta id do curso. Todos os campos são obrigatórios.

```
{
	"bid": {
    "full_price": 2139.64,
    "price_with_discount": 706.08,
    "discount_percentage": 67.0,
    "start_date": "01/08/2019",
    "enrollment_semester": "2019.2",
    "enabled": true,
  	"course_id": 1
	}
}
```

### Response

JSON com os dados incluidos.
Observar que, pelo código do curso ele já determina e inclui o código da universidade e do campus.

```
{
  "data": {
    "campus_id": 1,
    "course_id": 1,
    "discount_percentage": 67.0,
    "enabled": true,
    "enrollment_semester": "2019.2",
    "full_price": 2139.64,
    "id": 31,
    "price_with_discount": 706.08,
    "start_date": "01/08/2019",
    "university_id": 3
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "course_id",
      "message": [
        "can't be blank"
      ]
    }
  ]
}
```

## Consultar uma oferta

### Request

`GET /api/bid/:id`

:id é o código do registro de oferta

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "campus_id": 7,
    "course_id": 1,
    "discount_percentage": 67.0,
    "enabled": true,
    "enrollment_semester": "2019.2",
    "full_price": 2139.64,
    "id": 2,
    "price_with_discount": 706.08,
    "start_date": "01/08/2019",
    "university_id": 3
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
    "detail": "Not Found"
  }
}
```

## Alterar uma oferta

### Request

`PUT /api/bid/:id`

:id é o código da oferta

### Body

JSON com os dados a alterar.

```
{
  "bid": {
    "discount_percentage": 65
  }
}
```

### Response

JSON com os dados cadastrados.

```
{
  "data": {
    "campus_id": 1,
    "course_id": 1,
    "discount_percentage": 65.0,
    "enabled": true,
    "enrollment_semester": "2019.2",
    "full_price": 2139.64,
    "id": 31,
    "price_with_discount": 706.08,
    "start_date": "01/08/2019",
    "university_id": 3
  }
}
```

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": [
    {
      "key": "discount_percentage",
      "message": [
        "can't be blank"
      ]
    }
  ]
}
```

## Excluir uma oferta

### Request

`DELETE /api/bid/:id`

:id é o código da oferta

### Response

Nenhum dado

### Erros

Se ocorrer algum erro ele será mostrado no retorno. Por exemplo:

```
{
  "errors": {
    "detail": "Not Found"
  }
}
```

## Listar as ofertas

### Request

`GET /api/bids`

### Parâmetros

Aceita os seguintes parâmetros na URL para filtrar a consulta:

- university: nome da universidade
- course: nome do curso
- kind: tipo (Presencial/EaD)
- level: nível (Bacharelado/Tecnólogo)
- shuft: período (Manhã/Noite/Virtual)
- campus: nome do campus
- city: nome da cidade

Por exemplo, `/api/bids?kind=EaD&level=Bacharelado` vai listar as ofertas tipo EaD e nível Bacharelado.

### Response

JSON com a lista registros cadastrados.

```
{
  "data": [
    {
      "campus": {
        "city": "São Paulo",
        "id": 15,
        "name": "Liberdade"
      },
      "course": {
        "id": 14,
        "kind": "EaD",
        "level": "Tecnólogo",
        "name": "Jogos Digitais",
        "shift": "Virtual"
      },
      "discount_percentage": 67.3,
      "enabled": true,
      "enrollment_semester": "2020.1",
      "full_price": 437.0,
      "id": 16,
      "price_with_discount": 142.9,
      "start_date": "01/02/2020",
      "university": {
        "id": 1,
        "logo_url": "https://www.tryimg.com/u/2019/04/16/unicsul.png",
        "name": "UNICSUL",
        "score": 4.1
      }
    },
    {
      "campus": {
        "city": "São Paulo",
        "id": 13,
        "name": "Paulista"
      },
      "course": {
        "id": 16,
        "kind": "EaD",
        "level": "Bacharelado",
        "name": "Ciências Econômicas",
        "shift": "Virtual"
      },
      "discount_percentage": 68.09,
      "enabled": true,
      "enrollment_semester": "2019.2",
      "full_price": 499.0,
      "id": 19,
      "price_with_discount": 159.23,
      "start_date": "01/08/2019",
      "university": {
        "id": 1,
        "logo_url": "https://www.tryimg.com/u/2019/04/16/unicsul.png",
        "name": "UNICSUL",
        "score": 4.1
      }
    },
    ...
  ]
}
```
