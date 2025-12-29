# Quick Commands for Docker Compose Management

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Capstone Docker Management" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Select an action:" -ForegroundColor Yellow
Write-Host "1. Start all services" -ForegroundColor White
Write-Host "2. Stop all services" -ForegroundColor White
Write-Host "3. Restart all services" -ForegroundColor White
Write-Host "4. View logs (all)" -ForegroundColor White
Write-Host "5. View backend logs" -ForegroundColor White
Write-Host "6. View frontend logs" -ForegroundColor White
Write-Host "7. View MySQL logs" -ForegroundColor White
Write-Host "8. Check container status" -ForegroundColor White
Write-Host "9. Test backend health" -ForegroundColor White
Write-Host "10. Test model status" -ForegroundColor White
Write-Host "11. Open frontend in browser" -ForegroundColor White
Write-Host "12. Open API docs in browser" -ForegroundColor White
Write-Host "13. Clean up (remove containers)" -ForegroundColor White
Write-Host "14. Full clean (remove containers + volumes)" -ForegroundColor White
Write-Host "0. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (0-14)"

switch ($choice) {
    "1" {
        Write-Host "Starting services..." -ForegroundColor Yellow
        docker compose start
    }
    "2" {
        Write-Host "Stopping services..." -ForegroundColor Yellow
        docker compose stop
    }
    "3" {
        Write-Host "Restarting services..." -ForegroundColor Yellow
        docker compose restart
    }
    "4" {
        Write-Host "Showing logs (Ctrl+C to exit)..." -ForegroundColor Yellow
        docker compose logs -f
    }
    "5" {
        Write-Host "Showing backend logs (Ctrl+C to exit)..." -ForegroundColor Yellow
        docker compose logs -f backend
    }
    "6" {
        Write-Host "Showing frontend logs (Ctrl+C to exit)..." -ForegroundColor Yellow
        docker compose logs -f frontend
    }
    "7" {
        Write-Host "Showing MySQL logs (Ctrl+C to exit)..." -ForegroundColor Yellow
        docker compose logs -f mysql
    }
    "8" {
        Write-Host "Container status:" -ForegroundColor Yellow
        docker compose ps
    }
    "9" {
        Write-Host "Testing backend health..." -ForegroundColor Yellow
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8000/health" -UseBasicParsing
            Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
            Write-Host "Response: $($response.Content)" -ForegroundColor Green
        } catch {
            Write-Host "Error: $_" -ForegroundColor Red
        }
    }
    "10" {
        Write-Host "Testing model status..." -ForegroundColor Yellow
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8000/api/models/status" -UseBasicParsing
            Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
            Write-Host "Response: $($response.Content)" -ForegroundColor Green
        } catch {
            Write-Host "Error: $_" -ForegroundColor Red
        }
    }
    "11" {
        Write-Host "Opening frontend..." -ForegroundColor Yellow
        Start-Process "http://localhost:3000"
    }
    "12" {
        Write-Host "Opening API docs..." -ForegroundColor Yellow
        Start-Process "http://localhost:8000/docs"
    }
    "13" {
        Write-Host "Removing containers..." -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (y/n)"
        if ($confirm -eq "y") {
            docker compose down
            Write-Host "Containers removed." -ForegroundColor Green
        }
    }
    "14" {
        Write-Host "WARNING: This will remove all data including database!" -ForegroundColor Red
        $confirm = Read-Host "Are you sure? (y/n)"
        if ($confirm -eq "y") {
            docker compose down -v
            Write-Host "Containers and volumes removed." -ForegroundColor Green
        }
    }
    "0" {
        Write-Host "Goodbye!" -ForegroundColor Cyan
        exit 0
    }
    default {
        Write-Host "Invalid choice!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
