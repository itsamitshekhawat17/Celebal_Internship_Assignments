# Celebal Internship Assignments

A curated collection of data engineering and analytics assignments completed during the Celebal (CEI) internship. Each week's folder contains notebooks, source data, and supporting files demonstrating cleaning, transformation, SQL, and analytical techniques.

---

## Project Overview

- **Purpose:** Showcase progressive weekly assignments covering data cleaning, ETL, SQL analytics, cohort analysis, and small CLI/reporting demos.
- **Audience:** Students, reviewers, or hiring managers who want to evaluate data engineering and analytics skills.

---

## Contents & Structure

Top-level folders correspond to weekly assignments. Notable contents:

- [Celebal(CEI)_week1_assignment](Celebal(CEI)_week1_assignment) — initial data cleaning and exploration.
- [Celebal(CEI)_week2_assignment](Celebal(CEI)_week2_assignment) — SQL practice and analysis.
- [Celebal(CEI)_week3_assignment](Celebal(CEI)_week3_assignment)
- [Celebal(CEI)_week4_assignment](Celebal(CEI)_week4_assignment)
- [Celebal(CEI)_week5_assignment](Celebal(CEI)_week5_assignment)
- [Celebal(CEI)_week6_assignment](Celebal(CEI)_week6_assignment)
- [Celebal(CEI)_week7_assignment](Celebal(CEI)_week7_assignment)
- [Celebal(CEI)_week8_assignment](Celebal(CEI)_week8_assignment) — more complete ETL pipeline examples and notebooks.

Each folder typically includes:

- `notebook/` or `notebooks/` — Jupyter notebooks with the solution.
- `data/` — source CSVs used in the assignment.
- `requirements.txt` — Python dependencies for that week (when present).

---

## Quickstart

1. Open the weekly notebook you want to run (for example the week 8 data generation: [Celebal(CEI)_week8_assignment/notebooks/01_generate_data.ipynb](Celebal(CEI)_week8_assignment/notebooks/01_generate_data.ipynb)).

2. Create and activate a virtual environment, then install dependencies from that week's `requirements.txt`:

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

# Install dependencies for a specific week (replace path as needed)
pip install -r "Celebal(CEI)_week8_assignment/requirements.txt"
```

3. Launch Jupyter Lab / Notebook and run cells interactively:

```bash
pip install jupyterlab
jupyter lab
```

---

## Notes on Notebooks

- Notebooks are self-contained with explanatory markdown cells and code. Follow the order when multiple notebooks are provided (e.g., data generation → cleaning → load → analytics).
- When large data files are present, notebooks may save processed outputs under each week's `output/` or `Output/` directory.

---

## Contributing & Extending

- To add improvements, create a new branch and open a PR with the change and a short description.
- If you update or add dependencies, update the corresponding `requirements.txt` in that week's folder.

---

## License

This repository is intended for learning and portfolio use. If you want to reuse code in other projects, please credit the author.

---

## Contact

For questions or feedback, open an issue in this workspace or contact the repository owner.

---

Happy exploring! 🚀
