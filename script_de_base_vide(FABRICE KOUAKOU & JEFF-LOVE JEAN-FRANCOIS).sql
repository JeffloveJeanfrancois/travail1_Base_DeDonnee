

/* Nom(s) : Fabrice Kouakou & Jeff-Love Jean Francois */


/* PARTIE 2 */
/* détruit la bd si elle existe */

use master
go
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Bd_Reseau')
BEGIN
    ALTER DATABASE Bd_Reseau SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	drop database Bd_Reseau
END


/* création de votre bd  */

CREATE DATABASE Bd_Reseau
go

Use Bd_Reseau
go

/* création de vos tables simples */

create table tbl_compagnie(
id_compagnie int identity primary key,
nom nvarchar(200) unique
)
go

create table tbl_piece(
id_piece int identity primary key,
description nvarchar(200),
numeroIndustrie nvarchar(200) unique
)
go

create table tbl_employee(
id_employee int identity primary key,
nom nvarchar(200),
prenom nvarchar(200),
email nvarchar(200) null 
)
go


/* 9- modification d'un null en not null */

alter table tbl_employee
alter column email nvarchar(200) not null
go

alter table tbl_employee 
add constraint UQ_email unique (email)
go

alter table tbl_employee
add constraint Ck_email Check (email like '%[@]%')
go



/*	4- Cas òu toutes les contraintes sont définis DANS le create de la table, 
	auncune contrainte après le create (dans le cas d'une table avec une clé étrangère) */

	create table tbl_projet(
	id_projet int identity primary key,
	nom nvarchar(200) unique,
	description nvarchar(200) unique, 
	id_compagnie int references tbl_compagnie(id_compagnie) not null
	)
	go

	create table tbl_stock(
	id_stock int identity primary key, 
	quantite_stock int,
	quantite_prevu int,
	check (quantite_stock >= 0),
	Check (quantite_prevu > 0),
	id_piece int references tbl_piece(id_piece) not null,
	id_projet int references tbl_projet(id_projet) not null,
	constraint UQ_projetPiece unique (id_piece, id_projet)
	)
	go


/*  5- Cas où toutes les contraintes sont définis APRÈS la creation de la table (dans le cas d'une table avec clé étrangère)*/
	
		/* contraintes APRES la céation de la dernière table */

		create table tbl_impute(
		id_impute int identity primary key, 
		id_employee int not null,
		id_stock int not null,
		quantite_impute int,
		date_imputee date
		)
		go

		alter table tbl_impute
		add constraint FK_impute_employee foreign key (id_employee) references tbl_employee(id_employee),
		constraint FK_impute_stock foreign key (id_stock) references tbl_stock(id_stock),
		constraint CK_quantiteImpute Check (quantite_impute > 0),
		constraint Dt_dateImpute check (date_imputee <= getDate())

		go


 --pour ajouter les piece il faut prendre ceux qui n'ont pas de generique 
  
/* 10-m'assure qu'il n'y a pas 2 pièces pareils pour un projet */ --voir question 4
/* 11- unicité */ --voir question 4


/* PARTIE 3 */
/* 2. a) insertion de données en batch à partir de bdDonnee pour les employes */

insert into tbl_employee(prenom, nom, email) select Prénom, Nom, [Adresse Email] from BDDonneesTP.DBO.employe$
go

/* 2. b) insertion de données en batch à partir de bdDonnee pour les pieces de votre sujet */

insert into tbl_piece(description, numeroIndustrie) select Description, [Numéro de Pièce] from BDDonneesTP.DBO.reseau$
go

/* 2. c) pratique cross apply : trouver les employés qui ont un nom et prénom identique à d’autres. */




select distinct e.nom, e.prenom, e.email
from tbl_employee e cross apply (select* from tbl_employee 
where tbl_employee.nom = e.nom 
and tbl_employee.prenom = e.prenom  
and tbl_employee.id_employee <> e.id_employee) employeeIdentique 
ORDER BY e.nom, e.prenom;
go

/* 3. ajout de données, au moins 3 dans chaque table */

/* 3. a)	Pour la table de projet, ajouter 4 données dont 2 pour la même compagnie */

INSERT INTO tbl_compagnie (nom) VALUES
('HyperNet Solutions'),
('Infinity Network Systems'),
('FiberLink Technologies'),
('SkyBridge Communications'),
('CoreConnect Networks');
go


insert into tbl_projet(nom, description, id_compagnie)
select 
    'Projet Alpha', 'Description du projet Alpha', c.id_compagnie
from tbl_compagnie c
where c.nom = 'HyperNet Solutions'

union all

select 
    'Projet Beta', 'Description du projet Beta', c.id_compagnie
from tbl_compagnie c
where c.nom = 'Infinity Network Systems'

union all

select 
    'Projet Gamma', 'Description du projet Gamma', c.id_compagnie
from tbl_compagnie c
where c.nom = 'HyperNet Solutions'

union all

select 
    'Projet Delta', 'Description du projet Delta', c.id_compagnie
from tbl_compagnie c
where c.nom = 'FiberLink Technologies';

go

/* 3. b)	Pour la table des projets-pièces, faites des ajouts pour 2 projets différents et pour chacun utiliser au moins 3 pièces différentes. 
			Une même pièce sera dans les 2 projets*/
			
INSERT INTO tbl_stock (id_projet, id_piece, quantite_prevu, quantite_stock)
SELECT p.id_projet, pi.id_piece, 55, 100
FROM tbl_projet p
JOIN tbl_piece pi ON pi.description IN ('Netgear Nighthawk RAX120', 'Cable Matters Cat 6a', 'Axis Q6115-E PTZ Camera')
WHERE p.nom = 'Projet Alpha';
go

INSERT INTO tbl_stock (id_projet, id_piece, quantite_prevu, quantite_stock)
SELECT p.id_projet, pi.id_piece, 70, 250
FROM tbl_projet p
JOIN tbl_piece pi ON pi.description IN ('Cable Matters Cat 6a', 'Asus XG-C100C', 'Belkin Patch Cable Cat6a 1m')
WHERE p.nom = 'Projet Beta';
go


/* 3. c)	Pour la table d’imputation, utiliser comme employé, un employé ayant le même nom qu’un autre. 			
			Pour un même projet,un des employés aura 2 imputations et l’autre une. 
			Ajouter 3 imputations pour le même projet.
			Ajouter 2 pièces différentes parmi celles importées et une pareille. Bien entendu, ce doit être les pièces déjà associées à ce projet (projets-pièces). 
			Assurez-vous que ce soit toujours la date d’aujourd’hui lorsque vous exécutez votre script.
			*/



INSERT INTO [dbo].[tbl_impute] 
    ([id_employee], [id_stock], [quantite_impute], [date_imputee])



select (select distinct id_employee from tbl_employee e1 where  e1.nom = 'Tremblay' 
AND e1.prenom = 'Émilie' 
AND e1.email = 'emilie.trem@gmail.com'), tbl_stock.id_stock,  5, GETDATE()
from tbl_stock 
inner join tbl_projet on tbl_stock.id_projet = tbl_projet.id_projet 
inner join tbl_piece on tbl_piece.id_piece = tbl_stock.id_piece
where tbl_stock.id_piece in (SELECT id_piece FROM tbl_piece WHERE description = 'Netgear Nighthawk RAX120')
and tbl_stock.id_projet in (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Alpha')

UNION ALL

SELECT (select distinct id_employee from tbl_employee e1 where  e1.nom = 'Tremblay' 
AND e1.prenom = 'Émilie' 
AND e1.email = 'emilie.trem@gmail.com'), tbl_stock.id_stock,  5, GETDATE()
FROM tbl_stock 
inner join tbl_projet on tbl_stock.id_projet = tbl_projet.id_projet 
inner join tbl_piece on tbl_piece.id_piece = tbl_stock.id_piece
where tbl_stock.id_piece = (SELECT id_piece FROM tbl_piece WHERE description = 'Cable Matters Cat 6a') 
and tbl_stock.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Alpha')

UNION ALL

SELECT TOP 1 e2.id_employee, tbl_stock.id_stock, 5, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom 
                           AND e1.prenom = e2.prenom 
                           AND e1.id_employee <> e2.id_employee 
                           AND e2.email <> 'emilie.trem@gmail.com'  -- S'assurer que c'est un autre email
INNER JOIN tbl_stock ON tbl_stock.id_projet = (SELECT id_projet FROM tbl_projet WHERE nom = 'Projet Alpha')
INNER JOIN tbl_piece ON tbl_piece.id_piece = tbl_stock.id_piece
WHERE tbl_stock.id_piece IN (SELECT id_piece FROM tbl_piece WHERE description = 'Netgear Nighthawk RAX120')
AND e1.nom = 'Tremblay' 
AND e1.prenom = 'Émilie'






/* c) même chose pour un 2e projet */ 

INSERT INTO [dbo].[tbl_impute] 
    ([id_employee], [id_stock], [quantite_impute], [date_imputee])



select (select distinct id_employee from tbl_employee e1 where  e1.nom = 'Bergeron' 
AND e1.prenom = 'Michel' 
AND e1.email = 'mbergeron@gmail.com'), tbl_stock.id_stock,  5, GETDATE()
from tbl_stock 
inner join tbl_projet on tbl_stock.id_projet = tbl_projet.id_projet 
inner join tbl_piece on tbl_piece.id_piece = tbl_stock.id_piece
where tbl_stock.id_piece in (SELECT id_piece FROM tbl_piece WHERE description = 'Belkin Patch Cable Cat6a 1m')
and tbl_stock.id_projet in (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Beta')

UNION ALL

SELECT (select distinct id_employee from tbl_employee e1 where  e1.nom = 'Bergeron' 
AND e1.prenom = 'Michel' 
AND e1.email = 'mbergeron@gmail.com'), tbl_stock.id_stock,  5, GETDATE()
FROM tbl_stock 
inner join tbl_projet on tbl_stock.id_projet = tbl_projet.id_projet 
inner join tbl_piece on tbl_piece.id_piece = tbl_stock.id_piece
where tbl_stock.id_piece = (SELECT id_piece FROM tbl_piece WHERE description = 'Asus XG-C100C') 
and tbl_stock.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Beta')

UNION ALL

SELECT TOP 1 e2.id_employee, tbl_stock.id_stock, 5, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom 
                           AND e1.prenom = e2.prenom 
                           AND e1.id_employee <> e2.id_employee 
                           AND e2.email <> 'mbergeron@gmail.com'  -- S'assurer que c'est un autre email
INNER JOIN tbl_stock ON tbl_stock.id_projet = (SELECT id_projet FROM tbl_projet WHERE nom = 'Projet Beta')
INNER JOIN tbl_piece ON tbl_piece.id_piece = tbl_stock.id_piece
WHERE tbl_stock.id_piece IN (SELECT id_piece FROM tbl_piece WHERE description = 'Belkin Patch Cable Cat6a 1m')
AND e1.nom = 'Bergeron' 
AND e1.prenom = 'Michel'


/* 4. un select des tables pour prouver les bons ajouts */

SELECT        tbl_compagnie.nom, tbl_employee.nom AS Expr1, tbl_employee.prenom, tbl_employee.email, tbl_impute.quantite_impute, tbl_impute.date_imputee, tbl_piece.description, 
                         tbl_piece.numeroIndustrie, tbl_impute.id_employee, tbl_impute.id_stock, tbl_projet.nom AS Expr2, tbl_projet.description AS Expr3, tbl_projet.id_compagnie, tbl_stock.quantite_stock, 
                         tbl_stock.quantite_prevu, tbl_stock.id_piece, tbl_stock.id_projet
FROM            tbl_projet INNER JOIN
                         tbl_compagnie ON tbl_projet.id_compagnie = tbl_compagnie.id_compagnie INNER JOIN
                         tbl_stock ON tbl_projet.id_projet = tbl_stock.id_projet INNER JOIN
                         tbl_piece ON tbl_stock.id_piece = tbl_piece.id_piece INNER JOIN
                         tbl_impute INNER JOIN
                         tbl_employee ON tbl_impute.id_employee = tbl_employee.id_employee ON tbl_stock.id_stock = tbl_impute.id_stock


/* 5.	Faites une instruction SQL qui vous affiche, pour chaque pièce, le nombre d’imputations réalisé en tout dans le magasin, 
		la quantité totale de pièces imputées, 
		et le nombre de projets dont elle fait partie. (Select avancé).
*/

SELECT 
    p.id_piece, 
    p.description, 
    statistiques.nombre_imputations, 
    statistiques.quantite_totale_imputee, 
    statistiques.nombre_projets
FROM tbl_piece p
INNER JOIN (
    SELECT 
        s.id_piece,
        COUNT(i.id_stock) AS nombre_imputations,
        SUM(i.quantite_impute) AS quantite_totale_imputee,
        COUNT(DISTINCT s.id_projet) AS nombre_projets
    FROM tbl_stock s
    INNER JOIN tbl_impute i ON s.id_stock = i.id_stock
    GROUP BY s.id_piece
) statistiques ON p.id_piece = statistiques.id_piece;


/* 6. tests de contrainte  */
/* contrainte CHECK sur email */	

	--alter table tbl_employee
	--add constraint Ck_email Check (email like '%[@]%')

	--INSERT INTO tbl_employee(email) VALUES ('jeffLoveGmail.com')

/* contrainte CHECK sur quantitePrevu */	

	--Check (quantite_prevu >= 0 a voir un peu plus haut dans la table stock

	--INSERT INTO tbl_stock (id_piece, id_projet,  quantite_prevu) VALUES (4, 1, -5)

/* contrainte CHECK sur quantiteStock */

	--Check (quantite_stock >= 0) voir plus haut dans la table stock

	--INSERT INTO tbl_stock (id_piece, id_projet,  quantite_stock) VALUES (4, 1, -2)
	
/* contrainte CHECK sur quantitePieceImpute */

	--constraint CK_quantiteImpute Check (quantite_impute > 0)

	--INSERT INTO tbl_impute (id_employee, id_stock, quantite_impute) VALUES (1, 1, 0);


/* contrainte sur dateImputation */

	--constraint Dt_dateImpute check (date_imputee <= getDate())

	--INSERT INTO tbl_impute (id_employee, id_stock, date_imputee) VALUES (1, 1, '2030-01-01')
	
/* m'assure qu'il n'y a pas 2 pièces pareils pour un projet */

	--constraint UQ_projetPiece unique (id_piece, id_projet)

	--INSERT INTO tbl_stock (id_piece, id_projet) VALUES (1, 1)
	
/* La description d’un projet ne pourra pas être identique à un autre projet*/

	--description nvarchar(200) unique voir creation de la table projet plus haut 

	--INSERT INTO tbl_projet (nom, description, id_compagnie) VALUES ('Projet X', 'Description du projet Alpha', 3)

/* le nom de compagnie ne peut pas être identique à une autre compagnie */

	--nom nvarchar(200) unique
	--INSERT INTO tbl_compagnie(nom) VALUES ('HyperNet Solutions')

/* les numéros d’une pièce de l’industrie doivent être tous différents*/

	--numeroIndustrie nvarchar(200) unique
	--INSERT INTO tbl_piece (numeroIndustrie) VALUES ('RAX120-100NAS')





