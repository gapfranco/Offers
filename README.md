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

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
