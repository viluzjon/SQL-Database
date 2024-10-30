if exists (select * from sysdatabases where name='Wycieczki')
		drop database BazaDanychPrzewodnikowTurystycznych

CREATE DATABASE BazaDanychPrzewodnikowTurystycznych

GO
---Tabela mająca na celu gromadzić poziomy trudności trasy i ich opisy.
CREATE TABLE TrudnoscTrasy (
	IDTrasy INT IDENTITY (1, 1) NOT NULL ,
	NazwaTrasy NVARCHAR (15) NOT NULL ,
	Opis NTEXT NULL ,
	CONSTRAINT PK_Trasy PRIMARY KEY  CLUSTERED 
	(
		IDTrasy
	)
)
GO
---Tabela mająca gromadzić dane klientów.
CREATE TABLE Klienci (
	IDKlienta NCHAR (5) NOT NULL ,
	Imie NVARCHAR (40) NOT NULL ,
	Nazwisko NVARCHAR (40) NULL ,
	Adres NVARCHAR (60) NULL ,
	Kraj NVARCHAR (15) NULL ,
	Telefon NVARCHAR (24) NULL ,
	CONSTRAINT PK_Klienci PRIMARY KEY  CLUSTERED 
	(
		IDKlienta
	)
)

GO
----Tabela mająca gromadzić dane firm przewozowych.
CREATE TABLE Przewoznicy (
	IDPrzewoznika INT IDENTITY (1, 1) NOT NULL ,
	Nazwa NVARCHAR (40) NOT NULL ,
	Telefon NVARCHAR (24) NULL ,
	CONSTRAINT PK_Przewoznicy PRIMARY KEY  CLUSTERED 
	(
		IDPrzewoznika
	)
)

GO

----Tabela mająca gromadzić dane dotyczące regionów, w których odbywają się wycieczki i trudności ich tras(FK z TrudnoscTrasy).
CREATE TABLE Regiony (
	IDRegionu INT IDENTITY (1, 1) NOT NULL ,
	Nazwa NVARCHAR (40) NOT NULL ,
	IDTrasy INT NOT NULL ,
	CONSTRAINT PK_IDRegionu PRIMARY KEY  CLUSTERED 
	(
		IDRegionu
	),
	CONSTRAINT FK_Rodzaje_Trasy FOREIGN KEY 
	(
		IDTrasy
	) REFERENCES dbo.TrudnoscTrasy (
		IDTrasy
	)
)
GO
----Tabela gromadząca dane przewodników wycieczek (FK z TrudnoscTrasy, CHECK daty urodzenia).
CREATE TABLE Przewodnicy (
	IDPrzewodnika INT IDENTITY (1, 1) NOT NULL ,
	Nazwisko NVARCHAR (20) NOT NULL ,
	Imie NVARCHAR (10) NOT NULL ,
	IDTrasy INT NOT NULL ,
	DataUr DATE NULL ,
	DataZatr DATE NULL ,
	Adres NVARCHAR (60) NULL ,
	Kraj NVARCHAR (15) NULL ,
	Telefon NVARCHAR (24) NULL ,
	Uwagi NTEXT NULL ,
	CONSTRAINT PK_Przewodnicy PRIMARY KEY  CLUSTERED 
	(
		IDPrzewodnika
	),
	CONSTRAINT FK_Przewodnicy_Trasy FOREIGN KEY 
	(
		IDTrasy
	) REFERENCES dbo.TrudnoscTrasy (
		IDTrasy
	),
	CONSTRAINT CK_DataUr CHECK (DataUr < getdate())
)


GO
----Tabela gromadząca dane dotyczące wycieczek (FK z TrudnoscTrasy, Regiony, Przewodnicy, Przewoznicy, CHECK daty, ceny za osobę,
----ilości wolnych i wykupionych miejsc).

CREATE TABLE Wycieczki (
	IDWycieczki INT IDENTITY (1, 1) NOT NULL ,
	NazwaWycieczki NVARCHAR (40) NOT NULL ,
	IDRegionu INT NOT NULL ,
	IDPrzewodnika INT NULL ,
	IDPrzewoznika INT NULL ,
	IDTrasy INT NULL ,
	DataWyjazdu DATE NOT NULL ,
	DataPowrotu DATE NOT NULL ,
	CenaZaOsobe MONEY NULL CONSTRAINT DF_Wycieczki_CenaZaOsobe DEFAULT (300),
	IloscWolnychMiejsc SMALLINT NULL CONSTRAINT DF_Wycieczki_IloscWolnychMiejsc DEFAULT (20),
	WykupioneMiejsca SMALLINT NULL CONSTRAINT DF_Wycieczki_WYkupioneMiejsca DEFAULT (0),
	CONSTRAINT PK_Wycieczki_IDWycieczki PRIMARY KEY  CLUSTERED 
	(
		IDWycieczki
	),
	CONSTRAINT FK_Wycieczki_Trasy FOREIGN KEY 
	(
		IDTrasy
	) REFERENCES dbo.TrudnoscTrasy (
		IDTrasy
	),
	CONSTRAINT FK_Wycieczki_Regiony FOREIGN KEY 
	(
		IDRegionu
	) REFERENCES dbo.Regiony (
		IDRegionu
	),
	CONSTRAINT FK_Wycieczki_Przewodnik FOREIGN KEY 
	(
		IDPrzewodnika
	) REFERENCES dbo.Przewodnicy (
		IDPrzewodnika
	),
		CONSTRAINT FK_Wycieczki_Przewoznik FOREIGN KEY 
	(
		IDPrzewoznika
	) REFERENCES dbo.Przewoznicy (
		IDPrzewoznika
	),
	CONSTRAINT CK_DataWyjazdu CHECK (DataWyjazdu < DataPowrotu),
	CONSTRAINT CK_Wycieczki_CenaZaOsobe CHECK (CenaZaOsobe >= 0),
	CONSTRAINT CK_IloscWolnychMiejsc CHECK (IloscWolnychMiejsc >= 0),
	CONSTRAINT CK_WykupioneMiejsca CHECK (WykupioneMiejsca >= 0)
)


GO
-----Tabela gromadząca dane dotyczące zakupu wycieczek przez klientów (FK z Klienci, Wycieczki, CHECK ilości osób i daty zakupu).
CREATE TABLE SzczegolyZakupu (
	IDZakupu INT IDENTITY (1, 1) NOT NULL ,
	IDKlienta NCHAR (5) NOT NULL ,
	IDWycieczki INT NOT NULL ,
	DataZakupu DATE NULL ,
	IloscOsob INT NOT NULL ,
	Znizka REAL NULL CONSTRAINT DF_SzczegolyZakupu_Znizka DEFAULT (0),
	CONSTRAINT PK_SzczegolyZakupu PRIMARY KEY  CLUSTERED 
	(
		IDZakupu
	),
	CONSTRAINT FK_SzczegolyZakupu_Klienci FOREIGN KEY 
	(
		IDKlienta
	) REFERENCES dbo.Klienci (
		IDKlienta
	),
			CONSTRAINT FK_Wycieczki_Zakupy FOREIGN KEY 
	(
		IDWycieczki
	) REFERENCES dbo.Wycieczki (
		IDWycieczki
	),
	CONSTRAINT CK_IloscOsob CHECK (IloscOsob > 0),
	CONSTRAINT CK_DataZakupu CHECK (DataZakupu <= getdate()),
)


GO

-- Dane do tabeli TrudnoscTrasy.
INSERT INTO TrudnoscTrasy (NazwaTrasy, Opis) VALUES 
(N'Zielona', N' Trasa bardzo łatwa'),
(N'Żółta', N'Trasa łatwa'),
(N'Pomarańczowa', N'Trasa dla średniozaawansowanych'),
(N'Czerwona', N'Trasa trudna')

GO

-- Dane do tabeli Klienci.
INSERT INTO Klienci (IDKlienta, Imie, Nazwisko, Adres, Kraj, Telefon) VALUES 
(N'K001', N'Jan', N'Kowalski', N'123 Ulica', N'Polska', N'123-456-789'),
(N'K002', N'Anna', N'Nowak', N'456 Aleja', N'Niemcy', N'987-654-321'),
(N'K003', N'Piotr', N'Wiśniewski', N'789 Bulwar', N'Francja', N'555-123-456'),
(N'K004', N'Katarzyna', N'Wójcik', N'101 Droga', N'Włochy', N'444-555-666'),
(N'K005', N'Tomasz', N'Kamiński', N'202 Aleja', N'Hiszpania', N'333-444-555'),
(N'K006', N'Magdalena', N'Lewandowska', N'303 Ulica', N'Portugalia', N'222-333-444'),
(N'K007', N'Michał', N'Zieliński', N'404 Droga', N'Polska', N'111-222-333'),
(N'K008', N'Maria', N'Woźniak', N'505 Aleja', N'Niemcy', N'999-888-777'),
(N'K009', N'Krzysztof', N'Kozłowski', N'606 Bulwar', N'Francja', N'777-666-555'),
(N'K010', N'Zofia', N'Jankowska', N'707 Droga', N'Włochy', N'555-444-333')
GO

-- Dane do tabeli Przewoznicy.
INSERT INTO Przewoznicy (Nazwa, Telefon) VALUES 
(N'MarekTrans', N'123 456 789'),
(N'KazikBus', N'234 567 890'),
(N'EwaPrzejazdy', N'345 678 901'),
(N'KasiaBusiki', N'456 789 012')

GO

-- Dane do tabeli Regiony.
INSERT INTO Regiony (Nazwa, IDTrasy) VALUES 
(N'Bieszczady', 1),
(N'Beskidy', 2),
(N'Tatry', 4),
(N'Władysławowo', 1),
(N'Ojcowski Park', 3),
(N'Alpy', 4)
GO
-- Dane do tabeli Przewodnicy.
INSERT INTO Przewodnicy (Nazwisko, Imie, IDTrasy, DataUr, DataZatr, Adres, Kraj, Telefon, Uwagi) VALUES 
(N'Kowalski', N'Jan', 1, '1980-01-01', '2010-01-01', N'123 Ulica', N'Polska', N'123-456-789', N'Nie lubi dzieci.'),
(N'Nowak', N'Anna', 2, '1985-02-02', '2011-02-02', N'456 Aleja', N'Niemcy', N'234-567-890', N'Woli mniejsze wycieczki.'),
(N'Wiśniewski', N'Piotr', 3, '1990-03-03', '2012-03-03', N'789 Bulwar', N'Francja', N'345-678-901', N'Przy zbyt dlugicvh wycieczkach robi się agresywny.'),
(N'Wójcik', N'Katarzyna', 4, '1975-04-04', '2013-04-04', N'101 Droga', N'Włochy', N'456-789-012', N'Zbyt często prosi o podwyżkę.'),
(N'Kamiński', N'Tomasz', 2, '1982-05-05', '2014-05-05', N'202 Aleja', N'Hiszpania', N'567-890-123', N'Nie lubi Jana.')

GO
-- Dane do tabeli Wycieczki.
INSERT INTO Wycieczki (NazwaWycieczki, IDRegionu, IDPrzewodnika, IDPrzewoznika, IDTrasy, DataWyjazdu, DataPowrotu, CenaZaOsobe, IloscWolnychMiejsc) VALUES 
(N'Ogrody Rozpusty', 1, 1, 4, 1, '2024-06-01', '2024-06-07', 1000, 50),
(N'Mityczne Wzgórza',2 , 2, 2, 2, '2024-07-01', '2024-07-05', 800, 40),
(N'Oaza Spokoju', 5 , 3, 3, 3, '2024-08-01', '2024-08-04', 600, 30),
(N'Bohaterski Przesmyk', 3 , 4, 4, 4, '2024-09-01', '2024-09-07', 1200, 20),
(N'Plażowy Relaks', 5 , 2, 2, 3, '2024-10-01', '2024-10-04', 750, 25),
(N'Wyzwanie Pogromców Burz', 2 , 3, 2, 2, '2024-11-01', '2024-11-05', 900, 15),
(N'Letnie Wędrówki z Poezją', 1 , 1, 1, 1, '2024-12-01', '2024-12-06', 950, 35),
(N'Podróż w Siną Dal', 2 , 2, 3, 2, '2025-01-01', '2025-01-07', 1100, 45)


GO

-- Dane do tabeli SzczegolyZakupu.

INSERT INTO SzczegolyZakupu (IDKlienta, IDWycieczki, DataZakupu, IloscOsob, Znizka) VALUES 
(N'K001', 1, '2023-05-01', 2, 0.10),
(N'K002', 2, '2022-06-01', 4, 0.15),
(N'K003', 2, '2022-07-01', 1, 0.05),
(N'K004', 4, '2023-08-01', 3, 0.20),
(N'K005', 3, '2022-09-01', 2, 0.00),
(N'K006', 2, '2020-10-01', 5, 0.25),
(N'K007', 8, '2023-11-01', 1, 0.10),
(N'K008', 7, '2022-12-01', 3, 0.15),
(N'K009', 2, '2022-01-01', 2, 0.05),
(N'K010', 2, '2021-02-01', 4, 0.20)
GO
----Widok mający na celu pokazać klienta oraz wycieczki które zakupił wraz z ich szczegółami.

CREATE VIEW KlienciWycieczki AS
SELECT 
    k.Imie,
    k.Nazwisko,
    sz.IDWycieczki,
    sz.DataZakupu,
    sz.IloscOsob,
    wy.NazwaWycieczki,
    tr.NazwaTrasy,
    tr.Opis
FROM 
    Klienci k
INNER JOIN 
    SzczegolyZakupu sz ON k.IDKlienta = sz.IDKlienta
INNER JOIN
    Wycieczki wy ON wy.IDWycieczki = sz.IDWycieczki
INNER JOIN
    TrudnoscTrasy tr ON tr.IDTrasy = wy.IDTrasy


GO

SELECT * FROM KlienciWycieczki

----Widok mający na celu wyświetlić miesięczną sprzedaż i przychód.

CREATE VIEW MiesiecznaSprzedaz AS
SELECT 
    YEAR(SZ.DataZakupu) AS SprzedarzRok,
    MONTH(SZ.DataZakupu) AS SprzedarzMiesiac,
    SUM(SZ.IloscOsob) AS SprzedaneBilety,
	SUM(ROUND(SZ.IloscOsob * W.CenaZaOsobe * CAST((1 - SZ.Znizka) AS MONEY),2)) AS Przychod
FROM 
    Wycieczki W INNER JOIN SzczegolyZakupu SZ ON W.IDWycieczki = SZ.IDWycieczki
GROUP BY 
    YEAR(DataZakupu),
    MONTH(DataZakupu)
GO


SELECT * FROM MiesiecznaSprzedaz

-----Widok mający na celu pokazać, jacy przewodnicy są nieprzypisani do żadnej wycieczki.

GO
CREATE VIEW PrzewodnicyBezWycieczek AS
    SELECT P.IDPrzewodnika
    FROM Przewodnicy P
    WHERE NOT EXISTS (
        SELECT 1
        FROM Wycieczki W
        WHERE W.IDPrzewodnika = P.IDPrzewodnika
    )
GO

SELECT * FROM PrzewodnicyBezWycieczek 

---Funkcja mająca na celu wyświetlić cenę wycieczki której ID podane jest jako parametr.

CREATE FUNCTION F_CenaWycieczki (@IDWycieczki INT)
RETURNS TABLE
AS
RETURN
(
    SELECT W.NazwaWycieczki, W.CenaZaOsobe
    FROM Wycieczki W
    WHERE W.IDWycieczki = @IDWycieczki
)
GO


SELECT * FROM F_CenaWycieczki('2')

----Funkcja zwracająca dostępność przewodnika w przedziale czesowym podanym jako parametry.

GO
CREATE FUNCTION  F_WolniPrzewodnicy (@StartDate DATE, @EndDate DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT P.IDPrzewodnika, P.Nazwisko, P.Imie
    FROM Przewodnicy P
    WHERE NOT EXISTS (
        SELECT 1
        FROM Wycieczki W
        WHERE W.IDPrzewodnika = P.IDPrzewodnika
        AND (
            (W.DataWyjazdu BETWEEN @StartDate AND @EndDate)
            OR (W.DataPowrotu BETWEEN @StartDate AND @EndDate)
            OR (@StartDate BETWEEN W.DataWyjazdu AND W.DataPowrotu)
            OR (@EndDate BETWEEN W.DataWyjazdu AND W.DataPowrotu)
        )
    )
)
GO

SELECT * FROM F_WolniPrzewodnicy('2023-07-01', '2024-07-15')


-----Prodecura wyświetlająca wycieczki o danej jako parametr trudności trasy oraz ich ceny.

GO
CREATE PROCEDURE Proc_TrudnoscTrasy (
    @NazwaTrasy NVARCHAR(15)
) 
AS
BEGIN
    DECLARE @IdentyfikatorTrasyOZadanejNazwie INT = (
        SELECT TT.IDTrasy
        FROM TrudnoscTrasy TT
        WHERE TT.NazwaTrasy = @NazwaTrasy
    )
	IF @IdentyfikatorTrasyOZadanejNazwie IS NULL
    BEGIN
        RAISERROR('Nie ma trasy o podanej nazwie.', 16, 1)
        RETURN
    END

    SELECT W.NazwaWycieczki, W.CenaZaOsobe
    FROM Wycieczki W
    WHERE W.IDTrasy = @IdentyfikatorTrasyOZadanejNazwie;
END
GO

EXECUTE Proc_TrudnoscTrasy 'Zielona'
EXECUTE Proc_TrudnoscTrasy 'Czerwona'
EXECUTE Proc_TrudnoscTrasy 'Fioletowa'

-----Trigger mający na celu zaktualizować ilość wolnych i wykupionych miejsc na danej wycieczce po wstawieniu 
-----wiersza/wierszy do tabeli SzczegolyZakupu, oraz zapobiec wykupieniu większej ilości miejsc niż dostępne.

GO
CREATE TRIGGER TR_SzczegolyZakupu_Wycieczki_AFTER_INSERT ON SzczegolyZakupu AFTER INSERT AS
    IF (
      NOT EXISTS ( 
        SELECT *
        FROM
          Wycieczki W INNER JOIN (
            SELECT I.IDWycieczki, SUM(I.IloscOsob) IloscBiletow
            FROM INSERTED I
            GROUP BY I.IDWycieczki
          ) S ON (S.IDWycieczki = W.IDWycieczki)
        WHERE (S.IloscBiletow > W.IloscWolnychMiejsc)
      )
    )
      UPDATE W
      SET W.IloscWolnychMiejsc -= S.IloscBiletow,
		  W.WykupioneMiejsca += S.IloscBiletow
      FROM
        Wycieczki W INNER JOIN (
          SELECT I.IDWycieczki, SUM(I.IloscOsob) IloscBiletow
          FROM INSERTED I
          GROUP BY I.IDWycieczki
        ) S ON (S.IDWycieczki = W.IDWycieczki)
    ELSE
	  ROLLBACK      
GO

SELECT * FROM Wycieczki
GO
INSERT INTO SzczegolyZakupu (IDKlienta, IDWycieczki, DataZakupu, IloscOsob, Znizka) VALUES 
(N'K001', 1, '2023-05-01', 44, 0.10)
GO
INSERT INTO SzczegolyZakupu (IDKlienta, IDWycieczki, DataZakupu, IloscOsob, Znizka) VALUES 
(N'K001', 2, '2023-05-01', 1, 0.10),
(N'K002', 3, '2023-05-05', 1, 0.15)
GO

----Funkcja łącząca turystów w grupy przypisane do przewodnika.

CREATE FUNCTION F_GrupaPrzewodnika (@IDPrzewodnika INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        K.Imie, 
        K.Nazwisko, 
        W.IDPrzewodnika
    FROM 
        Klienci K
    INNER JOIN 
        SzczegolyZakupu SZ ON SZ.IDKlienta = K.IDKlienta
    INNER JOIN 
        Wycieczki W ON W.IDWycieczki = SZ.IDWycieczki
    WHERE 
        W.IDPrzewodnika = @IDPrzewodnika
)
GO

SELECT * FROM F_GrupaPrzewodnika(1)

----Funkcja wyświetlająca przewodników i ich wycieczki.

CREATE FUNCTION F_WycieczkiPrzewodnika (@IDPrzewodnika INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.Imie, 
        P.Nazwisko, 
		W.NazwaWycieczki,
		W.DataWyjazdu,
		W.DataPowrotu
    FROM 
        Przewodnicy P
    INNER JOIN 
        Wycieczki W ON W.IDPrzewodnika = P.IDPrzewodnika
    WHERE 
        W.IDPrzewodnika = @IDPrzewodnika
)
GO

SELECT * FROM F_WycieczkiPrzewodnika (2)