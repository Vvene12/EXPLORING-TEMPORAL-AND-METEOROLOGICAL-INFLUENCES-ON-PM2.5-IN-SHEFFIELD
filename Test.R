# ============================================================
# IJC437 – Air Quality (Sheffield) | OpenAQ + OpenMeteo (2024)
# ============================================================

# 1) Libraries
library(dplyr)
library(readr)
library(lubridate)
library(stringr)
library(ggplot2)
library(reshape2)

# ------------------------------------------------------------
# 2) Load data
# ------------------------------------------------------------
pm_raw    <- read_csv("Openaq.csv")
meteo_raw <- read_csv("Openmeteo.csv")

# ------------------------------------------------------------
# 3) Clean OpenAQ (PM2.5)
# ------------------------------------------------------------
pm_clean <- pm_raw %>%
  mutate(
    pm25 = str_extract(`PM2.5 particulate matter (Hourly measured)`, "[0-9\\.]+") %>% as.numeric(),
    Date = as.Date(Date, format = "%d/%m/%Y"),
    Time = as.character(Time)
  ) %>%
  select(Date, Time, pm25)

# ------------------------------------------------------------
# 4) Clean OpenMeteo (Weather)
# ------------------------------------------------------------
meteo_clean <- meteo_raw %>%
  mutate(
    Date = as.Date(format(time, "%Y-%m-%d")),
    Time = format(time, "%H:%M:%S")
  ) %>%
  rename(
    temperature_2m        = `temperature_2m (°C)`,
    relative_humidity_2m  = `relative_humidity_2m (%)`,
    precipitation         = `precipitation (mm)`,
    surface_pressure      = `surface_pressure (hPa)`,
    wind_speed_10m        = `wind_speed_10m (km/h)`,
    wind_direction_10m    = `wind_direction_10m (°)`
  ) %>%
  select(Date, Time, temperature_2m, relative_humidity_2m,
         precipitation, surface_pressure, wind_speed_10m, wind_direction_10m)

# ------------------------------------------------------------
# 5) Merge datasets (hourly alignment)
# ------------------------------------------------------------
sheffield_data <- pm_clean %>%
  inner_join(meteo_clean, by = c("Date", "Time"))

# ------------------------------------------------------------
# 6) Missing values check + cleaning (KEEP THIS EXPLICIT)
# ------------------------------------------------------------
cat("\n--- Missing values summary (before cleaning) ---\n")
missing_summary <- colSums(is.na(sheffield_data))
print(missing_summary)

cat("\nTotal rows before cleaning:", nrow(sheffield_data), "\n")

# Remove rows with missing PM2.5 (small proportion, no imputation applied)
sheffield_data_clean <- sheffield_data %>%
  filter(!is.na(pm25))

cat("\n--- Missing values summary (after cleaning) ---\n")
print(colSums(is.na(sheffield_data_clean)))

cat("\nTotal rows after cleaning:", nrow(sheffield_data_clean), "\n")

# ------------------------------------------------------------
# 7) Feature engineering (Hour / DayOfWeek / Season / DayType)
# ------------------------------------------------------------
plot_data <- sheffield_data_clean %>%
  mutate(
    Hour = as.numeric(substr(Time, 1, 2)),
    DayOfWeek = wday(Date, label = TRUE, abbr = TRUE, week_start = 1),
    DayType = ifelse(DayOfWeek %in% c("Sat", "Sun"), "Weekend", "Weekday"),
    Month_Num = month(Date),
    Season = case_when(
      Month_Num %in% c(12, 1, 2)  ~ "Winter",
      Month_Num %in% c(3, 4, 5)   ~ "Spring",
      Month_Num %in% c(6, 7, 8)   ~ "Summer",
      Month_Num %in% c(9, 10, 11) ~ "Autumn"
    )
  )

plot_data$Season  <- factor(plot_data$Season,  levels = c("Spring", "Summer", "Autumn", "Winter"))
plot_data$DayType <- factor(plot_data$DayType, levels = c("Weekday", "Weekend"))

# ============================================================
# GRAPH 1 (RQ1): Weekday vs Weekend diurnal pattern (line plot)
# ============================================================
rq1_summary <- plot_data %>%
  group_by(DayType, Hour) %>%
  summarise(
    avg_pm25 = mean(pm25, na.rm = TRUE),
    p25 = quantile(pm25, 0.25, na.rm = TRUE),
    p75 = quantile(pm25, 0.75, na.rm = TRUE),
    .groups = "drop"
  )

p_rq1 <- ggplot(rq1_summary, aes(x = Hour)) +
  
  # Variability band (IQR)
  geom_ribbon(aes(ymin = p25, ymax = p75, fill = DayType),
              alpha = 0.25, colour = NA) +
  
  # Mean line
  geom_line(aes(y = avg_pm25, colour = DayType), linewidth = 1.2) +
  
  scale_x_continuous(breaks = seq(0, 23, 3)) +
  labs(
    title = "Hourly PM2.5 Patterns: Weekdays vs Weekends",
    subtitle = NULL,
    x = "Hour of Day (24h)",
    y = "PM2.5 (µg/m³)",
    color = "Day Type",
    fill = "Day Type"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    legend.position = "top"
  )

print(p_rq1)





# ============================================================
# GRAPH 2 (RQ2): Meteorological drivers (correlation heatmap)
# ============================================================
p_rq2 <- ggplot(melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white", linewidth = 0.4) +
  
  # Correlation values (de-emphasised)
  geom_text(
    aes(label = sprintf("%.2f", value)),
    size = 3.2,
    color = "grey20"
  ) +
  
  scale_fill_gradient2(
    low = "#2b8cbe",     # muted blue
    mid = "#f7f7f7",     # very light grey
    high = "#fbb4ae",    # muted red
    midpoint = 0,
    limits = c(-1, 1),
    name = "Pearson r"
  ) +
  
  coord_fixed() +
  labs(
    title = "Meteorological Drivers of PM2.5",
    x = NULL, y = NULL
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"),
    axis.text.y = element_text(color = "black"),
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold")
  )

print(p_rq2)


# ============================================================
# GRAPH 3 (RQ3): Seasonal baseline (boxplot)
# ============================================================
daily_pm25 <- plot_data %>%
  group_by(Date) %>%
  summarise(
    daily_pm25 = mean(pm25, na.rm = TRUE),
    Season = first(Season),
    .groups = "drop"
  )

p_rq3 <- ggplot(daily_pm25, aes(x = Season, y = daily_pm25, fill = Season)) +
  
  geom_boxplot(outlier.alpha = 0.15, width = 0.6) +
  
  scale_fill_manual(
    values = c(
      "Spring" = "#fbb4c4",  # pastel pink
      "Summer" = "#b2e2b4",  # pastel green
      "Autumn" = "#fdcc8a",  # pastel orange
      "Winter" = "#bdd7e7"   # pastel blue
    )
  ) +
  
  labs(
    title = "Seasonal Distribution of Daily Mean PM2.5 Levels",
    subtitle = "Boxplots summarising daily average concentrations by season",
    x = NULL,
    y = "Daily Mean PM2.5 (µg/m³)"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 10),
    axis.title = element_text(face = "bold"),
    legend.position = "none"
  )

print(p_rq3)

