#!/bin/bash
# Run this script from the root of your Bird-Classifier repo.
# It reorganizes the repo into a clean, portfolio-ready structure.
# After running, review the changes with `git status`, then commit and push.

set -e
echo "🐦 Starting Bird-Classifier cleanup..."

# ── 1. Create new directory structure ─────────────────────────────────────────
mkdir -p src hpc results/logs data/sample

# ── 2. Move and rename core scripts ───────────────────────────────────────────
cp project_part_2/mobilenet_serial_test.py   src/classify_serial.py
cp project_part_2/mobilenet_batch_test.py    src/classify_batch.py
cp project_part_2/bonus/serial_vs_batch_groundtruth.py src/evaluate_accuracy.py

# ── 3. Move HPC job scripts ────────────────────────────────────────────────────
cp project_part_2/mobilenet_batch.sb  hpc/mobilenet_batch.sb
cp project_part_2/mobilenet_cpu.sb    hpc/mobilenet_cpu.sb

# ── 4. Move results ────────────────────────────────────────────────────────────
cp project_part_2/results/batch_vs_serial.png     results/batch_vs_serial.png
cp project_part_2/bonus/bird_eval_results.csv     results/bird_eval_results.csv
cp project_part_2/bonus/ground_truth.csv          results/ground_truth.csv
cp project_part_2/results/output_*.txt            results/logs/ 2>/dev/null || true

# ── 5. Copy a small sample of images (first 10) ───────────────────────────────
for f in $(ls project_part_2/Birds/*.jpg | head -10); do
    cp "$f" data/sample/
done

# ── 6. Rename the notebook ─────────────────────────────────────────────────────
if [ -f "project_part_2/PROJECT_Part2 (3) (1).ipynb" ]; then
    cp "project_part_2/PROJECT_Part2 (3) (1).ipynb" "bird_species_classifier.ipynb"
    echo "  ✅ Renamed notebook to bird_species_classifier.ipynb"
fi

# ── 7. Remove old messy directories ───────────────────────────────────────────
git rm -r --cached project_part_2/ 2>/dev/null || rm -rf project_part_2/
git rm -r --cached data/test/      2>/dev/null || rm -rf data/test/
echo "  ✅ Removed project_part_2/ and data/test/"

# ── 8. Add a .gitignore if not already solid ──────────────────────────────────
cat >> .gitignore << 'EOF'

# Python
__pycache__/
*.pyc
*.pyo
.env
venv/
myenv/

# TensorFlow / model weights
*.h5
*.pb
saved_model/

# Large data (don't commit full image datasets)
data/Birds/
data/test/

# OS
.DS_Store
EOF

echo "  ✅ Updated .gitignore"

# ── 9. Done ───────────────────────────────────────────────────────────────────
echo ""
echo "✅ Cleanup complete! Here's what to do next:"
echo ""
echo "  1. Review changes:         git status"
echo "  2. Stage everything:       git add -A"
echo "  3. Commit:                 git commit -m 'Reorganize repo into clean portfolio structure'"
echo "  4. Push:                   git push origin main"
echo ""
echo "Files now in place:"
echo "  src/classify_serial.py"
echo "  src/classify_batch.py"
echo "  src/evaluate_accuracy.py"
echo "  hpc/mobilenet_batch.sb"
echo "  hpc/mobilenet_cpu.sb"
echo "  results/batch_vs_serial.png"
echo "  results/bird_eval_results.csv"
echo "  results/logs/"
echo "  data/sample/  (10 example images)"
echo "  bird_species_classifier.ipynb"
echo "  README.md  <-- replace with the new one!"
