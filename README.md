# Exploratory Data Analysis in R — Multi-Dataset Study

A collection of four independent exploratory data analysis (EDA) projects written in R, covering environmental science, materials science, clinical health data, and food quality assessment.

Built as part of the MSc Data Science programme at Liverpool John Moores University.

---

## Projects Overview

| Script | Dataset | Domain |
|---|---|---|
| `el_nino_analysis.R` | TAO Buoy Observations | Environmental / Climate Science |
| `glass_identification_analysis.R` | UCI Glass Identification | Materials Science |
| `cleveland_heart_disease_analysis.R` | Cleveland Heart Disease | Clinical Health |
| `wine_quality_analysis.R` | UCI Wine Quality (Red & White) | Food Science |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| R | Primary analysis language |
| ggplot2 | Data visualisation |
| dplyr | Data manipulation |
| GGally (ggpairs) | Multivariate pair plots |
| maps | Geospatial plotting |

---

## Project Summaries

### 1. El Niño — TAO Buoy Observations (`el_nino_analysis.R`)

Exploratory analysis of ocean and atmospheric measurements from the TAO (Tropical Atmosphere Ocean) buoy network across the tropical Pacific.

**Key analyses:**
- Spatial distribution of buoy positions plotted on a Pacific map
- Air temperature variation across latitude and longitude bands (boxplots)
- Sea surface temperature heatmap by region
- Seasonal cycle of air and sea surface temperature in the El Niño 3.4 region
- Long-term sea surface temperature trends over time

**Key findings:** Temperatures are highest in the western Pacific and decrease eastward. Both air and sea surface temperatures follow a clear annual cycle in the equatorial region, peaking around April–May.

---

### 2. Glass Identification (`glass_identification_analysis.R`)

EDA of the UCI Glass Identification dataset, exploring how chemical composition relates to glass type and refractive index.

**Key analyses:**
- Distribution of glass types (class imbalance check)
- Refractive index comparison across glass types (boxplots)
- Mean chemical composition by glass type (grouped bar chart)
- Correlation heatmap of all chemical attributes
- Silicon and Calcium vs Refractive Index scatter plot by glass type

**Key findings:** Calcium shows a strong positive relationship with refractive index while silicon shows a negative one. Together, these two oxides provide the clearest separation between glass types.

---

### 3. Cleveland Heart Disease (`cleveland_heart_disease_analysis.R`)

EDA of the Cleveland Heart Disease dataset, examining clinical and demographic factors associated with heart disease diagnosis.

**Key analyses:**
- Heart disease prevalence by sex (stacked percentage bar chart)
- Correlation matrix of clinical variables (heatmap)
- ST depression vs disease severity by sex (scatter with trend lines)
- Multivariate pair plot of key predictors: age, thalassemia, ST depression
- Maximum heart rate achieved by disease status (boxplot)

**Key findings:** Heart disease is more prevalent in male patients. ST depression during exercise (oldpeak) and number of major vessels (ca) show the strongest associations with disease severity. Patients with disease achieve lower maximum heart rates.

---

### 4. Wine Quality (`wine_quality_analysis.R`)

EDA of the UCI Wine Quality dataset (red and white wines), exploring the relationship between chemical properties and human-assigned quality scores.

**Key analyses:**
- Distribution of quality scores by wine type (grouped bar chart)
- Average chemical profile across quality scores
- Correlation matrix of chemical properties and quality
- Alcohol content across quality scores by wine type (boxplots)
- Distribution of alcohol content by quality (violin plots)

**Key findings:** Alcohol content is the strongest single predictor of wine quality. Higher quality wines consistently show higher alcohol, lower density, and lower volatile acidity. Quality scores cluster around 5–6, with extreme ratings being rare.

---

## Setup & Usage

### Requirements

Install the required R packages:

```r
install.packages(c("ggplot2", "dplyr", "GGally", "maps", "reshape2"))
```

### Datasets

Each script reads from the following publicly available datasets — download and place in the same directory as the script:

| Script | Dataset File(s) | Source |
|---|---|---|
| `el_nino_analysis.R` | `tao-all2.dat.gz`, `tao-all2.col` | [UCI ML Repository](https://archive.ics.uci.edu/dataset/122/el+nino) |
| `glass_identification_analysis.R` | `glass.data` | [UCI ML Repository](https://archive.ics.uci.edu/dataset/42/glass+identification) |
| `cleveland_heart_disease_analysis.R` | `processed.cleveland.data` | [UCI ML Repository](https://archive.ics.uci.edu/dataset/45/heart+disease) |
| `wine_quality_analysis.R` | `winequality-red.csv`, `winequality-white.csv` | [UCI ML Repository](https://archive.ics.uci.edu/dataset/186/wine+quality) |

### Running a script

Open R or RStudio, set your working directory to where the data files are, then run:

```r
source("el_nino_analysis.R")
```

---

## What I'd Improve

- Convert scripts to **R Markdown (.Rmd)** to produce self-contained HTML reports with embedded outputs
- Add **statistical testing** (e.g. Wilcoxon tests, ANOVA) alongside visualisations to formally validate observed patterns
- Apply **PCA** to the glass and wine datasets to explore multivariate structure beyond pairwise correlations
- Build an **interactive dashboard** using Shiny for the heart disease or El Niño dataset

---

## Author

**Amiola Onabanjo**
MSc Data Science — Liverpool John Moores University
[GitHub](https://github.com/onabanjoamiola-ux)
