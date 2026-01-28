# Verifică dacă ggplot2 este instalat, instalează dacă nu
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Date pentru dimensiunea APK (doar Android)
apk_size_data <- data.frame(
  Tehnologie = factor(c("Native", "Compose Multiplatform", "Flutter"), levels = c("Native", "Compose Multiplatform", "Flutter")),
  Dimensiune_MB = c(1.463, 1.463, 6.828),
  Categorie = factor(c("Native", "CMP", "Flutter"), levels = c("Native", "CMP", "Flutter"))
)

# Date pentru timpul de pornire (maxim utilizat)
startup_time_data <- data.frame(
  Tehnologie = factor(c("Native", "Compose Multiplatform", "Flutter"), levels = c("Native", "Compose Multiplatform", "Flutter")),
  Timp_Pornire_ms = c(423.1, 466.4, 649.8),
  Categorie = factor(c("Native", "CMP", "Flutter"), levels = c("Native", "CMP", "Flutter"))
)

# Creează graficul pentru dimensiunea APK
apk_size_plot <- ggplot(apk_size_data, aes(x = Tehnologie, y = Dimensiune_MB, fill = Categorie)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Native" = "green", "CMP" = "orange", "Flutter" = "blue")) +
  theme_minimal() +
  labs(title = "Comparatia dimensiunii APK", x = "Tehnologie", y = "Dimensiune (MB)") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(hjust = 0.5)
  )

# Creează graficul pentru timpul de pornire
startup_time_plot <- ggplot(startup_time_data, aes(x = Tehnologie, y = Timp_Pornire_ms, fill = Categorie)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Native" = "green", "CMP" = "orange", "Flutter" = "blue")) +
  theme_minimal() +
  labs(title = "Comparatia timpului de pornire", x = "Tehnologie", y = "Timp (ms)") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(hjust = 0.5)
  )

ggsave("apk_size_plot.png", plot = apk_size_plot, width = 8, height = 6, dpi = 300)
ggsave("startup_time_plot.png", plot = startup_time_plot, width = 8, height = 6, dpi = 300)

# Afișează ambele grafice
print(apk_size_plot)
print(startup_time_plot)
