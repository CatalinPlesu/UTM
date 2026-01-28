USE animeDB;

-- 1. Sa se afle toate datele despre animeurile de la studio
SELECT s.Denumire_Studio, a.Titlu, d.*
FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
JOIN anime a ON a.Id_Anime = d.Id_Anime;

-- 2. Sa se obtina lista animeurilor in ordinea descrescatoare a numarului de episoade
SELECT r.Id_Anime, r.Titlu, COUNT(r.Id_Episod) AS 'Nr Episoade'
FROM (
	SELECT a.Id_Anime, a.Titlu, e.Id_Episod
	FROM episoade e FULL JOIN anime a ON a.Id_Anime  = e.Id_Anime
	) r
GROUP BY r.Id_Anime, r.Titlu
ORDER BY 'Nr Episoade' DESC

-- 3. Aflati animeurile in care apar fiecare personaj sortati dupa nume si prenume
SELECT p.Nume, p.Prenume, ap.Id_Anime
FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
ORDER BY Nume, Prenume;

-- 4. Afisati care dintre animeuri au Titlul mai lung de 20 de caractere
SELECT *
FROM anime
WHERE LEN(Titlu) > 20;

-- 5. Lista personajelor al caror nume se termina in 'n'
SELECT *
FROM personaje
WHERE Nume Like '%n';

-- 6. Afisati lista anime-urilor care s-au finisat cel mai recent. Sa se foloseasca TOP ... WITH TIES
SELECT TOP 5 WITH TIES *
FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
WHERE d.An_Finisare IS NOT NULL
ORDER BY d.An_Finisare;

-- 7. Ce animeuri au fost produse de studiouri care sunt localizate in regiunea 'Suginami'
SELECT a.*
FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
			JOIN studio s ON d.Id_Studio = s.Id_Studio
WHERE s.Locatia LIKE '%Suginami%';

-- 8. Sa se obtina lista si detaliile animeurilor care care au fost finisate in 2018
SELECT *
FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
WHERE d.An_Finisare BETWEEN '2018-01-01' AND '2018-12-31';

-- 9. Gasiti numele si adresa studiourilor care au publicat animeuri in anul 2018
SELECT s.Denumire_Studio, s.Locatia
FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
WHERE d.An_Lansare BETWEEN '2018-01-01' AND '2018-12-31';

-- 10. Gasiti animeuri lansate in 1986 care au mai mult de 10 episoade si mai putin de 500
SELECT *
FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
			JOIN (
				SELECT Id_Anime, COUNT(Id_Episod)
				FROM episoade
				GROUP BY Id_Anime
			) r
			JOIN episoade e ON e.Id_Anime = a.Id_Anime
WHERE d.An_Lansare BETWEEN '1986-01-01' AND '1986-12-31';

-- 11. 

-- 12. 