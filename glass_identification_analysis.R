
library(ggplot2)

#----------------------------
# Load + prepare data
#----------------------------
glass <- read.csv("glass.data", header = FALSE, stringsAsFactors = FALSE)

colnames(glass) <- c("Id","RI","Na","Mg","Al","Si","K","Ca","Ba","Fe","Type")

glass$Id <- as.integer(glass$Id)
glass$Type <- factor(glass$Type)

# Human-readable class labels (UCI codes)
type_labels <- c(
  "1" = "Building (float)",
  "2" = "Building (non-float)",
  "3" = "Vehicle (float)",
  "4" = "Vehicle (non-float)",
  "5" = "Containers",
  "6" = "Tableware",
  "7" = "Headlamps"
)

glass$TypeLabel <- factor(type_labels[as.character(glass$Type)])

dim(glass)
head(glass)
colSums(is.na(glass))
table(glass$TypeLabel)

#========================================================
# 1) Class distribution of glass type (bar, colour-coded)
#========================================================
ggplot(glass, aes(x = TypeLabel, fill = TypeLabel)) +
  geom_bar() +
  labs(
    title = "Class Distribution of Glass Types",
    x = "Glass Type",
    y = "Count",
    fill = "Glass Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    legend.position = "none"
  )

#========================================================
# 2) Refractive index by glass type (boxplot, colour-coded)
#========================================================
ggplot(glass, aes(x = TypeLabel, y = RI, fill = TypeLabel)) +
  geom_boxplot(na.rm = TRUE) +
  labs(
    title = "Refractive Index by Glass Type",
    x = "Glass Type",
    y = "Refractive Index (RI)",
    fill = "Glass Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    legend.position = "none"
  )

#========================================================
# 3) Mean chemical composition of all glass types (BAR CHART)
#========================================================
chem_cols <- c("Na","Mg","Al","Si","K","Ca","Ba","Fe")

mean_by_type <- aggregate(
  glass[chem_cols],
  by = list(TypeLabel = glass$TypeLabel),
  FUN = mean,
  na.rm = TRUE
)

# Long format (base R)
mean_long <- stack(mean_by_type[chem_cols])
names(mean_long) <- c("MeanValue", "Attribute")
mean_long$TypeLabel <- rep(mean_by_type$TypeLabel, times = length(chem_cols))

# Simple grouped bar chart
ggplot(mean_long, aes(x = Attribute, y = MeanValue, fill = TypeLabel)) +
  geom_col(position = "dodge") +
  labs(
    title = "Mean Chemical Composition by Glass Type",
    x = "Chemical Attribute",
    y = "Mean Value",
    fill = "Glass Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#========================================================
# 4) Correlation heatmap of glass attributes 
#========================================================
attr_cols <- c("RI","Na","Mg","Al","Si","K","Ca","Ba","Fe")

cor_mat <- cor(glass[attr_cols], use = "pairwise.complete.obs")

cor_df <- as.data.frame(as.table(cor_mat))
names(cor_df) <- c("Var1", "Var2", "Correlation")

ggplot(cor_df, aes(x = Var1, y = Var2, fill = Correlation)) +
  geom_tile(color = "black") +
  geom_text(aes(label = round(Correlation, 2)), size = 3) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  labs(
    title = "Correlation Heatmap of Glass Attributes",
    x = "",
    y = "",
    fill = "Corr"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#========================================================
# 5) Silicon & Calcium vs RI by glass type (FACETED SCATTER)
#========================================================
# Create long data for Si and Ca (base R)
si_ca_long <- stack(glass[c("Si","Ca")])
names(si_ca_long) <- c("ChemValue", "Chemical")
si_ca_long$RI <- rep(glass$RI, times = 2)
si_ca_long$TypeLabel <- rep(glass$TypeLabel, times = 2)

ggplot(si_ca_long, aes(x = ChemValue, y = RI, color = TypeLabel)) +
  geom_point(alpha = 0.7, na.rm = TRUE) +
  facet_wrap(~ Chemical, scales = "free_x") +
  labs(
    title = "Silicon and Calcium vs Refractive Index by Glass Type",
    x = "Chemical Value",
    y = "Refractive Index (RI)",
    color = "Glass Type"
  ) +
  theme_minimal()
