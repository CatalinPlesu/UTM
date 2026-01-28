# Verifică dacă ggplot2 este instalat, instalează-l dacă este necesar
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Creează datele pentru stele și proiecte separat
stars_data <- data.frame(
  Categoria = c("Flutter", "Compose Multiplatform"),
  Contor = c(168000, 1200),
  Framework = c("Flutter", "Compose Multiplatform")
)

projects_data <- data.frame(
  Categoria = c("Flutter", "Compose Multiplatform"),
  Contor = c(63020, 860),
  Framework = c("Flutter", "Compose Multiplatform")
)

# Creează graficul pentru stele
stars_plot <- ggplot(stars_data, aes(x = Categoria, y = Contor, fill = Framework)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Flutter" = "blue", "Compose Multiplatform" = "orange")) +
  theme_minimal() +
  labs(title = "Flutter vs Compose Stele", x = "Categorie", y = "Stele") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(hjust = 0.5)
  )

# Creează graficul pentru proiecte
projects_plot <- ggplot(projects_data, aes(x = Categoria, y = Contor, fill = Framework)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Flutter" = "blue", "Compose Multiplatform" = "orange")) +
  theme_minimal() +
  labs(title = "Flutter vs Compose Proiecte", x = "Categorie", y = "Proiecte") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(hjust = 0.5)
  )

ggsave("stars_plot.png", plot = stars_plot, width = 8, height = 6, dpi = 300)
ggsave("projects_plot.png", plot = projects_plot, width = 8, height = 6, dpi = 300)

# Afișează ambele grafice
print(stars_plot)
print(projects_plot)
