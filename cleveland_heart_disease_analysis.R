library(ggplot2)
library(GGally)
# Read Cleveland dataset 
heart <- read.csv(
  "processed.cleveland.data",
  header = FALSE,
  stringsAsFactors = FALSE
)

# Assign column names
colnames(heart) <- c("age", "sex", "cp", "trestbps", "chol", "fbs", "restecg", 
                     "thalach", "exang", "oldpeak", "slope", "ca", "thal", "target")

# Replace missing values ("?") with NA
heart[heart == "?"] <- NA

# Convert all columns to numeric 
num_cols <- setdiff(names(heart), "sex")
heart[num_cols] <- lapply(heart[num_cols], as.numeric)

# Convert sex to factor for Plot 1
heart$sex <- factor(heart$sex, levels = c(0, 1), labels = c("Female", "Male"))

# Create binary disease status 
heart$disease <- factor(ifelse(heart$target == 0, "No disease", "Disease"))

# Optional sanity checks
dim(heart)
head(heart)
colSums(is.na(heart))
table(heart$disease)
table(heart$sex)

#--------------------------------------------------------
# Plot 1: Prevalence of heart disease by sex
#--------------------------------------------------------
ggplot(heart, aes(x = sex, fill = disease)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = function(x) paste0(round(100*x), "%")) +
  labs(
    title = "Prevalence of Heart Disease by Sex",
    x = "Sex",
    y = "Percentage",
    fill = "Disease Status"
  ) +
  theme_minimal()

#--------------------------------------------------------
# Plot 2: Correlation matrix of Heart Disease Variables  
#--------------------------------------------------------
corr_vars <- setdiff(names(heart), c("sex", "disease"))

cor_mat <- cor(heart[corr_vars], use = "pairwise.complete.obs")
cor_df <- as.data.frame(as.table(cor_mat))
names(cor_df) <- c("Var1", "Var2", "Correlation")

ggplot(cor_df, aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "black") +
  geom_text(aes(label = round(Correlation, 2)), size = 2.6) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  labs(
    title = "Correlation Matrix (Cleveland Heart Disease Dataset)",
    x = "", y = "", fill = "Corr"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#--------------------------------------------------------
# Plot 3: ST depression (oldpeak) vs disease severity colored with sex trend
#--------------------------------------------------------
ggplot(heart, aes(x = oldpeak, y = target, color = sex)) +
  geom_jitter(width = 0.05, height = 0.05, alpha = 0.6, na.rm = TRUE) +
  geom_smooth(method = "lm", se = FALSE, na.rm = TRUE) +
  labs(
    title = "ST Depression vs Heart Disease Severity by Sex",
    x = "ST Depression (oldpeak)",
    y = "Disease Severity (0–4)",
    color = "Sex"
  ) +
  theme_minimal()

#--------------------------------------------------------
# Plot 4: Pairs plot of strong predictors (age, thalach, oldpeak)
#--------------------------------------------------------
pairs_df <- heart[, c("age", "thal", "oldpeak", "disease")]

pairs_df <- pairs_df[complete.cases(pairs_df), ]

ggpairs(
  pairs_df,
  columns = 1:3,
  aes(color = disease, alpha = 0.6)
) +
  labs(title = "Strong Predictors (age, thal, old) Coloured by Disease Status") +
  theme_minimal() + theme(panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6), 
                          panel.background = element_rect(fill = "white"))

#--------------------------------------------------------
# Plot 5: Maximum heart rate achieved by disease status
#--------------------------------------------------------
ggplot(heart, aes(x = disease, y = thalach, fill = disease)) +
  geom_boxplot(na.rm = TRUE) +
  labs(
    title = "Maximum Heart Rate Achieved by Disease Status",
    x = "Disease Status",
    y = "Max Heart Rate Achieved"
  ) +
  theme_minimal() +
  theme(legend.position = "none")
