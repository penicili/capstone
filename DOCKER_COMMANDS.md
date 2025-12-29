# 🚀 Quick Reference - Docker Compose Commands

## 📋 Essential Commands

### Start & Stop
```bash
# Start all services
docker compose up -d

# Start with rebuild
docker compose up --build -d

# Stop all services
docker compose stop

# Start stopped services
docker compose start

# Restart all
docker compose restart

# Restart specific service
docker compose restart backend
```

### View & Monitor
```bash
# Check status
docker compose ps

# View all logs
docker compose logs -f

# View specific service logs
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f mysql
docker compose logs -f redis

# Last 100 lines
docker compose logs --tail=100 backend
```

### Clean Up
```bash
# Stop and remove containers
docker compose down

# Remove containers + volumes (⚠️ deletes database)
docker compose down -v

# Remove everything including images
docker compose down -v --rmi all
```

## 🔧 Troubleshooting Commands

### Database
```bash
# Connect to MySQL
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi

# Check tables
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi -e "SHOW TABLES;"

# Count records
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi -e "SELECT COUNT(*) FROM studentinfo;"

# Backup database
docker exec capstone-mysql mysqldump -u capstone_user -pcapstone123 capstone_kpi > backup.sql

# Restore database
docker exec -i capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi < backup.sql
```

### Backend
```bash
# Check models in container
docker exec capstone-backend ls -la /app/src/assets/models/

# Check environment variables
docker exec capstone-backend env | grep DB_

# Test Python version
docker exec capstone-backend python --version

# Interactive shell
docker exec -it capstone-backend /bin/sh
```

### Network
```bash
# Test backend from host
curl http://localhost:8000/health
curl http://localhost:8000/api/models/status
curl http://localhost:8000/api/kpi/overview

# Test from another container
docker exec capstone-frontend wget -qO- http://backend:8000/health

# Check network
docker network inspect project_capstone-network
```

## 🎯 Quick Tests

### PowerShell (Windows)
```powershell
# Health check
Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing

# Model status
Invoke-WebRequest -Uri "http://localhost:8000/api/models/status" -UseBasicParsing

# KPI data
Invoke-WebRequest -Uri "http://localhost:8000/api/kpi/overview" -UseBasicParsing
```

### curl (Linux/Mac/Git Bash)
```bash
# Health check
curl http://localhost:8000/health

# Model status  
curl http://localhost:8000/api/models/status

# KPI data
curl http://localhost:8000/api/kpi/overview
```

## 📊 Monitoring

### Resource Usage
```bash
# CPU & Memory usage
docker stats

# Specific container
docker stats capstone-backend

# Disk usage
docker system df
```

### Inspect Containers
```bash
# Full info
docker inspect capstone-backend

# IP address
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' capstone-backend

# Health status
docker inspect --format='{{.State.Health.Status}}' capstone-backend
```

## 🔄 Update Workflows

### Update Backend Code
```bash
# 1. Make changes to code
# 2. Rebuild and restart
docker compose up -d --build backend
```

### Update Frontend
```bash
docker compose up -d --build frontend
```

### Update Models (without rebuild)
```bash
# Copy new models
cp /path/to/new/models/*.pkl capstone-backend/src/assets/models/

# Restart backend (models are volume-mounted)
docker compose restart backend
```

### Update Database Schema
```bash
# 1. Create migration SQL file
# 2. Apply migration
docker exec -i capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi < migration.sql

# Or connect and run manually
docker exec -it capstone-mysql mysql -u capstone_user -pcapstone123 capstone_kpi
```

## 🚨 Emergency Commands

### Force Rebuild Everything
```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

### Reset Database Only
```bash
docker compose stop mysql
docker volume rm project_mysql-data
docker compose up -d mysql
# Wait for initialization
docker compose logs -f mysql
```

### Clear Docker Cache
```bash
docker system prune -a
docker volume prune
```

### Fix Permissions Issues
```bash
# Backend logs
docker exec -u root capstone-backend chown -R appuser:appuser /app/src/logs

# Models
docker exec -u root capstone-backend chown -R appuser:appuser /app/src/assets/models
```

## 📱 Access URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **API Redoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health
- **Model Status**: http://localhost:8000/api/models/status

## 📝 Helper Scripts

### Windows PowerShell
```powershell
# Full deployment with checks
.\deploy.ps1

# Management menu
.\manage.ps1
```

## 🆘 Common Issues

| Issue | Solution |
|-------|----------|
| Port already in use | Change port in `.env` file |
| Models not found | Copy to `capstone-backend/src/assets/models/` |
| MySQL won't start | Check SQL file exists: `docker_capstone.sql` |
| Backend health check fails | Wait 30-60s, check logs |
| Frontend can't connect | Verify backend is running |
| Permission denied | Use `docker exec -u root` |

## 💡 Pro Tips

1. **Always check logs first**: `docker compose logs -f`
2. **Wait for health checks**: Services have dependencies
3. **Use volume mounts**: Update models without rebuild
4. **Backup before reset**: Export database first
5. **Monitor resources**: Use `docker stats`
6. **Clean regularly**: `docker system prune`

---

**Need help?** Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed guide.
