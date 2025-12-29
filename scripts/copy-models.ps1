# Script untuk copy ML models ke Backend directory
# Run this BEFORE deployment

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Copy ML Models to Backend" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory and navigate to project root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
Set-Location $projectRoot

$sourceDir = "assets"
$targetDir = "capstone-backend\src\assets\models"

# Create target directory if not exists
if (-not (Test-Path $targetDir)) {
    Write-Host "Creating models directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Write-Host "Source directory: $sourceDir" -ForegroundColor Cyan
Write-Host "Target directory: $targetDir" -ForegroundColor Cyan
Write-Host ""

# Models mapping (source filename -> target filename)
$models = @{
    "dropout_modelv2.pkl" = "dropout_model.pkl"
    "final_grade_modelv2.pkl" = "final_grade_model.pkl"
    "label_encoder_dropoutv2.pkl" = "label_encoder_dropout.pkl"
    "final_grade_encodersv2.pkl" = "label_encoder_finalgrade.pkl"
}

$allSuccess = $true

foreach ($source in $models.Keys) {
    $target = $models[$source]
    $sourcePath = Join-Path $sourceDir $source
    $targetPath = Join-Path $targetDir $target
    
    if (Test-Path $sourcePath) {
        Write-Host "[COPY] $sourcePath -> $target" -ForegroundColor Green
        Copy-Item -Path $sourcePath -Destination $targetPath -Force
        
        # Verify copied
        if (Test-Path $targetPath) {
            $size = (Get-Item $targetPath).Length
            $sizeKB = [math]::Round($size / 1KB, 2)
            Write-Host "  [OK] Copied successfully ($sizeKB KB)" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Failed to copy!" -ForegroundColor Red
            $allSuccess = $false
        }
    } else {
        Write-Host "[SKIP] $sourcePath not found" -ForegroundColor Yellow
        $allSuccess = $false
    }
    Write-Host ""
}

Write-Host "================================" -ForegroundColor Cyan

if ($allSuccess) {
    Write-Host "All models copied successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifying models in target directory..." -ForegroundColor Yellow
    Get-ChildItem -Path $targetDir -Filter "*.pkl" | ForEach-Object {
        $sizeKB = [math]::Round($_.Length / 1KB, 2)
        Write-Host "  [OK] $($_.Name) ($sizeKB KB)" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Ready for deployment! Run: .\deploy.ps1" -ForegroundColor Cyan
} else {
    Write-Host "Some models are missing!" -ForegroundColor Red
    Write-Host "Please ensure all model files exist in the root directory:" -ForegroundColor Yellow
    foreach ($source in $models.Keys) {
        Write-Host "  - $source" -ForegroundColor Yellow
    }
}

Write-Host ""
