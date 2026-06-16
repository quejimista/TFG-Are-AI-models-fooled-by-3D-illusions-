# ============================================================
#  Organize Minecraft results into category subfolders
#  Run from TFG root:
#    .\organize_minecraft.ps1
# ============================================================

# Category mapping based on illusion names
$categories = @{
    "converging_lines" = @(
        "converging_tunnel", "converging_tunnel_zoomed",
        "flat_grid", "infinite_grid", "grid_pattern", "grid_patter_offset",
        "grid_bias", "grid_bias_smooth", "grid_torch", "hallway", "TOP_BOTTOM_bias",
        "block_alignment", "anamorphic_rings"
    )
    "depth_ambiguity" = @(
        "neckers_cube", "schroeder_stairs", "schroeder_stairs_rotated",
        "schroeder_stairs_lantern", "rubins_vase"
    )
    "forced_perspective" = @(
        "depth_incongruence", "fake_block", "anamorphic_cube"
    )
    "impossible_objects" = @(
        "penrose_triangle", "penrose_triangle_adapted", "penrose_triangle_zoomed",
        "penrose_stairs", "escher_waterfall", "escher_waterfall_2", "escher_waterfall_3",
        "escher_cube", "blivet_trident"
    )
    "shading" = @(
        "dragon", "dragon_zoom", "hollow_face", "zebra_crossing", "ladder",
        "light_from_above_day", "light_from_above_day2",
        "light_from_above_night", "light_from_above_night2",
        "concave_convex_cube", "concave_convex_cube_zoomed",
        "concave_convex_furnace", "concave_convex_furnace_zoomed"
    )
}

$targets = @(
    @{ base = "results\depth_map_comparisons\minecraft"; prefix = "cmp_" },
    @{ base = "results\depth_map_comparisons\midas\minecraft"; prefix = "cmp_" },
    @{ base = "results\roi_analysis\minecraft"; prefix = "analisis_cmp_" }
)

foreach ($target in $targets) {
    $base = $target.base
    $prefix = $target.prefix
    Write-Host "`nProcessing: $base" -ForegroundColor Cyan

    foreach ($cat in $categories.Keys) {
        $dst = Join-Path $base $cat
        New-Item -ItemType Directory -Path $dst -Force | Out-Null

        foreach ($name in $categories[$cat]) {
            # Try both .png and .PNG and .jpg
            foreach ($ext in @(".png", ".PNG", ".jpg")) {
                $filename = "${prefix}${name}${ext}"
                $src = Join-Path $base $filename
                if (Test-Path $src) {
                    Move-Item $src $dst -Force
                    Write-Host "  $filename -> $cat"
                }
            }
        }
    }

    # Report anything left unmoved (excluding csv and subfolders)
    $remaining = Get-ChildItem $base -File
    if ($remaining.Count -gt 0) {
        Write-Host "  Unmoved files:" -ForegroundColor Yellow
        $remaining | ForEach-Object { Write-Host "    $($_.Name)" -ForegroundColor Yellow }
    }
}

Write-Host "`nDone." -ForegroundColor Green
