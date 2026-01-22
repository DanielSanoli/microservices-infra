# microservices-infra

Infra local (Docker Compose) para rodar:
- porygonz-gateway
- microservices-gym-leader
- microservices-typematch
- Postgres
- Redis

## Estrutura esperada
Clone os repositórios no mesmo diretório pai:

```
/projetos
  /microservices-infra
  /porygonz-gateway
  /microservices-gym-leader
  /microservices-typematch
```

## Como rodar
No Windows PowerShell (com Docker Desktop rodando):

```bash
cd microservices-infra
copy .env.example .env
docker compose up -d --build
```

## Endpoints
Gateway: `http://localhost:8080`

- `GET /api/v1/pokemon/{idOrName}` -> gym-leader
- `GET /api/v1/compare/{id1}/{id2}` -> typematch
- `GET /api/v1/fusions` -> fusion-ai-api

## Logs
```bash
docker compose logs -f gateway
docker compose logs -f typematch
docker compose logs -f gym-leader
```

## Reset total (containers + volume do Postgres)
```bash
docker compose down -v
```

## Arquitetura (visão técnica)

```mermaid
flowchart LR
  %% ========= STYLES =========
  classDef client fill:#111827,stroke:#374151,color:#E5E7EB
  classDef gateway fill:#0284c7,stroke:#0369a1,color:#0b1220
  classDef service fill:#16a34a,stroke:#15803d,color:#052e12
  classDef data fill:#7c3aed,stroke:#6d28d9,color:#f5f3ff

  %% ========= NODES =========
  client[Client<br/>Browser / Postman]:::client

  gw[Gateway (porygonz-gateway)<br/>localhost:8080]:::gateway

  gym[Gym Leader (gym-leader)<br/>localhost:8081]:::service
  type[TypeMatch (typematch)<br/>localhost:8082]:::service
  fusion[Fusion IA (fusion-ia-api)<br/>localhost:8000]:::service

  pg[(Postgres<br/>porygonz-postgres<br/>localhost:5432)]:::data
  rd[(Redis<br/>porygonz-redis<br/>localhost:6379)]:::data

  %% ========= FLOWS =========
  client -->|HTTP /api/v1/*| gw

  gw -->|/api/v1/pokemon/*| gym
  gw -->|/api/v1/compare/*| type
  gw -->|/api/v1/fusions/*| fusion

  type -->|POKEDEX_BASE_URL<br/>http://gym-leader:8081/api/v1/pokemon| gym

  gym ---|JDBC| pg
  gym ---|Cache| rd

  fusion -. (futuro: persistência) .-> pg
```