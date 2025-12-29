# Checklist Sebelum Deploy

## ✅ Files yang Harus Ada

### 1. SQL Database File
- [ ] `docker_capstone.sql` ada di root directory
- [ ] File valid dan bisa diimport ke MySQL

### 2. ML Models
- [ ] `capstone-backend/src/assets/models/dropout_model.pkl`
- [ ] `capstone-backend/src/assets/models/final_grade_model.pkl`
- [ ] `capstone-backend/src/assets/models/label_encoder_dropout.pkl`
- [ ] `capstone-backend/src/assets/models/label_encoder_finalgrade.pkl`

### 3. Configuration Files
- [x] `docker-compose.yml` ✅ Created
- [x] `.env` ✅ Created
- [x] `capstone-backend/Dockerfile` ✅ Updated
- [x] `capstone-project-frontend/Dockerfile` ✅ Updated

### 4. Application Files
- [ ] `capstone-backend/requirements.txt` exists
- [ ] `capstone-backend/src/app.py` exists
- [ ] `capstone-project-frontend/package.json` exists

## 🚀 Langkah Deploy

### Step 1: Copy ML Models
```bash
# Pastikan models ada di folder ini:
ls capstone-backend/src/assets/models/

# Jika belum ada, copy dari backup/training results
cp /path/to/models/*.pkl capstone-backend/src/assets/models/
```

### Step 2: Verify SQL File
```bash
# Check SQL file exists
ls -la docker_capstone.sql

# Verify file size (should be > 0 bytes)
du -h docker_capstone.sql
```

### Step 3: Build & Start
```bash
# Build dan start semua containers
docker compose up --build -d

# Monitor startup logs
docker compose logs -f
```

### Step 4: Verify Services
```bash
# Check all containers running
docker compose ps

# Test backend health
curl http://localhost:8000/health

# Test backend models
curl http://localhost:8000/api/models/status

# Open browser
# Frontend: http://localhost:3000
# API Docs: http://localhost:8000/docs
```

## 🔍 Verification Checklist

- [ ] MySQL container running dan healthy
- [ ] Redis container running dan healthy
- [ ] Backend container running dan healthy
- [ ] Frontend container running
- [ ] Database tables created (check dengan MySQL client)
- [ ] Backend models loaded (check `/api/models/status`)
- [ ] KPI API returns data
- [ ] Frontend accessible di browser
- [ ] Predictions working

## 🐛 Common Issues & Solutions

### Issue 1: Models Not Found
```bash
# Solution: Copy models ke folder yang benar
cp -r /path/to/models/* capstone-backend/src/assets/models/
docker compose restart backend
```

### Issue 2: SQL File Not Loading
```bash
# Solution: Check SQL file dan recreate MySQL
docker compose down -v
ls -la docker_capstone.sql  # verify exists
docker compose up -d mysql
docker compose logs -f mysql
```

### Issue 3: Backend Connection Error
```bash
# Solution: Wait for MySQL to be ready
docker compose logs mysql  # check for "ready for connections"
docker compose restart backend
```

### Issue 4: Port Already in Use
```bash
# Solution: Change ports in .env
# Edit .env file:
BACKEND_PORT=8001
FRONTEND_PORT=3001
DB_PORT=3307

# Restart
docker compose down
docker compose up -d
```

## 📊 Resource Requirements

Minimal requirements:
- RAM: 4GB untuk Docker Desktop
- Disk: 2GB free space
- CPU: 2 cores

## 🎯 Success Indicators

Deployment berhasil jika:
1. ✅ Semua 4 containers status "Up" dan "healthy"
2. ✅ `curl http://localhost:8000/health` returns `{"status":"healthy"}`
3. ✅ `http://localhost:8000/docs` shows API documentation
4. ✅ `http://localhost:3000` shows frontend dashboard
5. ✅ KPI data displayed di dashboard
6. ✅ Predictions working

## 📝 Next Actions

Setelah deployment berhasil:
1. Test semua API endpoints
2. Verify data accuracy di dashboard
3. Test prediction dengan sample data
4. Setup monitoring (optional)
5. Create database backup
6. Document any custom configurations

---

**Tanggal Deploy**: ___________
**Deployed By**: ___________
**Environment**: Development / Production
**Notes**: ___________
