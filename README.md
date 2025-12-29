graph TD
    User[User / Browser]

    Frontend[Frontend<br/>(Next.js)]
    Backend[Backend API]
    MySQL[(MySQL Database)]
    Redis[(Redis Cache)]

    User -->|HTTP :3000| Frontend
    Frontend -->|API Request| Backend
    Backend -->|Query| MySQL
    Backend -->|Cache| Redis

    subgraph Docker Network: capstone-network
        Frontend
        Backend
        MySQL
        Redis
    end
