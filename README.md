# Intro-to-Data-Science

## Project Overview 
This project investigates short-term and seasonal variability in PM2.5 concentrations in Sheffield using open air quality and meteorological data. The analysis focuses on identifying temporal patterns (hourly, daily, weekly), examining associations with local weather conditions, and assessing seasonal differences in PM2.5 levels. The project was completed as part of the IJC437 Introduction to Data Science module.

## Research Questions
RQ1: How do PM2.5 concentrations vary across hourly, daily, and weekly time patterns? 
RQ2: How are local meteorological variables associated with fluctuations in PM2.5 concentrations? 
RQ3: How do seasonal differences influence short-term (hourly and daily) variability in PM2.5 concentrations?

## Key Findings
Key finding 1:
PM2.5 concentrations follow structured diurnal patterns, with clear differences between weekdays and weekends. The high levels of PM2.5 in the morning and evening hours point to the influence of activity-related temporal patterns rather than random variation.
Key finding 2:
Wind speed has the strongest association with PM2.5 concentrations among all the meteorological variables analysed. This is characterised by a moderate negative correlation, that indicates periods of stronger winds tend to coincide with reduced PM2.5 concentrations.
Key finding 3:
Seasonal changes have a significant impact on baseline PM2.5 concentrations. Autumn and spring are characterised by higher average levels and more frequent high-pollution days, while summer has lower and more constant PM2.5 levels.

## Repository Structure
```text
├── README.md                # Project overview and instructions
├── data/
│   ├── Openaq.csv           # Raw PM2.5 data
│   ├── Openmeteo.csv        # Raw meteorological data
│   └── sheffield_data.csv  # Cleaned and merged dataset
├── scripts/
│   └── analysis.R          # Data cleaning, analysis, and visualisation code
├── figures/
│   └── *.png               # Output figures used in the report
```


## Code
All analysis was conducted in R using RStudio.
The main script (analysis.R) includes:
Data cleaning and preprocessing
Dataset integration
Exploratory and statistical analysis
Visualisation of results
The code is fully commented and structured to support reproducibility.





