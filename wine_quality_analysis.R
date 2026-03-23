library(ggplot2)

#========================================================
# 1) READ + PREP DATA
#========================================================

red <- read.csv("winequality-red.csv", sep = ";", stringsAsFactors = FALSE)
white <- read.csv("winequality-white.csv", sep = ";", stringsAsFactors = FALSE)

red$type <- "Red"
white$type <- "White"

wine <- rbind(red, white)

wine$type <- factor(wine$type, levels = c("Red", "White"))

# Treat quality as ordered factor for class-style plots
wine$quality_f <- factor(
  wine$quality,
  levels = sort(unique(wine$quality)),
  ordered = TRUE
)

#========================================================
# PLOT 1: Distribution of wine classes (quality)
#========================================================
ggplot(wine, aes(x = quality_f, fill = type)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Distribution of Wine Quality Scores by Type",
    x = "Quality Score",
    y = "Count",
    fill = "Wine Type"
  ) +
  theme_minimal()

#========================================================
# PLOT 2: Average chemical profile by quality
#========================================================
chem_cols <- setdiff(names(wine), c("quality", "quality_f", "type"))

mean_by_quality <- aggregate(
  wine[chem_cols],
  list(quality = wine$quality),
  mean,
  na.rm = TRUE
)

mean_long <- stack(mean_by_quality[chem_cols])
mean_long$quality <- rep(mean_by_quality$quality, times = length(chem_cols))
names(mean_long) <- c("mean_value", "chemical", "quality")

ggplot(mean_long, aes(x = chemical, y = mean_value, fill = factor(quality))) +
  geom_col(position = "dodge") +
  labs(
    title = "Average Chemical Profile by Wine Quality",
    x = "Chemical Property",
    y = "Mean Value",
    fill = "Quality"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#========================================================
# PLOT 3: Correlation Matrix of Wine Chemical Properties
#========================================================
# Select numeric columns only (exclude the factor columns)
num_cols <- sapply(wine, is.numeric)
wine_num <- wine[, num_cols]

cor_mat <- cor(wine_num, use = "pairwise.complete.obs")
cor_df <- as.data.frame(as.table(cor_mat))
names(cor_df) <- c("Var1", "Var2", "Correlation")

ggplot(cor_df, aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "black") +
  geom_text(aes(label = round(Correlation, 2)), size = 2.6) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  labs(
    title = "Correlation Matrix of Wine Chemical Properties",
    x = "",
    y = "",
    fill = "Corr"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#========================================================
# PLOT 4: Alcohol content by wine class (boxplot)
#========================================================
ggplot(wine, aes(x = quality_f, y = alcohol, fill = type)) +
  geom_boxplot(na.rm = TRUE) +
  labs(
    title = "Alcohol Content Across Wine Quality Scores",
    x = "Quality Score",
    y = "Alcohol (%)",
    fill = "Wine Type"
  ) +
  theme_minimal()

#========================================================
# PLOT 5: Distribution of alcohol by wine class (violin)
#========================================================
ggplot(wine, aes(x = quality_f, y = alcohol, fill = quality_f)) +
  geom_violin(trim = FALSE, na.rm = TRUE) +
  labs(
    title = "Distribution of Alcohol Content by Wine Quality",
    x = "Quality Score",
    y = "Alcohol (%)",
    fill = "Quality"
  ) +
  theme_minimal() +
  theme(legend.position = "none")
