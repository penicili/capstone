# Docker Compose Deployment Guide

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed dan running
- File `docker_capstone.sql` ada di root directory
- ML models ada di `capstone-backend/src/assets/models/`

### Deploy Application

```bash
# Build dan start semua services
docker compose up --build -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

### Access Services
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **MySQL**: localhost:3306

## 📁 Struktur Files

Pastikan struktur seperti ini:

```
project/
├── docker-compose.yml          ✅ Created
├── .env                        ✅ Created
├── docker_capstone.sql         ⚠️ Must exist
├── capstone-backend/
│   ├── Dockerfile              ✅ Updated
│   ├── requirements.txt        ⚠️ Must exist
│   └── src/
│       ├── app.py
│       └── assets/
│           └── models/         ⚠️ Put models here!
│               ├── dropout_model.pkl
│               ├── final_grade_model.pkl
│               ├── label_encoder_dropout.pkl
│               └── label_encoder_finalgrade.pkl
└── capstone-project-frontend/
    ├── Dockerfile              ✅ Updated
    └── package.json

```

## 🔧 Configuration

File `.env` sudah dibuat dengan konfigurasi:

```env
DB_HOST=mysql
DB_PORT=3306
DB_USER=capstone_user
DB_PASSWORD=capstone123
DB_NAME=capstone_kpi

REDIS_HOST=redis
REDIS_PORT=6379

BACKEND_PORT=8000
FRONTEND_PORT=3000
```

## 🛠️ Management Commands

### Start/Stop Services
```bash
# Stop
docker compose stop

# Start
docker compose start

# Restart
docker compose restart

# Restart specific service
docker compose restart backend
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f mysql
docker compose logs -f frontend

# Last 100 lines
docker compose logs --tail=100
```

### Clean Up
```bash
# Stop dan remove containers
docker compose down

# Remove + volumes (delete database)
docker compose down -v

# Remove everything including images
docker compose down -v --rmi all
```

## 🧪 Testing & Verification

### 1. Check Container Status
```bash
docker compose ps
```

Expected output:
```
NAME                  STATUS              PORTS
capstone-backend      Up (healthy)        0.0.0.0:8000->8000/tcp
capstone-frontend     Up                  0.0.0.0:3000->3000/tcp
capstone-mysql        Up (healthy)        0.0.0.0:3306->3306/tcp
capstone-redis        Up (healthy)        0.0.0.0:6379->6379/tcp
```

### 2. Test Backend Health
```bash
# Health check
curl http://localhost:8000/health

# Model status
curl http://localhost:8000/api/models/status

# KPI Overview
curl http://localhost:8000/api/kpi/overview
```

### 3. Verify Database
```bash
# Connect to MySQL
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi

# Inside MySQL
SHOW TABLES;
SELECT COUNT(*) FROM studentinfo;
```

### 4. Check Models in Backend
```bash
# List models in container
docker compose exec backend ls -la /app/src/assets/models/

# Should show:
# dropout_model.pkl
# final_grade_model.pkl
# label_encoder_dropout.pkl
# label_encoder_finalgrade.pkl
```

## 🐛 Troubleshooting

### Backend tidak start
```bash
# Check logs
docker compose logs backend

# Common issues:
# - MySQL belum ready → tunggu MySQL healthcheck green
# - Models tidak ada → copy models ke folder yang benar
# - Port conflict → ubah BACKEND_PORT di .env
```

### MySQL initialization failed
```bash
# Check MySQL logs
docker compose logs mysql

# Verify SQL file exists
ls -la docker_capstone.sql

# Recreate database
docker compose down -v
docker compose up -d mysql
docker compose logs -f mysql
```

### Models tidak terload
```bash
# Copy models from local
docker cp ./path/to/models/dropout_model.pkl capstone-backend:/app/src/assets/models/

# Or stop, add models, restart
docker compose down
# Copy models to capstone-backend/src/assets/models/
docker compose up -d --build backend
```

### Frontend tidak bisa connect ke Backend
```bash
# Test backend dari host
curl http://localhost:8000/health

# Check frontend logs
docker compose logs frontend

# Check environment
docker compose exec frontend env | grep API_URL
```

## 📊 Database Management

### Backup Database
```bash
# Export database
docker compose exec mysql mysqldump -u capstone_user -pcapstone123 capstone_kpi > backup_$(date +%Y%m%d_%H%M%S).sql

# Or
docker compose exec -T mysql mysqldump -u capstone_user -pcapstone123 capstone_kpi > backup.sql
```

### Restore Database
```bash
# Import backup
docker compose exec -T mysql mysql -u capstone_user -pcapstone123 capstone_kpi < backup.sql
```

### Reset Database
```bash
# Complete reset
docker compose down -v
docker compose up -d
```

## 🔄 Update & Rebuild

### Update Backend Code
```bash
# Rebuild only backend
docker compose up -d --build backend

# No cache rebuild
docker compose build --no-cache backend
docker compose up -d backend
```

### Update Frontend
```bash
# Rebuild frontend
docker compose up -d --build frontend
```

### Update Models
```bash
# Copy new models
cp /path/to/new/models/* ./capstone-backend/src/assets/models/

# Restart backend (models are volume-mounted)
docker compose restart backend

# Or rebuild
docker compose up -d --build backend
```

## 📝 Notes

- **Database**: Data persists in Docker volume `mysql-data`
- **Models**: Volume-mounted for easy updates tanpa rebuild
- **Redis**: Digunakan untuk caching KPI (TTL: 5 minutes)
- **Networks**: Semua services di `capstone-network` bridge
- **Health Checks**: MySQL dan Redis harus healthy sebelum backend start

## 🚨 Important Reminders

1. ✅ **SQL File**: Pastikan `docker_capstone.sql` ada dan valid
2. ✅ **ML Models**: Copy semua 4 model files ke `capstone-backend/src/assets/models/`
3. ✅ **Environment**: Edit `.env` jika perlu custom configuration
4. ✅ **Ports**: Default ports 3000, 8000, 3306, 6379 - pastikan tidak conflict
5. ✅ **Docker**: Minimal 4GB RAM allocated untuk Docker Desktop

## 🎯 Next Steps

Setelah deployment berhasil:

1. Test API endpoints di http://localhost:8000/docs
2. Akses frontend di http://localhost:3000
3. Verify KPI data loading
4. Test predictions dengan sample data
5. Monitor logs untuk errors
6. Setup monitoring/alerting (optional)

## 🆘 Getting Help

Jika ada masalah:

1. Check logs: `docker compose logs -f`
2. Verify all files exist
3. Check Docker Desktop resources
4. Verify ports tidak conflict
5. Try clean rebuild: `docker compose down -v && docker compose up --build -d`
