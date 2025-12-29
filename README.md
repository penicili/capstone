# 🚀 Capstone Project - Docker Deployment

Deployment lengkap untuk Capstone KPI & ML Prediction System menggunakan Docker Compose.

## ✅ Status Konfigurasi

Semua file deployment sudah siap:

- ✅ **docker-compose.yml** - Main orchestration file  
- ✅ **.env** - Environment configuration
- ✅ **docker_capstone.sql** (197.63 MB) - Database initialization
- ✅ **ML Models** (4 files, ~230 MB total) - Copied to backend
- ✅ **Backend Dockerfile** - Updated & optimized
- ✅ **Frontend Dockerfile** - Updated & optimized
- ✅ **Helper Scripts** - deploy.ps1, manage.ps1, copy-models.ps1

## 🎯 Quick Start (3 Steps)

### 1️⃣ Ensure Docker Desktop is Running

```powershell
# Check Docker is running
docker version
```

### 2️⃣ Deploy Application

```powershell
# Option A: Use automated deployment script (RECOMMENDED)
.\deploy.ps1

# Option B: Manual deployment
docker compose up --build -d
```

### 3️⃣ Access Application

- **Frontend Dashboard**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

## 📦 What Gets Deployed

### Services

1. **MySQL 8.0**
   - Port: 3306
   - Database: capstone_kpi
   - Auto-initialized with docker_capstone.sql
   - Data persists in Docker volume

2. **Redis 7**
   - Port: 6379
   - Used for KPI caching
   - 5-minute TTL

3. **Backend (FastAPI)**
   - Port: 8000
   - Python 3.13
   - ML models included
   - Health checks enabled

4. **Frontend (Next.js)**
   - Port: 3000
   - Production build
   - Connected to backend

## 🛠️ Management

### Using Helper Scripts (Windows)

```powershell
# Full deployment with validation
.\deploy.ps1

# Management menu (start/stop/logs/etc)
.\manage.ps1

# Copy models from root to backend
.\copy-models.ps1
```

### Manual Commands

```bash
# Start services
docker compose start

# Stop services
docker compose stop

# Restart services
docker compose restart

# View logs
docker compose logs -f

# Check status
docker compose ps

# Stop and remove
docker compose down
```

## 📊 Verification

### Check Health

```powershell
# Backend health
Invoke-WebRequest http://localhost:8000/health

# Model status
Invoke-WebRequest http://localhost:8000/api/models/status

# KPI data
Invoke-WebRequest http://localhost:8000/api/kpi/overview
```

### Check Database

```bash
# Connect to MySQL
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi

# Inside MySQL:
SHOW TABLES;
SELECT COUNT(*) FROM studentinfo;
```

### Check Models

```bash
# List models in backend container
docker exec capstone-backend ls -la /app/src/assets/models/
```

## 🔧 Configuration

### Environment Variables (.env)

```env
# Database
DB_HOST=mysql
DB_PORT=3306
DB_USER=capstone_user
DB_PASSWORD=capstone123
DB_NAME=capstone_kpi

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# Ports
BACKEND_PORT=8000
FRONTEND_PORT=3000

# Backend Settings
DEBUG=false
LOG_LEVEL=INFO
KPI_CACHE_TTL_SECONDS=300
SAMPLE_SIZE=0.2
```

Edit `.env` file untuk custom configuration.

## 📁 Project Structure

```
project/
├── docker-compose.yml          # Main orchestration
├── .env                        # Configuration
├── docker_capstone.sql         # Database dump
├── deploy.ps1                  # Deployment script
├── manage.ps1                  # Management script
├── copy-models.ps1            # Model copy script
│
├── capstone-backend/
│   ├── Dockerfile             # Backend container config
│   ├── requirements.txt       # Python dependencies
│   └── src/
│       ├── app.py            # FastAPI application
│       └── assets/
│           └── models/       # ML models (4 files)
│
└── capstone-project-frontend/
    ├── Dockerfile            # Frontend container config
    ├── package.json          # Node dependencies
    └── app/                  # Next.js application
```

## 📚 Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Detailed deployment guide
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Pre-deployment checklist
- **[DOCKER_COMMANDS.md](DOCKER_COMMANDS.md)** - Command reference
- **[API_USAGE.md](capstone-backend/API_USAGE.md)** - API documentation

## 🐛 Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| Port conflict | Edit `.env` and change ports |
| Models not found | Run `.\copy-models.ps1` |
| MySQL won't start | Verify `docker_capstone.sql` exists |
| Backend fails | Check logs: `docker compose logs backend` |
| Frontend 502 | Wait for backend to be healthy |

### Get Help

```bash
# View all logs
docker compose logs -f

# View specific service
docker compose logs -f backend

# Check container status
docker compose ps

# Inspect container
docker inspect capstone-backend
```

### Reset Everything

```bash
# Nuclear option: remove everything and start fresh
docker compose down -v --rmi all
docker compose up --build -d
```

## 🔄 Update Workflows

### Update Code

```bash
# Backend
docker compose up -d --build backend

# Frontend
docker compose up -d --build frontend
```

### Update Models

```bash
# Copy new models
cp new_models/*.pkl capstone-backend/src/assets/models/

# Restart backend (models are volume-mounted)
docker compose restart backend
```

### Database Migration

```bash
# Apply migration
docker exec -i capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi < migration.sql
```

## 💾 Backup & Restore

### Backup

```bash
# Backup database
docker exec capstone-mysql mysqldump -u capstone_user -pcapstone123 capstone_kpi > backup_$(date +%Y%m%d).sql

# Backup models
cp -r capstone-backend/src/assets/models/ models_backup_$(date +%Y%m%d)/
```

### Restore

```bash
# Restore database
docker exec -i capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi < backup.sql

# Restore models
cp -r models_backup_20250126/* capstone-backend/src/assets/models/
docker compose restart backend
```

## 🎓 Next Steps

After successful deployment:

1. ✅ Test all API endpoints at http://localhost:8000/docs
2. ✅ Verify KPI dashboard at http://localhost:3000
3. ✅ Test predictions with sample data
4. ✅ Monitor logs for any errors
5. ✅ Setup database backup schedule
6. 📝 Document any custom configurations

## 🆘 Support

For detailed information, check:
- [DEPLOYMENT.md](DEPLOYMENT.md) - Complete deployment guide
- [DOCKER_COMMANDS.md](DOCKER_COMMANDS.md) - All Docker commands
- Backend API docs: http://localhost:8000/docs
- Frontend: http://localhost:3000

## 📝 Notes

- Database data persists in `mysql-data` Docker volume
- Models are volume-mounted for easy updates
- Redis provides caching with 5-minute TTL
- All services communicate via `capstone-network`
- Health checks ensure proper startup order

---

**Last Updated**: December 26, 2025  
**Docker Compose Version**: 3.8  
**Status**: ✅ Ready for Deployment
