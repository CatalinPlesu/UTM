USE master
GO

IF DB_ID('animeDB') IS NOT NULL
	BEGIN
		DECLARE @kill varchar(8000) = '';  
		SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
		FROM sys.dm_exec_sessions
		WHERE database_id  = db_id('animeDB')
		EXEC(@kill);

		DROP DATABASE animeDB;
	END
GO

CREATE DATABASE animeDB;
GO
USE animeDB
GO

CREATE TABLE anime(
	Id_Anime VARCHAR(10) PRIMARY KEY,
	Titlu VARCHAR(50) NOT NULL,
)
GO

CREATE TABLE episoade(
	Id_Anime VARCHAR(10) REFERENCES anime(Id_Anime) ON DELETE CASCADE,
	Id_Episod SMALLINT NOT NULL,
	Titlu_Ep VARCHAR(150),
	CONSTRAINT pk_episoade PRIMARY KEY( Id_Anime DESC, Id_Episod ASC),
)
GO

CREATE TABLE studio(
	Id_Studio VARCHAR(10)	CONSTRAINT PK_ID_STUDIO PRIMARY KEY,
	Denumire_Studio VARCHAR(25) NOT NULL,
	Locatia NVARCHAR(50) DEFAULT 'Tokyo, Japan',
)
GO

CREATE TABLE detalii(
	Id_Anime VARCHAR(10) PRIMARY KEY REFERENCES anime(Id_Anime) ON DELETE CASCADE,
	An_Lansare DATE,
	An_Finisare DATE,
	Descriere NVARCHAR(2048),
	Id_Studio VARCHAR(10) CONSTRAINT FK_ID_SUTDIO REFERENCES studio(Id_Studio),
)
GO

CREATE TABLE personaje(
	Id_Personaj VARCHAR(10) PRIMARY KEY,
	Nume VARCHAR(15),
	Prenume VARCHAR(15) NOT NULL,
	Rol	VARCHAR(15)
)
GO

CREATE TABLE anime_personaj(
	Id_Anime VARCHAR(10) REFERENCES anime(Id_Anime) ON DELETE CASCADE,
	Id_Personaj VARCHAR(10) REFERENCES personaje(Id_Personaj),
	PRIMARY KEY(Id_Anime, Id_Personaj),
)
GO


-----INSERT DATA  ----------
INSERT INTO anime (Id_Anime, Titlu)
VALUES 
	('onepiece', 'One Piece'),
 	('dragonball', 'Dragon Ball'),
 	('dragonbalz', 'Dragon Ball Z'),
 	('sonnyboy', 'Sonny Boy'),
 	('yourname', 'Your Name'),
 	('gbdreaming', 'Grand Blue Deraming'),
 	('weathering', 'Weathering With You'),
 	('eatpancrea', 'I want to eat your pancreas'),
 	('horimiya', 'Horimiya'),
 	('hyouka', 'Hyouka'),
 	('boybeast', 'The Boy and The Beast'),
 	('mrtpatriot', 'Moriarty the Patriot'),
 	('flcl', 'FLCL'),
 	('demonslaye', 'Demon Slayer');
GO


INSERT INTO studio(Id_Studio, Denumire_Studio, Locatia)
VALUES 
	('toei', 'Toei Animation', 'Nerima City, Tokyo, Japan'),
 	('madhouse', 'Madhouse Inc.', 'Honchō, Nakano, Tokyo'),
	('comixwave', 'CoMix Wave', 'Chiyoda, Tokyo, Japan'),
	('zero-g', 'Zero-G', 'Suginami, Tokyo, Japan'),
	('voln', 'VOLN', 'Suginami, Tokyo, Japan'),
	('clover-w', 'CloverWorks', 'Suginami, Tokyo, Japan'),
	('kyoto-a', 'Kyoto Animation', 'Uji, Kyoto, Japan'),
	('chizu', 'Chizu', 'Suginami, Tokyo, Japan'),
	('prod-i-g', 'Production I.G', 'Kokubunji, Tokyo, Japan'),
	('gainax', 'Gainax', 'Musashino, Tokyo, Japan'),
	('ufotable', 'Ufotable', 'Suginami, Tokyo, Japan');
GO

INSERT INTO detalii(Id_Anime, An_Lansare, An_Finisare, Descriere, Id_Studio)
VALUES 
	('onepiece', '1999-10-20', NULL, 
	'Gold Roger was known as the Pirate King, the strongest and most infamous being to have sailed the Grand Line. The capture and death of Roger by the World Government brought a change throughout the world. His last words before his death revealed the location of the greatest treasure in the world, One Piece. It was this revelation that brought about the Grand Age of Pirates, men who dreamed of finding One Piece (which promises an unlimited amount of riches and fame), and quite possibly the most coveted of titles for the person who found it, the title of the Pirate King.
	Enter Monkey D. Luffy, a 17-year-old boy that defies your standard definition of a pirate. Rather than the popular persona of a wicked, hardened, toothless pirate who ransacks villages for fun, Luffy’s reason for being a pirate is one of pure wonder; the thought of an exciting adventure and meeting new and intriguing people, along with finding One Piece, are his reasons of becoming a pirate. Following in the footsteps of his childhood hero, Luffy and his crew travel across the Grand Line, experiencing crazy adventures, unveiling dark mysteries and battling strong enemies, all in order to reach One Piece.',
   'toei'),
 	('dragonball', '1986-2-26', '1989-4-12',
	'Goku Son is a young boy who lives in the woods all alone—that is until a girl named Bulma runs into him in her search for a set of magical objects called the "Dragon Balls." Since the artifacts are said to grant one wish to whoever collects all seven, Bulma hopes to gather them and wish for a perfect boyfriend. Goku happens to be in possession of a dragon ball, but unfortunately for Bulma, he refuses to part ways with it, so she makes him a deal: he can tag along on her journey if he lets her borrow the dragon ball''s power. With that, the two set off on the journey of a lifetime.
	They don''t go on the journey alone. On the way, they meet the old Muten-Roshi and wannabe disciple Kuririn, with whom Goku trains to become a stronger martial artist for the upcoming World Martial Arts Tournament. However, it''s not all fun and games; the ability to make any wish come true is a powerful one, and there are others who would do much worse than just wishing for a boyfriend. To stop those who would try to abuse the legendary power, they train to become stronger fighters, using their newfound strength to help the people around them along the way.',
	'toei'),
 	('dragonbalz', NULL, NULL, NULL, 'toei'),
 	('sonnyboy', '2021-7-16', '2021-10-1', 
	'Thirty-six students find themselves and their school building suddenly adrift in a void-like dimension. When supernatural powers awaken in some of them, a sense of detachment begins to divide the group. Despite the student council''s attempts to impose order, they clash with the students possessing special abilities, who rebel against their strict control.
	This conflict leads them to discover that this world has its own set of rules—and following them is necessary for survival. After one of the students decides to take a leap of faith, the school switches dimensions once again. While they deal with the unique challenges and circumstances that each world presents, the students must unravel the mysterious phenomenon and find a way back home.',
	'madhouse'),
	('yourname', '2016-8-26', '2016-8-26',
	'Mitsuha Miyamizu, a high school girl, yearns to live the life of a boy in the bustling city of Tokyo—a dream that stands in stark contrast to her present life in the countryside. Meanwhile in the city, Taki Tachibana lives a busy life as a high school student while juggling his part-time job and hopes for a future in architecture.
	One day, Mitsuha awakens in a room that is not her own and suddenly finds herself living the dream life in Tokyo—but in Taki''s body! Elsewhere, Taki finds himself living Mitsuha''s life in the humble countryside. In pursuit of an answer to this strange phenomenon, they begin to search for one another.
	Kimi no Na wa. revolves around Mitsuha and Taki''s actions, which begin to have a dramatic impact on each other''s lives, weaving them into a fabric held together by fate and circumstance.',
	'comixwave'),
 	('gbdreaming', '2018-7-14', '2018-9-29',
	'A new life begins for Kitahara Iori as he begins his college career near the ocean in Izu city, full of excitement for his new life. He will be moving into his Uncle''s diving store "Grand Blue." There he finds the beautiful ocean, beautiful women, and men that love diving and alcohol. Will Iori be able to live his dream college life?',
	'zero-g'),
 	('weathering', '2019-7-19', '2019-7-19',
	'High school student Hodaka leaves his home on an isolated island and moves to Tokyo, but he immediately becomes broke. He lives his days in isolation, but finally finds a job as a writer for a shady occult magazine. After he starts his job, the weather has been rainy day after day. In a corner of the crowded and busy city, Hodaka meets a young woman named Hina. Due to certain circumstances, Hina and her younger brother live together, but have a cheerful and sturdy life. Hina also has a certain power: the power to stop the rain and clear the sky.',
	'comixwave'),
 	('eatpancrea', '2018-9-1', '2018-9-1',
	'Spring time in April and the last of the cherry blossoms are still in bloom. The usually aloof bookworm with no interest in others comes across a book in a hospital waiting room. Handwritten on the cover are the words: "Living with Dying." He soon discovers that it is a diary kept by his very popular and genuinely cheerful classmate, Sakura Yamauchi, who reveals to him that she is secretly suffering from a pancreatic illness and only has a limited time left. It is at this moment that she gains just one more person to share her secret.
	Trying to maintain a normal life as much as possible, Sakura is determined to live her life to the fullest until the very last day. As her free spirit and unpredictable actions throw him for a loop, his heart begins to gradually change.',
	'voln'),
 	('horimiya', '2021-1-10', '2021-4-4',
	'A secret life is the one thing they have in common. At school, Hori is a prim and perfect social butterfly, but the truth is she''s a brash homebody. Meanwhile, under a gloomy facade, Miyamura hides a gentle heart, along with piercings and tattoos. In a chance meeting, they both reveal a side they''ve never shown. Could this blossom into something new?',
	'clover-w'),
 	('hyouka', '2012-4-23', '2012-9-16',
	'Energy-conservative high school student Houtarou Oreki ends up with more than he bargained for when he signs up for the Classic Literature Club at his sister''s behest—especially when he realizes how deep-rooted the club''s history really is. Begrudgingly, Oreki is dragged into an investigation concerning the 45-year-old mystery that surrounds the club room.
Accompanied by his fellow club members, the knowledgeable Satoshi Fukube, the stern but benign Mayaka Ibara, and the ever-curious Eru Chitanda, Oreki must combat deadlines and lack of information with resourcefulness and hidden talent, in order to not only find the truth buried beneath the dust of works created years before them, but of other side cases as well.
Based on the award-winning Koten-bu light novel series, and directed by Yasuhiro Takemoto of Suzumiya Haruhi no Shoushitsu, Hyouka shows that normal life can be full of small mysteries, be it family history, a student film, or even the withered flowers that make up a ghost story.',
	'kyoto-a'),
 	('flcl', '2000-4-26', '2001-3-16',
	'Naota is a detached sixth grader afflicted by the pangs of puberty. He''s fooling around with his brother''s ex-girlfriend when a crazed girl on a motor scooter runs him over, brains him with a bass guitar, and moves into his house. This pink-haired girl, Haruko - who claims she''s an alien - hurls Naota into the middle of a mega-corporation''s secret agenda. Oh, and now giant battling robots shoot from his skull. Mix in mind-bending animation and tunes that echo through your cerebellum to top off the trip that will have you falling hard for FLCL.',
	'gainax');
GO

INSERT INTO personaje(Id_Personaj, Nume, Prenume)
VALUES
	('op_luffy', 'Monkey D.', 'Luffy'),
	('op_zoro', 'Roronoa', 'Zoro'),
	('op_nami', '', 'Nami'),
	('op_usopp', '', 'Usopp'),
	('op_sanji', 'Germa', 'Sanji'),
	('op_chopper', 'Tony Tony', 'Chopper'),
	('op_robin', 'Nico', 'Robin'),
	('op_franky', '', 'Franky'),
	('op_brook', '', 'Brook'),
	('op_jimbei', '', 'Jimbei'),

	('dg_goku', 'Son', 'Goku'),
	('dg_bulma', '', 'Bulma'),
	('dg_kril', '', 'Krillin'),
	('dg_pic', '', 'Piccolo'),
	('dg_gohan', 'Son', 'Gohan'),
	('dg_veg', '', 'Vegeta'),
	('dg_trunks', '', 'Trunks'),

	('sn_nag', 'Nagara', ''),
    ('sn_naz', 'Nozomi', ''), 
    ('sn_miz', 'Mizuho', ''), 
    ('sn_asa', 'Asakaze', ''), 
    ('sn_raj', 'Rajdhani', ''), 
    ('sn_hos', 'Hoshi', ''), 
    ('sn_pon', 'Pony', ''), 
    ('sn_cap', 'Cap', ''), 
    ('sn_hay', 'Hayato', ''), 
    ('sn_sha', 'Shanghai', ''), 
    ('sn_ace', 'Ace', ''), 
    ('sn_tsu', 'Tsubasa', ''), 
    ('sn_yam', 'Yamabiko', ''), 

	('fl_naoto', 'Nandaba', 'Naota'),
	('fl_haruko', 'Haruhara', 'Haruko'),
	('fl_mamimi', 'Samejima', 'Mamimi'),
	('fl_canti', '', 'Canti'),
	('fl_atomsk', '', 'Atomsk'),

	('gb_iori', 'Kitahara', 'Iori');
	GO

INSERT INTO personaje(Id_Personaj, Prenume, Nume)
VALUES
	('yn_tak', 'Taki', 'Tachibana'),
	('yn_mit', 'Mitsuha', 'Miyamizu'),
	('yn_kat', 'Katsuhiko', 'Teshigawara'),
	('yn_say', 'Sayaka', 'Natori'),
	('yn_tsu', 'Tsukasa', 'Fujii'),
	('yn_shi', 'Shinta', 'Takagi'),
	('yn_mik', 'Miki', 'Okudera'),
	('yn_hit', 'Hitoha', 'Miyamizu'),
	('yn_yot', 'Yotsuha', 'Miyamizu'),
	('yn_tos', 'Toshiki', 'Miyamizu');
GO

UPDATE Personaje
SET Rol = 'Principal'
WHERE Id_Personaj IN ('op_luffy', 'dg_goku', 'sn_nagara', 'fl_naoto', 'gb_iori');
GO

INSERT INTO anime_personaj(Id_Anime, Id_Personaj)
VALUES
	('onepiece', 'op_luffy'),
	('onepiece', 'op_zoro'),
	('onepiece', 'op_nami'),
	('onepiece', 'op_usopp'),
	('onepiece', 'op_sanji'),
	('onepiece', 'op_chopper'),
	('onepiece', 'op_robin'),
	('onepiece', 'op_franky'),
	('onepiece', 'op_brook'),
	('onepiece', 'op_jimbei'),

	('dragonball', 'dg_goku'),
	('dragonball', 'dg_bulma'),
	('dragonball', 'dg_kril'),
	('dragonball', 'dg_pic'),
	('dragonball', 'dg_gohan'),
	('dragonball', 'dg_veg'),
	('dragonball', 'dg_trunks'),
	('dragonbalz', 'dg_goku'),
	('dragonbalz', 'dg_bulma'),
	('dragonbalz', 'dg_kril'),
	('dragonbalz', 'dg_pic'),
	('dragonbalz', 'dg_gohan'),
	('dragonbalz', 'dg_veg'),
	('dragonbalz', 'dg_trunks'),

	('sonnyboy', 'sn_nag'),
    ('sonnyboy', 'sn_naz'), 
    ('sonnyboy', 'sn_miz'), 
    ('sonnyboy', 'sn_asa'), 
    ('sonnyboy', 'sn_raj'), 
    ('sonnyboy', 'sn_hos'), 
    ('sonnyboy', 'sn_pon'), 
    ('sonnyboy', 'sn_cap'), 
    ('sonnyboy', 'sn_hay'), 
    ('sonnyboy', 'sn_sha'), 
    ('sonnyboy', 'sn_ace'), 
    ('sonnyboy', 'sn_tsu'), 
    ('sonnyboy', 'sn_yam'), 

	('yourname', 'yn_tak'),
	('yourname', 'yn_mit'),
	('yourname', 'yn_kat'),
	('yourname', 'yn_say'),
	('yourname', 'yn_tsu'),
	('yourname', 'yn_shi'),
	('yourname', 'yn_mik'),
	('yourname', 'yn_hit'),
	('yourname', 'yn_yot'),
	('yourname', 'yn_tos'),

	('flcl', 'fl_naoto'),
	('flcl', 'fl_haruko'),
	('flcl', 'fl_mamimi'),
	('flcl', 'fl_canti'),
	('flcl', 'fl_atomsk');
GO

INSERT INTO episoade(Id_Episod, Id_Anime, Titlu_Ep)
VALUES
	(1, 'yourname', 'Your Name'),
	(1, 'onepiece', 'I''m Luffy! The Man Who Will Become the Pirate King!'),
	(8, 'onepiece', 'Who is the Victor? Devil Fruit Power Showdown!'),
	(9, 'onepiece', 'The Honorable Liar? Captain Usopp!'),
	(10, 'onepiece', 'The Weirdest Guy Ever! Jango the Hypnotist!'),
	(1033, 'onepiece', 'The Conclusion! Luffy, Accelerating Fist of the Supreme King'),
	(1038, 'onepiece', 'Nami''s Lethal Attack! Otama''s Desperate Challenge!'),
	(1039, 'onepiece', 'Sudden Increase of Allies! The Straw Hats Strike Back!'),
	(1, 'dragonball', 'Bulma and Son Gokū'),
	(2, 'dragonball', 'Alalala–! No Balls!'),
	(3, 'dragonball', 'Kame Sennin''s Kintoun'),
	(11, 'dragonball', 'Finally, the Dragon Appears!'),
	(149, 'dragonball', 'The Wedding Dress In Flames'),
	(152, 'dragonball', 'Hurry, Gokū! The Mysterious Mountain of the Five Elements'),
	(153, 'dragonball', 'Mount Frypan Burns! An Instant Do-or-Die Journey'),
	(1, 'dragonbalz', 'Mini-Goku is an Overprotected Boy! I Am Gohan. / The Arrival of Raditz [The New Threat]'),
	(2, 'dragonbalz', 'The Mightiest Warrior in All of History is Goku''s Older Brother! / The Arrival of Raditz [Reunions]'),
	(7, 'dragonbalz', 'Survival with Dinosaurs! Gohan''s Harsh Training / Gohan''s Metamorphosis [Day 1]'),
	(8, 'dragonbalz', 'A Great Transformation on a Moonlit Night! The Secret of Gohan''s Power / Gohan''s Metamorphosis [Gohan Goes Bananas!]'),
	(289, 'dragonbalz', 'Grandpa Goku! I Am Pan!! / Granddaughter Pan'),
	(290, 'dragonbalz', 'I Am Oob! Now Ten Years Old, the Former Majin!? / Buu''s Reincarnation'),
	(291, 'dragonbalz', 'Even Stronger!! Goku''s Dream is Super-Huge / Goku''s Next Journey');
GO

-- ###################################################################################################################################################
-- Laboratorul Nr 5
-- ###################################################################################################################################################

-- 1. Populam adresele nule sau goale din tabelul studio cu valoarea implicita
UPDATE studio SET Locatia = DEFAULT WHERE Locatia IS NULL OR Locatia = '';

-- 2. Modificam atributul Titlu astfel ca valorile acceptate trebuie sa fie unice si diferite de null
ALTER TABLE anime ALTER COLUMN Titlu VARCHAR(50) NOT NULL;
ALTER TABLE anime ADD CONSTRAINT uq_titlu UNIQUE(Titlu);

-- 3. Sa se adauge 2 coloane noi. Coloanele Rating si Nr_Episoade
ALTER TABLE detalii ADD Rating DECIMAL(3,1) DEFAULT 5;
ALTER TABLE detalii ADD Nr_Episoade SMALLINT;
GO
ALTER TABLE detalii ADD CONSTRAINT ck_nr_ep_pozitiv CHECK(Nr_Episoade>-1);
GO

-- va seta toate ratinugile la o valoare arbitrara
UPDATE detalii SET Rating = 5.2 WHERE Rating IS NULL;
GO

-- determinarea numarului de episoade
UPDATE detalii
SET Nr_Episoade = (SELECT COUNT(*)
					FROM episoade
					WHERE Id_Anime = detalii.Id_Anime)
GO

-- 4. Mareste ratingul +1 tuturor animeurilor care inca nu s-au finisat
UPDATE detalii SET Rating += 1 WHERE An_Finisare IS NULL AND Rating+1 < 10;
GO
-- Marirea ratingului cu 1 pentru fiecare 200 de episoade
UPDATE detalii SET Rating += Nr_Episoade/200;
UPDATE detalii SET Rating = 10 WHERE Rating > 10;
GO

-- 5. Sa se creeze tabelul studio_new
-- 5.a Id sa fie cheie primara si clustered
-- 5.b campul locatie trebuie sa aiba valoare implicita
-- 5.c transferarea in tabelul nou
CREATE TABLE studio_new(
	Id_Studio VARCHAR(10) PRIMARY KEY CLUSTERED,
	Denumire_Studio VARCHAR(25) NOT NULL,
	Locatia NVARCHAR(50) DEFAULT 'Tokyo, Japan',
	Adresa_1 NVARCHAR(50), -- numarul strazii
	Adresa_2 NVARCHAR(50), -- adresa casei
)

-- parsename replace va taia stringul din celula Locatia la simbolul , si va utiliza doar al n-lea element
INSERT studio_new
SELECT *, 
PARSENAME(REPLACE(Locatia, ', ', '.'), 3) as Adresa_1, 
PARSENAME(REPLACE(Locatia, ', ', '.'), 2) as Adresa_2
FROM studio

-- 8. sa se creeze un index care face instructiunea SELECT mai rapida
-- adaugarea la grupul de fisiere userdatafgroup1
ALTER DATABASE [animeDB] ADD FILEGROUP [userdatafgroup1];
GO

CREATE NONCLUSTERED INDEX detalii_rating   
    ON detalii (Rating);   
GO  


-- ###################################################################################################################################################
-- Laboratorul Nr 6
-- ###################################################################################################################################################

-- 6.6. Să se creieze trei scheme noi și să se transfere tabelele din schema dbo în schemele respective. 
-- Să se scrie instrucțiunile T-SQL.

CREATE SCHEMA principal;
GO
ALTER SCHEMA principal TRANSFER dbo.anime;
ALTER SCHEMA principal TRANSFER dbo.detalii;
GO

CREATE SCHEMA secundar;
GO
ALTER SCHEMA secundar TRANSFER dbo.anime_personaj;
ALTER SCHEMA secundar TRANSFER dbo.personaje;
GO

CREATE SCHEMA auxiliar;
GO
ALTER SCHEMA auxiliar TRANSFER dbo.studio;
ALTER SCHEMA auxiliar TRANSFER dbo.episoade;
GO

-- 6.7. Să se creeze niște interogări care să țină cont că tabelele au fost mutate în scheme.

--SELECT a.Titlu, d.*
--FROM principal.anime a JOIN principal.detalii d
--ON a.Id_Anime = d.Id_Anime;

--SELECT Descriere
--FROM principal.detalii
--WHERE Descriere IS NOT NULL;

--SELECT Id_Anime, COUNT(Id_Episod) AS 'Nr Episoade'
--FROM auxiliar.episoade
--GROUP BY Id_Anime;
--GO

-- 6.8. Creați sinonime și modificați interogările ca acestea să utilizeze sinonimele.
CREATE SYNONYM anime FOR animeDB.principal.anime;
CREATE SYNONYM detalii FOR animeDB.principal.detalii;
CREATE SYNONYM personaje FOR animeDB.secundar.personaje;
CREATE SYNONYM anime_personaj FOR animeDB.secundar.anime_personaj;
CREATE SYNONYM studio FOR animeDB.auxiliar.studio;
CREATE SYNONYM episoade FOR animeDB.auxiliar.episoade;
GO

--SELECT a.Titlu, d.*
--FROM anime a JOIN detalii d
--ON a.Id_Anime = d.Id_Anime;

--SELECT Descriere
--FROM detalii
--WHERE Descriere IS NOT NULL;

--SELECT Id_Anime, COUNT(Id_Episod) AS 'Nr Episoade'
--FROM episoade
--GROUP BY Id_Anime;
--GO

-- ###################################################################################################################################################
-- Laboratorul Nr 7
-- ###################################################################################################################################################

---- 1. Sa se afle toate datele despre animeurile de la studio
--SELECT s.Denumire_Studio, a.Titlu, d.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--JOIN anime a ON a.Id_Anime = d.Id_Anime;

---- 2. Sa se obtina lista animeurilor in ordinea descrescatoare a numarului de episoade
--SELECT r.Id_Anime, r.Titlu, COUNT(r.Id_Episod) AS 'Nr Episoade'
--FROM (
--	SELECT a.Id_Anime, a.Titlu, e.Id_Episod
--	FROM episoade e FULL JOIN anime a ON a.Id_Anime  = e.Id_Anime
--	) r
--GROUP BY r.Id_Anime, r.Titlu
--ORDER BY 'Nr Episoade' DESC

---- 3. Aflati animeurile in care apar fiecare personaj sortati dupa nume si prenume
--SELECT p.Nume, p.Prenume, ap.Id_Anime
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--ORDER BY Nume, Prenume;

---- 4. Afisati care dintre animeuri au Titlul mai lung de 20 de caractere
--SELECT *
--FROM anime
--WHERE LEN(Titlu) > 20;

---- 5. Lista personajelor al caror nume se termina in 'n'
--SELECT *
--FROM personaje
--WHERE Nume Like '%n';

---- 6. Afisati lista anime-urilor care s-au finisat cel mai recent. Sa se foloseasca TOP ... WITH TIES
--SELECT TOP 5 WITH TIES *
--FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
--WHERE d.An_Finisare IS NOT NULL
--ORDER BY d.An_Finisare;

---- 7. Ce animeuri au fost produse de studiouri care sunt localizate in regiunea 'Suginami'
--SELECT a.*
--FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
--			JOIN studio s ON d.Id_Studio = s.Id_Studio
--WHERE s.Locatia LIKE '%Suginami%';

---- 8. Sa se obtina lista si detaliile animeurilor care care au fost finisate in 2018
--SELECT *
--FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
--WHERE d.An_Finisare BETWEEN '2018-01-01' AND '2018-12-31';

---- 9. Gasiti numele si adresa studiourilor care au publicat animeuri in anul 2018
--SELECT s.Denumire_Studio, s.Locatia
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--WHERE d.An_Lansare BETWEEN '2018-01-01' AND '2018-12-31';

---- 10. Gasiti animeuri lansate in 1986 care au mai mult de 10 episoade si mai putin de 500
--SELECT *
--FROM anime a JOIN detalii d ON a.Id_Anime = d.Id_Anime
--			JOIN (
--				SELECT Id_Anime, COUNT(Id_Episod) as NrEpisoade
--				FROM episoade
--				GROUP BY Id_Anime
--			) r ON a.Id_Anime = r.Id_Anime
--WHERE d.An_Lansare BETWEEN '1986-01-01' AND '1986-12-31' AND  r.NrEpisoade BETWEEN 10 AND 500;

---- 11. Nume si prenume pentru personajelor care au aparut in anime in anul 2016
--SELECT p.Nume, p.Prenume
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--JOIN detalii d ON ap.Id_Anime = d.Id_Anime
--WHERE DATEPART(YEAR, d.An_Lansare) = 2016;


---- 12. Evidenta animeurilor in care se regasesc personajele cu prenumele Goku
--SELECT a.Titlu
--FROM anime a JOIN anime_personaj ap ON a.Id_Anime = ap.Id_Anime
--JOIN personaje p ON ap.Id_Personaj = p.Id_Personaj
--WHERE p.Prenume Like '%Goku%';

---- 13. caror studiouri apartine personajul 'Son Goku'
--SELECT DISTINCT s.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--JOIN personaje p ON ap.Id_Personaj = p.Id_Personaj
--WHERE p.Nume = 'Son' AND p.Prenume = 'Goku';

---- 14. Numele si prenumele personajelor ce se afla in animeuri cu un numar mai mare de 10 episoade
--SELECT ap.Id_Anime, p.Nume, p.Prenume
--FROM personaje p JOIN anime_personaj ap on p.Id_Personaj = ap.Id_Personaj
--WHERE ap.Id_Anime IN (SELECT r.Id_Anime
--						FROM (
--					  SELECT Id_Anime, COUNT(Id_Episod) AS NrEpisoade
--					  FROM episoade
--					  GROUP BY Id_Anime) r
--					  WHERE r.NrEpisoade > 10
--					 )

---- 15. Gasiti personajele care apartin studioului toei sau gainax
--SELECT p.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--JOIN personaje p ON ap.Id_Personaj = p.Id_Personaj
--WHERE s.Id_Studio IN ('toei', 'gainax')

---- 16. Personaje care au aparut in animeuri cu un numar de episoade mai mic de 60
--SELECT ap.Id_Anime, p.*
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--WHERE ap.Id_Anime IN (SELECT Id_Anime
--					  FROM episoade
--					  GROUP BY Id_Anime
--					  HAVING COUNT(Id_Episod) < 60)
--ORDER BY AP.Id_Anime


---- 17. Studioul care il are ca personaj pe personajul cu id-ul dg_goku
--SELECT DISTINCT s.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--WHERE ap.Id_Personaj = 'dg_goku'

---- 18. Studiouri care au douar animeuri cu mai putin de 60 de episoade
--SELECT DISTINCT s.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--WHERE d.Id_Anime IN (SELECT Id_Anime
--					  FROM episoade
--					  GROUP BY Id_Anime
--					  HAVING COUNT(Id_Episod) < 60)
--ORDER BY s.Id_Studio

---- 19. Numele studioului care il au pe personajul cu prenumele Goku
--SELECT DISTINCT s.*
--FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--JOIN personaje p ON p.Id_Personaj = ap.Id_Personaj
--WHERE p.Prenume = 'Goku';

---- 20. Gasiti numele personajelor din animeuri cu un rating mai mare de 6
--SELECT p.*
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--JOIN detalii d ON ap.Id_Anime = d.Id_Anime
--WHERE d.Rating > 6
--ORDER BY d.Rating;

---- 21. In cate animeuri a aparut fiecare personaj
--SELECT p.*, r.Nr_Animeuri
--FROM personaje p JOIN (SELECT Id_Personaj, COUNT(Id_Anime) as Nr_Animeuri
--					   FROM anime_personaj
--					   GROUP BY Id_Personaj) r ON p.Id_Personaj = r.Id_Personaj
--ORDER BY r.Nr_Animeuri DESC;

---- 22. Numarul de animeuri pe care le are fiecare studio
--SELECT s.Id_Studio, r.Nr_Animeuri
--FROM studio s JOIN (SELECT Id_Studio, COUNT(*) AS Nr_Animeuri
--					FROM detalii
--					GROUP BY (Id_Studio))r ON s.Id_Studio = r.Id_Studio
--ORDER BY r.Nr_Animeuri DESC;

---- 23. Lista studiourilor care au animeuri cu rating mai mare de 6 
--SELECT * 
--FROM studio
--WHERE Id_Studio IN (SELECT Id_Studio
--					FROM detalii d
--					WHERE d.Rating > 6);

---- 24. Lista personajelor care apar in cel putin doua animeuri
--SELECT p.*, r.Nr_Animeuri
--FROM personaje p JOIN (SELECT Id_Personaj, COUNT(Id_Anime) as Nr_Animeuri
--					   FROM anime_personaj
--					   GROUP BY Id_Personaj) r ON p.Id_Personaj = r.Id_Personaj
--WHERE r.Nr_Animeuri > 1
--ORDER BY r.Nr_Animeuri DESC;

---- 25. In ce anime figureaza mai mult de 6 personaje
--SELECT *
--FROM anime
--WHERE Id_Anime IN(  SELECT Id_Anime
--					FROM anime_personaj
--					GROUP BY Id_Anime
--					HAVING COUNT(Id_Personaj) > 6);

---- 26. Gasiti studiourile care se gasesc in Suburbia Suginami
--SELECT * 
--FROM studio
--WHERE Locatia LIKE '%Suginami%';

---- 27. Toate personajele care apartin studioului madhouse
--SELECT p.*
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--JOIN detalii d ON ap.Id_Anime = d.Id_Anime
--WHERE d.Id_Studio = 'madhouse';

---- 28. Ratingul mediu al studiourilor din Tokyo
--SELECT s.*, r.Rating_Med
--FROM studio s JOIN (SELECT Id_Studio, AVG(Rating) AS Rating_Med
--					FROM detalii
--					GROUP BY Id_Studio) r ON s.Id_Studio = r.Id_Studio
--WHERE Locatia LIKE '%Tokyo%';

---- 29. Gasiti Personajele din animeuri cu rating mai mic decat animeul personajului cu idiul dg_goku
--SELECT p.*
--FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--JOIN detalii d ON d.Id_Anime = ap.Id_Anime
--WHERE d.Rating < (SELECT MAX(Rating)
--				FROM personaje p JOIN anime_personaj ap ON p.Id_Personaj = ap.Id_Personaj
--				JOIN detalii d ON d.Id_Anime = ap.Id_Anime
--				WHERE p.Id_Personaj = 'dg_goku'
--				GROUP BY p.Id_Personaj); --rating maxim 

---- 30. Cate personaje au apartu in animeul dragon ball
--SELECT COUNT(Id_Personaj)
--FROM anime_personaj
--GROUP BY (Id_Anime)
--HAVING Id_Anime = 'dragonball';

---- 31. Studiourile care au lansat mai mult de 2 animeuri intr-un an
--SELECT s.*
--FROM studio s JOIN (SELECT Id_Studio
--					FROM detalii
--					GROUP BY Id_Studio
--					HAVING COUNT(YEAR(An_Lansare)) > 2) d 
--			   ON s.Id_Studio = d.Id_Studio


---- 32. Numele, prenumele personajelor si numarul de animeuri in care au aparut
--SELECT p.Nume, p.Prenume, x.Nr_Anime
--FROM personaje p JOIN (
--		SELECT Id_Personaj, COUNT(Id_Anime) as Nr_Anime
--		FROM anime_personaj
--		GROUP BY Id_Personaj) x
--		ON p.Id_Personaj = x.Id_Personaj
--ORDER BY x.Nr_Anime DESC

---- 33. Numele personajelor care nu au aparut in nici un anime
--SELECT Nume, Prenume
--FROM personaje
--WHERE Id_Personaj NOT IN (
--		SELECT Id_Personaj
--		FROM anime_personaj
--		GROUP BY Id_Personaj
--		HAVING COUNT(Id_Anime) > 0) 

---- 34. Gasiti studiouri care nu au nici un personaj
--SELECT *
--FROM studio
--WHERE Id_Studio NOT IN (
--		SELECT d.Id_Studio
--		FROM detalii d JOIN anime_personaj ap
--			ON d.Id_Anime = ap.Id_Anime
--		GROUP BY Id_Studio
--		HAVING COUNT(ap.Id_Personaj) > 0
--)

---- 35. Media ratingurilor pe studio
--SELECT s.*, r.Rating_Med
--FROM studio s JOIN (SELECT Id_Studio, AVG(Rating) AS Rating_Med
--					FROM detalii
--					GROUP BY Id_Studio) r ON s.Id_Studio = r.Id_Studio;

---- 36. Gasiti animeurile care s-au inceput in acelasi an, sa se afiseze anul si numarul de animeuri
--SELECT *
--FROM detalii
--WHERE YEAR(An_Lansare) = YEAR(An_Finisare)

---- 37. Gasiti studioul cu animeul cu cel mai mare rating
--SELECT TOP 1 s.*, r.Rating_Med
--FROM studio s JOIN (SELECT Id_Studio, AVG(Rating) AS Rating_Med
--					FROM detalii
--					GROUP BY Id_Studio) r ON s.Id_Studio = r.Id_Studio
--ORDER BY r.Rating_Med DESC;

---- 38. Denumirea studiourilor care au animeuri cu rating mai mic decat ratingul mediu pe toate animeurilor
--SELECT DISTINCT s.*, d.Rating
--FROM detalii d JOIN studio s ON d.Id_Studio = s.Id_Studio
--WHERE d.Rating < (SELECT AVG(Rating)
--				FROM detalii)
--ORDER BY d.Rating DESC				


---- 39. Denumirea animeurilor la care numarul de personaje este reprezinta mai putin de 5% din nr de episoade
--SELECT a.Titlu
--FROM anime a
--WHERE
--(
--SELECT COUNT(ap.Id_Personaj)
--	FROM anime_personaj ap
--	WHERE ap.Id_Anime = a.Id_Anime
--)
--<
--(
--SELECT COUNT(e.Id_Episod)
--	FROM episoade e
--	WHERE e.Id_Anime = a.Id_Anime
--) * 0.05

-- ###################################################################################################################################################
-- Laboratorul Nr 8
-- ###################################################################################################################################################

---- partea 1
---- 8.1.1 Completati urmatorul cod pentru a afisa cel mai mare numar dintre cele trei numere prezentate:
--DECLARE @N1 INT, @N2 INT, @N3 INT; 
--DECLARE @MAI_MARE INT; 
--SET @N1 = 60 * RAND(); 
--SET @N2 = 60 * RAND(); 
--SET @N3 = 60 * RAND(); 
---- Aici ar trebui plasate IF-urile 
--IF (@N1 > @N2) AND (@n1 > @N3)	
--SET @MAI_MARE = @N1;
--IF (@N2 > @N1) AND (@n2 > @N1)	
--SET @MAI_MARE = @N2;
--IF (@N3 > @N2) AND (@n3 > @N1)	
--SET @MAI_MARE = @N3;
--PRINT @N1; 
--PRINT @N2; 
--PRINT @N3; 
--PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

---- 8.1.2 Afisati primele zece date (detalii) in functie de valoare ratingului 
--		-- ( cu exceptia ratingului maxim si sub medie) folosind structura IF...ELSE si variablie
--DECLARE @RATING_MAXIM DECIMAL(3,1), @RATING_MEDIU DECIMAL(3,1);
--SET @RATING_MAXIM = (SELECT MAX(Rating) FROM detalii);
--SET @RATING_MEDIU = (SELECT AVG(Rating) FROM detalii);
--PRINT @RATING_MAXIM
--PRINT @RATING_MEDIU

----SELECT TOP 10 *
----FROM detalii
----WHERE (Rating <> @RATING_MAXIM) AND (Rating < @RATING_MEDIU)

	
---- 8.1.3 Sarcina de la punctul 8.1.1 utilizand case
--SET @N1 = 60 * RAND(); 
--SET @N2 = 60 * RAND(); 
--SET @N3 = 60 * RAND(); 
---- Aici ar trebui plasate IF-urile
--SET @MAI_MARE = 
--CASE 
--	WHEN (@N1 > @N2) AND (@n1 > @N3) THEN  @N1
--	WHEN (@N2 > @N1) AND (@n2 > @N1) THEN @N2
--	WHEN (@N3 > @N2) AND (@n3 > @N1) THEN @N3
--END

--PRINT @N1; 
--PRINT @N2; 
--PRINT @N3; 
--PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

---- 8.1.4 Utilizati try catch
--BEGIN TRY
--	SET @N1 = 60 * RAND(); 
--	SET @N2 = 60 * RAND(); 
--	SET @N3 = 60 * RAND(); 
--	-- Aici ar trebui plasate IF-urile 
--	IF (@N1 > @N2) AND (@n1 > @N3)	
--	SET @MAI_MARE = @N1;
--	IF (@N2 > @N1) AND (@n2 >@N1)	
--	SET @MAI_MARE = @N2;
--	IF (@N3 > @N2) AND (@n3 > @N1)	
--	SET @MAI_MARE = @N3;
--	PRINT @N1; 
--	PRINT @N2; 
--	PRINT @N3; 
--	PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 
--END TRY
--BEGIN CATCH
--	PRINT 'A apartu o eroare'
--END CATCH
--GO

---- partea 2
---- 8.2.1 Sa se creeze 2 vieuri care au fost selecturi in exercitii anterioare
--CREATE VIEW principal.toate_datele AS
--	SELECT s.Denumire_Studio, a.Titlu, d.*
--	FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--	JOIN anime a ON a.Id_Anime = d.Id_Anime
--GO
----SELECT * FROM principal.toate_datele
----GO

--CREATE VIEW principal.anime_view AS
--	SELECT Id_Anime, Titlu
--	FROM anime
--GO
----SELECT * FROM  principal.anime_view
----GO

---- 8.2.2 insert, update, delete pentru viewrile respective
--INSERT principal.anime_view (Id_Anime, Titlu)
--VALUES ('dragonbals', 'Dragon Ball Super');
--GO

--UPDATE principal.anime_view SET Titlu = CONCAT('*******', Titlu) WHERE Id_Anime LIKE 'dragon%';

--DELETE FROM principal.anime_view WHERE Id_Anime Like 'dragon%';
--GO

---- 8.2.3 sa se modifice viziunile ca acestea sa nu poata modifica tabelele originale si sa nu se poata utiliza instructiuni DML
--ALTER VIEW principal.toate_datele AS
--	SELECT s.Denumire_Studio, a.Titlu, d.*
--	FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--	JOIN anime a ON a.Id_Anime = d.Id_Anime
--	WITH CHECK OPTION
--GO
----SELECT * FROM principal.toate_datele
----GO

--ALTER VIEW principal.anime_view AS
--	SELECT Id_Anime, Titlu
--	FROM anime
--	WITH CHECK OPTION
--GO

---- 8.2.4 testarea proprietatilor noi definite
--select * from principal.toate_datele
--GO

---- 8.2.5 sa se scrie 2 interogari sub forma CTE
--WITH anime_2018 AS (
--	SELECT Id_Anime
--	FROM detalii
--	WHERE YEAR(An_Finisare) = 2018
--)
--SELECT *
--FROM anime a JOIN anime_2018 d ON a.Id_Anime = d.Id_Anime;
--GO

--WITH anime_gt_6_pers AS (
--	SELECT Id_Anime
--	FROM anime_personaj
--	GROUP BY Id_Anime
--	HAVING COUNT(Id_Personaj) > 6
--)

--SELECT *
--FROM anime a JOIN anime_gt_6_pers a6 ON a.Id_Anime = a6.Id_Anime;
--GO

---- 8.2.6 Pare o prostie sa ai de aface cu grafuri intrun limbaj care nu este de programarep


-- ###################################################################################################################################################
-- Laboratorul Nr 9
-- ###################################################################################################################################################

---- 9.1 De scris 2 proceduri cu parametrii de intrare sa corespunda clauzei where
--CREATE PROCEDURE lansat_in_anul @AN INT AS
--	SELECT d.*
--	FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--	WHERE YEAR(d.An_Lansare) = @AN;
--GO

--EXECUTE lansat_in_anul 2018
--EXECUTE lansat_in_anul 1986
--GO

--CREATE PROCEDURE activ_in_anul @AN INT AS
--	SELECT d.*
--	FROM detalii d
--	WHERE YEAR(An_Lansare) <= @AN AND @AN <= YEAR(An_Finisare)

--	UNION
--	SELECT d.*
--	FROM detalii d
--	WHERE YEAR(An_Lansare) <= @AN AND An_Finisare IS NULL

--	UNION 
--	SELECT d.*
--	FROM detalii d
--	WHERE An_Lansare IS NULL AND @AN <= YEAR(An_Finisare)
--GO
--EXECUTE activ_in_anul 2000;
--EXECUTE activ_in_anul 2018;
--GO

---- 9.2 Sa se scrie o procedura care nu are nici un parametru de intrare si returneaza numarul de personaje care apar in cel putin 2 animeuri
--DROP FUNCTION IF EXISTS nr_personaje;
--GO
--CREATE FUNCTION nr_personaje ()
--RETURNS INT AS
--BEGIN
--	RETURN (
--			SELECT COUNT(*) AS Nr_de_Personaje
--			FROM personaje p JOIN (SELECT Id_Personaj, COUNT(Id_Anime) as Nr_Animeuri
--							   FROM anime_personaj
--							   GROUP BY Id_Personaj) r ON p.Id_Personaj = r.Id_Personaj
--			WHERE r.Nr_Animeuri > 1
--	)
--END
--GO

--SELECT dbo.nr_personaje() as nr_de_personaje_care_apar_in_cel_putin_2_animeuri
--GO

---- 9.3 Procedura care va insera datele despre un anime, id, titlu, descriere, studio, restul, an lansare va fi anul curent, an finisare va fi null
--DROP PROCEDURE IF EXISTS insert_anime_plus;
--GO
--CREATE PROCEDURE insert_anime_plus
--	@id VARCHAR(10),
--	@titlu VARCHAR(50),
--	@descriere NVARCHAR(2048),
--	@studio VARCHAR(10)	AS

--	INSERT anime 
--	VALUES (@id, @titlu);
--	INSERT detalii(Id_Anime,An_Lansare,An_Finisare,Descriere,Id_Studio)
--	VALUES (@id, GETDATE(), NULL, @descriere, @studio);
--GO
--EXECUTE insert_anime_plus 'dragonbalx', 'Dragon Ball X', 'Some anime with goku as MC', 'toei';

---- 9.4 fie ca un studio de anime a fost procurat de catre un alt studio de anime in anul X, sa se atribuie animeurile respective noului studio proprietar printr-o procedura
--DROP PROCEDURE IF EXISTS transfer_animeuri_dupa_anul;
--GO
--CREATE PROCEDURE transfer_animeuri_dupa_anul
--	@fost_studio VARCHAR(10),
--	@nou_studio VARCHAR(10),
--	@an INT AS

--	UPDATE detalii SET Id_Studio = @nou_studio WHERE Id_Studio = @fost_studio AND YEAR(An_Lansare) > @an;
--GO

--EXECUTE transfer_animeuri_dupa_anul 'toei', 'voln', 2019

---- 9.5 Sa se scrie o procedura care ar gasi 3 cele mai bune animeuri dupa rating si le-ar mari ratingul cu 1 punct
--DROP PROCEDURE IF EXISTS top_3;
--GO
--CREATE PROCEDURE top_3 AS
--	UPDATE detalii SET Rating = Rating + 1 WHERE Id_Anime IN (
--		SELECT TOP 3 Id_Anime
--		FROM DETALII
--		ORDER BY Rating DESC
--	)
--GO
--EXECUTE top_3
--GO

---- 9.6 Sa se creeze 2 functii in baza selecturilor precedente cu parametrii sa corespunda clauzii where
------ 17. Studioul care il are ca personaj pe personajul cu id-ul dg_goku
--DROP FUNCTION IF EXISTS whre_x_is_character;
--GO
--CREATE FUNCTION whre_x_is_character	(@id  VARCHAR(10))
--	RETURNS VARCHAR(10) AS
--	BEGIN
--		RETURN (
--			SELECT DISTINCT s.Id_Studio
--			FROM studio s JOIN detalii d ON s.Id_Studio = d.Id_Studio
--			JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--			WHERE ap.Id_Personaj = @id
--		)
--	END
--GO
--SELECT dbo.whre_x_is_character('dg_veg') as Studiouri;
--GO

------ 25. In ce anime figureaza mai mult de 6 personaje
--DROP FUNCTION IF EXISTS nr_de_animeuri_cu_mai_mult_de_n_personaje;
--GO
--CREATE FUNCTION nr_de_animeuri_cu_mai_mult_de_n_personaje	(@count INT)
--	RETURNS VARCHAR(10) AS
--	BEGIN
--		RETURN (
--				SELECT COUNT(*)
--				FROM anime
--				WHERE Id_Anime IN(  SELECT Id_Anime
--				FROM anime_personaj
--				GROUP BY Id_Anime
--				HAVING COUNT(Id_Personaj) > @count)
--		)
--	END
--GO
--SELECT dbo.nr_de_animeuri_cu_mai_mult_de_n_personaje(3) as Anime_Cu_Personaje;
--SELECT dbo.nr_de_animeuri_cu_mai_mult_de_n_personaje(7) as Anime_Cu_Personaje;
--SELECT dbo.nr_de_animeuri_cu_mai_mult_de_n_personaje(10) as Anime_Cu_Personaje;
--GO

---- 9.7 Sa se scrie o functie care ar calcula varsta unui anime
---- Sa se defineasca urmatorul format al functiei: <nume Juncfie>(<Data _ Nastere _Student>).
--DROP FUNCTION IF EXISTS varsta_anime;
--GO
--CREATE FUNCTION varsta_anime (@an_lansare DATETIME)
--	RETURNS INT AS
--	BEGIN
--		RETURN (YEAR(GETDATE()) - YEAR(@an_lansare))
--	END
--GO
--SELECT d.*, dbo.varsta_anime(d.An_Lansare) as varsta_anime
--FROM detalii d;
--GO

---- 9.8 Sa se scrie o procedura care ar afisa tabelul cu reusitua unui personaj dupa nume si prenume, va returna nume_prenume, titlu anime, rating
--DROP PROCEDURE IF EXISTS reusita_caracter;
--GO
--CREATE PROCEDURE reusita_caracter 
--	@nume VARCHAR(15), 
--	@prenume VARCHAR(15) AS

--			SELECT CONCAT(p.Nume, ' ', p.Prenume) AS nume_prenume, a.Titlu, d.Rating
--			FROM detalii d JOIN anime_personaj ap ON d.Id_Anime = ap.Id_Anime
--				JOIN personaje p ON p.Id_Personaj = ap.Id_Personaj
--				JOIN anime a ON a.Id_Anime = d.Id_Anime
--				WHERE p.Nume = @nume AND p.Prenume = @prenume
--GO
--EXECUTE dbo.reusita_caracter 'Son', 'Goku';
--GO

---- 9.9 Sa se scrie o functie care va gasi cel mai bun sau cel mai rau anime al unui studio in dependenta de parametrul is_good
--DROP FUNCTION IF EXISTS find_anime;
--GO
--CREATE FUNCTION find_anime (@studio VARCHAR(10), @is_good VARCHAR(10))
--		RETURNS VARCHAR(10) AS
--BEGIN
--	DECLARE @anime VARCHAR(10);
--	IF (@is_good = 'good')
--	SET @anime = (
--		SELECT TOP 1 Id_Anime
--		FROM detalii
--		WHERE Id_Studio = @studio
--		ORDER BY Rating DESC
--	)
--	IF (@is_good = 'bad')
--	SET @anime = (
--		SELECT TOP 1 Id_Anime
--		FROM detalii
--		WHERE Id_Studio = @studio
--		ORDER BY Rating
--	)
--	RETURN @anime
--END
--GO

--SELECT *, dbo.find_anime(Id_Studio, 'good') AS GOOD, dbo.find_anime(Id_Studio, 'bad') AS BAD
--FROM STUDIO;


-- ###################################################################################################################################################
-- Laboratorul Nr 10
-- ###################################################################################################################################################

-- 10.1 sa se creeze un declansator care in urma actualizarii datelor despre un anime va afisa datele vechi si datele noi pentru animeul respectiv

--DROP TRIGGER IF EXISTS principal.update_detalii 
--GO 
--CREATE TRIGGER principal.update_detalii ON principal.detalii 
--INSTEAD OF UPDATE 
--AS 
--UPDATE principal.detalii 
--	SET Id_Anime = (select Id_Anime from inserted),
--	 An_Lansare = (select An_Lansare from inserted),
--	 An_Finisare = (select An_Finisare from inserted),
--	 Descriere = (select Descriere from inserted),
--	 Id_Studio = (select Id_Studio from inserted),
--	 Rating = (select Rating from inserted)
--WHERE Id_Anime = (select Id_Anime from deleted)

--PRINT 'datele inainte de modificare';
--SELECT * FROM deleted;
--PRINT 'datele dupa modificare';
--SELECT * FROM inserted;
--GO 
--UPDATE detalii SET Descriere = 'Test' WHERE Id_Anime = 'onepiece';

-- 10.2 sa se creeze decalnsator care ar asigura popularea corecta a tabelelor anime si descriere
--DROP TRIGGER IF EXISTS principal.inserare_date_anime
--GO
--CREATE TRIGGER principal.inserare_date_anime ON principal.detalii
--INSTEAD OF INSERT AS
--IF (SELECT Id_Anime FROM inserted) IN (SELECT Id_Anime FROM anime)
--	INSERT detalii SELECT * FROM inserted;
--ELSE
--	PRINT 'Nu exista astfel id in tabelulu ''anime'''
--GO

--insert into detalii (id_anime) values ('topg')
--insert into anime   values ('topg', 'Top G')
--insert into detalii (id_anime) values ('topg')

-- 10.3 Declansator care ar interzice micsorarea ratingului animeului si modificarea campului an_lansare daca acesta nu este null
	--, declansatorul trebuie sa se lanseze doar pentru animeurile studioului 'toei'
--DROP TRIGGER IF EXISTS principal.update_detalii_plus
--GO 
--CREATE TRIGGER principal.update_detalii_plus ON principal.detalii 
--INSTEAD OF UPDATE
--AS

--	DELETE FROM detalii WHERE Id_Anime = ANY(SELECT Id_Anime FROM deleted);
--	INSERT detalii SELECT * FROM inserted;

--	IF 'toei' <> ANY(SELECT Id_Studio FROM deleted)
--		BEGIN
--		PRINT 'NORMAL UPDATE'
--		RETURN;
--		END
--	PRINT 'toei triger'

--	IF (SELECT COUNT(*) FROM inserted) <> 1
--		BEGIN
--		PRINT 'WE DON''T SUPORT MULTIPLE UPDATES AT SAME TIME'
--		RETURN;
--		END

--	IF (SELECT Rating FROM inserted) < (SELECT Rating FROM deleted)
--		UPDATE detalii SET Rating = (SELECT Rating FROM Deleted) WHERE Id_Anime = (SELECT Id_Anime FROM inserted);
	
--	IF (SELECT An_Lansare FROM deleted) IS NOT NULL
--		UPDATE detalii SET An_Lansare = (SELECT An_Lansare FROM Deleted) WHERE Id_Anime = (SELECT Id_Anime FROM inserted);
--GO

--UPDATE detalii SET An_Lansare = NULL
--UPDATE detalii SET Descriere = CONCAT('_', Descriere) WHERE Id_Studio = 'toei'
--UPDATE detalii SET Descriere = CONCAT('_', Descriere) WHERE Id_Anime = 'onepiece'

-- 10.4 Declansator DDL care ar interzice modificarea coloanei titlu si afisarea mesajului respectiv
--DROP TRIGGER IF EXISTS id_anime_trigger ON DATABASE
--GO
--CREATE TRIGGER id_anime_trigger ON DATABASE	
--FOR ALTER_TABLE AS
--		DECLARE @xmltmp xml = (SELECT EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/Alter/Columns)[1]','nvarchar(max)'))
--		PRINT CONVERT(NVARCHAR(MAX), @xmltmp)
--		IF LOWER(CONVERT(NVARCHAR(MAX), @xmltmp)) = 'titlu'
--			ROLLBACK TRANSACTION;

--GO

--alter table principal.anime
--drop constraint uq_titlu;
--alter table principal.anime 
--alter column TITLU nvarchar(50);


-- 10.5 Declansator DDL care ar interzice modificarea schemei bazei de date inafara orelor de lucru
--DROP TRIGGER IF EXISTS ore_de_munca_trigger ON DATABASE
--GO
--CREATE TRIGGER ore_de_munca_trigger ON DATABASE	
--FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE AS
--	DECLARE @START INT = 9, @END INT = 17
--	DECLARE @CURRENT_HOUR INT = (SELECT DATEPART(HOUR, GETDATE()));
--	IF @START > @CURRENT_HOUR OR @END <= @CURRENT_HOUR
--		ROLLBACK TRANSACTION;
--GO
--DROP TABLE auxiliar.episoade;

-- 10.6 Sa se scrie un declansator DDL care la modificarea proprietatilor coloanei Id_Studio va face schimbari asemanatoare in restul tabelelor
DROP TRIGGER IF EXISTS alter_id_studio_everywhere ON DATABASE
GO
CREATE TRIGGER alter_id_studio_everywhere ON DATABASE	
FOR ALTER_TABLE AS
	DECLARE @COLUMN NVARCHAR(MAX) = LOWER(CONVERT(NVARCHAR(MAX),(SELECT EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/Alter/Columns)[1]','nvarchar(max)'))))
	IF @COLUMN = 'id_studio'
		BEGIN
		PRINT 'ALTERING ALL TABLES, WHRE THERE IS A ''ID_STUDIO'' COLUMN'

		DECLARE @COMMAND NVARCHAR(MAX) = CONVERT(NVARCHAR(MAX),(SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')))
		DECLARE @COMMAND2 NVARCHAR(MAX)
		IF CHARINDEX('auxiliar.studio', LOWER(@COMMAND)) > 0
			BEGIN
				PRINT 'auxiliar.studio ALTERATION DETECTED'
				SET @COMMAND2 = REPLACE(LOWER(@COMMAND), 'auxiliar.studio', 'principal.detalii')
				
			END
		IF CHARINDEX('principal.detalii', LOWER(@COMMAND)) > 0
			BEGIN
				PRINT 'principal.detalii ALTERATION DETECTED'
				SET @COMMAND2 = REPLACE(LOWER(@COMMAND),'principal.detalii',  'auxiliar.studio')
			END
		PRINT CONCAT('COMANDA EXECUTATA: ', @COMMAND2,'''')
		EXEC(@COMMAND2)
		END
GO


ALTER TABLE principal.detalii
DROP CONSTRAINT FK_ID_SUTDIO;
ALTER TABLE auxiliar.studio
DROP CONSTRAINT PK_ID_STUDIO;

ALTER TABLE auxiliar.studio
ALTER COLUMN Id_Studio VARCHAR(13)
ALTER TABLE principal.detalii
ALTER COLUMN Id_Studio VARCHAR(15)
