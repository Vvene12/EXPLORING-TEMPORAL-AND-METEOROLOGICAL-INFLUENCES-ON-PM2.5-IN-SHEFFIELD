## EXPLORING TEMPORAL AND METEOROLOGICAL INFLUENCES ON PM2.5 IN SHEFFIELD

### 🖋️Project Overview 
This project examines short-term and seasonal variability in PM2.5 concentrations in Sheffield using open air quality and meteorological data. The analysis focuses on identifying temporal patterns (hourly, daily, weekly), examining associations with local weather conditions, and assessing seasonal differences in PM2.5 levels. 


### ❓Research Questions
1. **RQ1:** How do PM2.5 concentrations vary across hourly, daily, and weekly time patterns?
2. **RQ2:** How are local meteorological variables associated with fluctuations in PM2.5 concentrations?
3. **RQ3:** How do seasonal differences influence short-term (daily) variability in PM2.5 concentrations?


### 📊 Key Findings

- **Key Finding 1 (Section 3.1, Figure 3.1):**  
  PM2.5 concentrations exhibit structured diurnal patterns, with clear differences between weekdays and weekends. Distinct morning and evening variations indicate activity-related temporal patterns rather than random fluctuations.

- **Key Finding 2 (Section 3.1, Figure 3.2):**  
  Wind speed shows the strongest association with PM2.5, characterised by a moderate negative correlation. This highlights wind speed as the most influential meteorological variable in explaining short-term changes in PM2.5 within the study area.

- **Key Finding 3 (Section 3.1, Figure 3.3):**  
  Seasonal differences have a significant impact on baseline PM2.5 concentrations, with higher typical levels observed in autumn and spring, and lower, more stable concentrations during summer.


### ⚙️Repository Structure
```text
├── README.md                      # Project overview and instructions
├── dataset/
│   ├── Openaq.csv                 # Raw PM2.5 data
│   └── Openmeteo.csv              # Raw meteorological data
├── scripts/
│   └── final_code.R               # Data cleaning, analysis, and visualisation code
├── figures/
│   └── figure3.1_RQ1.png          # Output figures used in the report
│   ├── figure3.2_RQ2.png
│   └── figure3.3_RQ3.png 
```


### 💻 Code

All analysis was conducted in **R** using **RStudio**. The main script (`final_code.R`) includes:
- Data cleaning and preprocessing  
- Dataset integration  
- Exploratory and statistical analysis  
- Visualisation of results  

The code is fully commented and structured to support reproducibility.


### ▶️ How to Run the Code
#### Requirements
- **R** (version 4.0 or above recommended)
- **RStudio** (recommended)

#### Steps
1. Download or clone this repository.
2. Ensure the following files are present in the `data/` folder:
   - `Openaq.csv`
   - `Openmeteo.csv`
3. Open RStudio and set the working directory to the repository root (the folder containing `README.md`).
4. Install required packages (first time only):
   ```r
   install.packages(c("dplyr", "readr", "lubridate", "stringr", "ggplot2", "reshape2"))


