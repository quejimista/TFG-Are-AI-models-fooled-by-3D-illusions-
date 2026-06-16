# ============================================================
#  Organize psychophysics depth map comparisons into subfolders
#  Run from TFG root:
#    .\organize_depthmaps.ps1
# ============================================================

$base = "results\depth_map_comparisons\psychophysics"

$experiments = @(
    "angle",
    "blur_bias",
    "contrast",
    "ebbinghaus",
    "face_shading",
    "figure_ground",
    "horizon",
    "kanizsa",
    "occlusion",
    "ponzo",
    "shadow_gap",
    "size",
    "texture_slant",
    "ypos"
)

foreach ($exp in $experiments) {
    $dst = Join-Path $base $exp
    if (-not (Test-Path $dst)) {
        New-Item -ItemType Directory -Path $dst | Out-Null
    }
    $files = Get-ChildItem $base -Filter "cmp_${exp}_*.png" -File
    if ($files.Count -gt 0) {
        $files | Move-Item -Destination $dst -Force
        Write-Host "  $exp : $($files.Count) files moved"
    } else {
        Write-Host "  $exp : no files found" -ForegroundColor Yellow
    }
}

# Loose step_NN files -> size_vs_position
$looseDst = Join-Path $base "size_vs_position"
if (-not (Test-Path $looseDst)) {
    New-Item -ItemType Directory -Path $looseDst | Out-Null
}
$looseFiles = Get-ChildItem $base -Filter "cmp_step_*.png" -File
if ($looseFiles.Count -gt 0) {
    $looseFiles | Move-Item -Destination $looseDst -Force
    Write-Host "  size_vs_position: $($looseFiles.Count) files moved" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Get-ChildItem $base -Directory | ForEach-Object {
    $count = (Get-ChildItem $_.FullName -File).Count
    Write-Host "  $($_.Name): $count files"
}
