# Verifică dacă ggplot2 este instalat, instalează-l dacă este necesar
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Datele pentru utilizarea Kotlin și Dart de-a lungul anilor
data_utilizare <- data.frame(
  An = rep(2019:2024, each = 2),
  Limbaj = rep(c("Kotlin", "Dart"), times = 6),
  Procentaj = c(6.6, 1.8, 8.0, 3.7, 9.09, 5.97, 9.92, 6.67, 9.7, 6.13, 9.9, 6)
)

# Creează graficul de tip linie
utilizare_plot <- ggplot(data_utilizare, aes(x = An, y = Procentaj, color = Limbaj)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Kotlin" = "orange", "Dart" = "blue")) +
  theme_minimal() +
  labs(title = "Popularitatea Kotlin și Dart in rândul dezvoltatorilor profesioniști", 
       x = "An", y = "Procentaj Popularitate (%)", color = "Limbaj") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  )

# Salvează graficul
ggsave("utilizare.png", plot = utilizare_plot, width = 8, height = 6, dpi = 300)
print(utilizare_plot)


# Datele pentru Kotlin și Dart pe Reddit și StackOverflow
data_comunitate <- data.frame(
  Categorie = c("Comunitate Reddit", "Comunitate Reddit", "StackOverflow intrebări cu răspunsuri", "StackOverflow intrebări cu răspunsuri"),
  Limbaj = c("Kotlin", "Flutter", "Kotlin", "Flutter"),
  Numar_utilizatori = c(90000, 147000, 79236, 143856)
)

# Sortează datele crescător după limbaj
data_comunitate$Limbaj <- factor(data_comunitate$Limbaj, levels = c("Kotlin", "Flutter"))

# Creează graficul pentru comunitatea Kotlin și Dart cu culori corecte
comunitate_plot <- ggplot(data_comunitate, aes(x = Categorie, y = Numar_utilizatori, fill = Limbaj)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Kotlin" = "orange", "Flutter" = "blue")) +
  theme_minimal() +
  labs(title = "Comunitatea Kotlin și Flutter pe Reddit și StackOverflow",
       x = "Categorie", y = "Număr") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(hjust = 0.5)
  )

ggsave("comunitate.png", plot = comunitate_plot, width = 8, height = 6, dpi = 300)
print(comunitate_plot)
