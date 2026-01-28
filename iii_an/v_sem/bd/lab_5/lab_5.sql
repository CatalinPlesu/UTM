-- laboratorul nr 5
USE animeDB;

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
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'index_episoade1')   
    DROP INDEX index_episoade1 ON episoade;   
GO    
CREATE NONCLUSTERED INDEX index_episoade1   
    ON episoade (Id_Episod, Id_Anime);   
GO  