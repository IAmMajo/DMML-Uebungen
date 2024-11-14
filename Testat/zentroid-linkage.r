#----------------------------------------------------------
# Reset R's brain
#----------------------------------------------------------
rm(list = ls())

#----------------------------------------------------------
# Reset graphic device
# As long as there is any dev open (exept "null device")
# close the active one!
# Caution: closes all open plots!!!!
#----------------------------------------------------------
while (!is.null(dev.list())) {
  dev.off()
}

#----------------------------------------------------------
# Tell R where to find our data
#----------------------------------------------------------
getwd()
# setwd("C:/...") # Bei Bedarf anpassen
getwd()

str(iris3)
iris_df_setosa <- data.frame(iris3[, , 1], Species = "Setosa")
iris_df_versicolor <- data.frame(iris3[, , 2], Species = "Versicolor")
iris_df_virginica <- data.frame(iris3[, , 3], Species = "Virginica")

iris_df <- rbind(iris_df_setosa, iris_df_versicolor, iris_df_virginica)
iris_df_nur_Merkmale <- iris_df[, 1:4]
iris_df_nur_Species <- data.frame(iris_df[, 5])

# Standardisierung der Daten
iris_scaled <- scale(iris_df_nur_Merkmale)

# Distanzmatrizen berechnen
dist_original <- dist(iris_df_nur_Merkmale, method = "euclidean")
dist_scaled <- dist(iris_scaled, method = "euclidean")

# Zentroid-Linkage Clustering für originale Daten
hclust_original <- hclust(dist_original, method = "centroid")

# Zentroid-Linkage Clustering für standardisierte Daten
hclust_scaled <- hclust(dist_scaled, method = "centroid")

# Visualisierung der Dendrogramme
plot(hclust_original, main = "Zentroid-Linkage (Original)", xlab = "")
plot(hclust_scaled, main = "Zentroid-Linkage (Standardisiert)", xlab = "")

# Cluster-Zuordnungen für 2-5 Cluster berechnen
# Für originale Daten
clusters_original <- list(
  k2 = cutree(hclust_original, k = 2),
  k3 = cutree(hclust_original, k = 3),
  k4 = cutree(hclust_original, k = 4),
  k5 = cutree(hclust_original, k = 5)
)

# Für standardisierte Daten
clusters_scaled <- list(
  k2 = cutree(hclust_scaled, k = 2),
  k3 = cutree(hclust_scaled, k = 3),
  k4 = cutree(hclust_scaled, k = 4),
  k5 = cutree(hclust_scaled, k = 5)
)

# Cluster-Zuordnungen mit den ursprünglichen Daten kombinieren
# Beispiel für k=3 Cluster mit originalen Daten
ergebnisse_original <- data.frame(
  Species = iris_df$Species,
  Cluster = clusters_original$k3
)

# Kreuztabelle erstellen um zu sehen, wie die Arten auf Cluster verteilt sind
print("Verteilung der Arten auf Cluster (Original):")
table(ergebnisse_original$Species, ergebnisse_original$Cluster)

# Visualisierung der Cluster-Zuordnung (für 2 Merkmale)
plot(iris_df_nur_Merkmale$Sepal.L, iris_df_nur_Merkmale$Sepal.W,
  col = clusters_original$k3, # Farben entsprechend der Cluster
  pch = 16,
  main = "Cluster-Zuordnung (Original, k=3)",
  xlab = "Sepal Length", ylab = "Sepal Width"
)

# Für standardisierte Daten
ergebnisse_scaled <- data.frame(
  Species = iris_df$Species,
  Cluster = clusters_scaled$k3
)

# Kreuztabelle erstellen um zu sehen, wie die Arten auf Cluster verteilt sind
print("Verteilung der Arten auf Cluster (Standardisiert):")
table(ergebnisse_scaled$Species, ergebnisse_scaled$Cluster)

# Visualisierung der Cluster-Zuordnung (für 2 Merkmale)
plot(iris_df_nur_Merkmale$Sepal.L, iris_df_nur_Merkmale$Sepal.W,
  col = clusters_scaled$k3, # Farben entsprechend der Cluster
  pch = 16,
  main = "Cluster-Zuordnung (Standardisiert, k=3)",
  xlab = "Sepal Length", ylab = "Sepal Width"
)
