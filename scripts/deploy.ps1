# Deploy Script for Windows PowerShell
# Capstone Project Docker Deployment

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Capstone Docker Deployment" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if file exists
function Test-FileExists {
    param($path, $description)
    if (Test-Path $path) {
        Write-Host "[OK] $description found: $path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[ERROR] $description NOT found: $path" -ForegroundColor Red
        return $false
    }
}

# Pre-deployment checks
Write-Host "Running pre-deployment checks..." -ForegroundColor Yellow
Write-Host ""

$allChecksPass = $true

# Check SQL file
$allChecksPass = $allChecksPass -and (Test-FileExists "docker_capstone.sql" "SQL Database File")

# Check ML Models
Write-Host ""
Write-Host "Checking ML Models..." -ForegroundColor Yellow
$modelsPath = "capstone-backend\src\assets\models"
$allChecksPass = $allChecksPass -and (Test-FileExists "$modelsPath\dropout_model.pkl" "Dropout Model")
$allChecksPass = $allChecksPass -and (Test-FileExists "$modelsPath\final_grade_model.pkl" "Final Result Model")
$allChecksPass = $allChecksPass -and (Test-FileExists "$modelsPath\label_encoder_dropout.pkl" "Label Encoder Dropout")
$allChecksPass = $allChecksPass -and (Test-FileExists "$modelsPath\label_encoder_finalgrade.pkl" "Label Encoder Final Result")

# Check configuration files
Write-Host ""
Write-Host "Checking configuration files..." -ForegroundColor Yellow
$allChecksPass = $allChecksPass -and (Test-FileExists "docker-compose.yml" "Docker Compose")
$allChecksPass = $allChecksPass -and (Test-FileExists ".env" "Environment File")
$allChecksPass = $allChecksPass -and (Test-FileExists "capstone-backend\Dockerfile" "Backend Dockerfile")
$allChecksPass = $allChecksPass -and (Test-FileExists "capstone-project-frontend\Dockerfile" "Frontend Dockerfile")

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan

if (-not $allChecksPass) {
    Write-Host ""
    Write-Host "Pre-deployment checks FAILED!" -ForegroundColor Red
    Write-Host "Please fix the errors above before deploying." -ForegroundColor Red
    Write-Host ""
    Write-Host "Missing ML models? Copy them to: $modelsPath" -ForegroundColor Yellow
    Write-Host "Missing SQL file? Ensure docker_capstone.sql is in root directory" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "All pre-deployment checks PASSED!" -ForegroundColor Green
Write-Host ""

# Ask for confirmation
$response = Read-Host "Do you want to proceed with deployment? (y/n)"
if ($response -ne "y") {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting deployment..." -ForegroundColor Cyan
Write-Host ""

# Stop existing containers
Write-Host "Stopping existing containers..." -ForegroundColor Yellow
docker compose down

Write-Host ""
Write-Host "Building and starting containers..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Yellow
Write-Host ""

# Build and start
docker compose up --build -d

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Deployment FAILED!" -ForegroundColor Red
    Write-Host "Check logs with: docker compose logs" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Waiting for services to be healthy..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check container status
Write-Host ""
Write-Host "Container Status:" -ForegroundColor Cyan
docker compose ps

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Deployment completed!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access your application:" -ForegroundColor Cyan
Write-Host "  - Frontend:  http://localhost:3000" -ForegroundColor White
Write-Host "  - Backend:   http://localhost:8000" -ForegroundColor White
Write-Host "  - API Docs:  http://localhost:8000/docs" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "  - View logs:     docker compose logs -f" -ForegroundColor White
Write-Host "  - Stop all:      docker compose stop" -ForegroundColor White
Write-Host "  - Start all:     docker compose start" -ForegroundColor White
Write-Host "  - Clean up:      docker compose down -v" -ForegroundColor White
Write-Host ""

# Test backend health
Write-Host "Testing backend health..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Backend is healthy!" -ForegroundColor Green
    }
} catch {
    Write-Host "[WARNING] Backend health check failed. It may still be starting up." -ForegroundColor Yellow
    Write-Host "Check logs with: docker compose logs -f backend" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Deployment script finished!" -ForegroundColor Green
