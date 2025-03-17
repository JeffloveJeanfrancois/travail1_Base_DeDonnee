

/* Nom(s) : Fabrice Kouakou & Jeff-Love Jean Francois */


/* PARTIE 2 */
/* d�truit la bd si elle existe */

use master
go
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Bd_Reseau')
BEGIN
    ALTER DATABASE Bd_Reseau SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	drop database Bd_Reseau
END


/* cr�ation de votre bd  */

CREATE DATABASE Bd_Reseau
go

Use Bd_Reseau
go

/* cr�ation de vos tables simples */

create table tbl_compagnie(
id_compagnie int primary key,
nom nvarchar(200) unique
)
go

create table tbl_piece(
id_piece int identity primary key,
description nvarchar(200),
type nvarchar(200),
marqueModele nvarchar(200),
numeroIndustrie nvarchar(200) unique,
caracteristiques nvarchar(200)
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



/*	4- Cas �u toutes les contraintes sont d�finis DANS le create de la table, 
	auncune contrainte apr�s le create (dans le cas d'une table avec une cl� �trang�re) */

	create table tbl_projet(
	id_projet int identity primary key,
	nom nvarchar(200) unique,
	description nvarchar(200), 
	id_compagnie int references tbl_compagnie(id_compagnie) not null
	)
	go

	create table tbl_stock(
	id_stock int identity primary key, 
	quantite_stock int,
	quantite_prevu int,
	check (quantite_stock >= 0),
	Check (quantite_prevu >= 0),
	id_piece int references tbl_piece(id_piece) not null,
	id_projet int references tbl_projet(id_projet) not null,
	constraint UQ_projetPiece unique (id_piece, id_projet)
	)
	go


/*  5- Cas o� toutes les contraintes sont d�finis APR�S la creation de la table (dans le cas d'une table avec cl� �trang�re)*/
	
		/* contraintes APRES la c�ation de la derni�re table */

		create table tbl_impute(
		id_employee int not null,
		id_stock int not null,
		quantite_impute int,
		date_imputee date
		)
		go

		alter table tbl_impute
		add constraint FK_impute_employee foreign key (id_employee) references tbl_employee(id_employee),
		constraint FK_impute_stock foreign key (id_stock) references tbl_stock(id_stock),
		constraint CK_quantiteImpute Check (quantite_impute >= 0),
		constraint Dt_dateImpute check (date_imputee <= getDate())

		go


 --pour ajouter les piece il faut prendre ceux qui n'ont pas de generique 
  
/* 10-m'assure qu'il n'y a pas 2 pi�ces pareils pour un projet */ --voir question 4
/* 11- unicit� */ --voir question 4


/* PARTIE 3 */
/* 2. a) insertion de donn�es en batch � partir de bdDonnee pour les employes */

insert into tbl_employee(prenom, nom, email) select Pr�nom, Nom, [Adresse Email] from BDDonneesTP.DBO.employe$
go

/* 2. b) insertion de donn�es en batch � partir de bdDonnee pour les pieces de votre sujet */

insert into tbl_piece(description, numeroIndustrie) select Description, [Num�ro de Pi�ce] from BDDonneesTP.DBO.reseau$
go

/* 2. c) pratique cross apply : trouver les employ�s qui ont un nom et pr�nom identique � d�autres. */




select e.nom, e.prenom, e.email
from tbl_employee e cross apply (select* from tbl_employee 
where tbl_employee.nom = e.nom 
and tbl_employee.prenom <> e.prenom  
and tbl_employee.id_employee <> e.id_employee) employeeIdentique 
ORDER BY e.nom, e.prenom;
go

/* 3. ajout de donn�es, au moins 3 dans chaque table */

/* 3. a)	Pour la table de projet, ajouter 4 donn�es dont 2 pour la m�me compagnie */

INSERT INTO tbl_compagnie (id_compagnie, nom) VALUES
(1, 'HyperNet Solutions'),
(2, 'Infinity Network Systems'),
(3, 'FiberLink Technologies'),
(4, 'SkyBridge Communications'),
(5, 'CoreConnect Networks');
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

/* 3. b)	Pour la table des projets-pi�ces, faites des ajouts pour 2 projets diff�rents et pour chacun utiliser au moins 3 pi�ces diff�rentes. 
			Une m�me pi�ce sera dans les 2 projets*/
			
INSERT INTO tbl_stock (id_projet, id_piece)
SELECT p.id_projet, pi.id_piece
FROM tbl_projet p
JOIN tbl_piece pi ON pi.description IN ('Netgear Nighthawk RAX120', 'Cable Matters Cat 6a', 'Axis Q6115-E PTZ Camera')
WHERE p.nom = 'Projet Alpha';
go

INSERT INTO tbl_stock (id_projet, id_piece)
SELECT p.id_projet, pi.id_piece
FROM tbl_projet p
JOIN tbl_piece pi ON pi.description IN ('Cable Matters Cat 6a', 'Asus XG-C100C', 'Belkin Patch Cable Cat6a 1m')
WHERE p.nom = 'Projet Beta';
go


/* 3. c)	Pour la table d�imputation, utiliser comme employ�, un employ� ayant le m�me nom qu�un autre. 			
			Pour un m�me projet,un des employ�s aura 2 imputations et l�autre une. 
			Ajouter 3 imputations pour le m�me projet.
			Ajouter 2 pi�ces diff�rentes parmi celles import�es et une pareille. Bien entendu, ce doit �tre les pi�ces d�j� associ�es � ce projet (projets-pi�ces). 
			Assurez-vous que ce soit toujours la date d�aujourd�hui lorsque vous ex�cutez votre script.
			*/



INSERT INTO [dbo].[tbl_impute] 
    ([id_employee], [id_stock], [quantite_impute], [date_imputee])


SELECT e1.id_employee, s1.id_stock, 5, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s1 ON s1.id_piece = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Alpha')
WHERE e1.nom = 'Tremblay' AND e1.prenom = '�milie' AND e2.prenom = 'Jean-Fran�ois'
AND s1.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Netgear Nighthawk RAX120')

UNION ALL


SELECT e1.id_employee, s2.id_stock, 7, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s2 ON s2.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Alpha')
WHERE e1.nom = 'Tremblay' AND e1.prenom = '�milie' AND e2.prenom = 'Jean-Fran�ois'
AND s2.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Cable Matters Cat 6a')

UNION ALL


SELECT e2.id_employee, s3.id_stock, 10, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s3 ON s3.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Alpha') 
WHERE e1.nom = 'Tremblay' AND e1.prenom = '�milie' AND e2.prenom = 'Jean-Fran�ois'
AND s3.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Netgear Nighthawk RAX120') 

go


/* c) m�me chose pour un 2e projet */ 

INSERT INTO [dbo].[tbl_impute] 
    ([id_employee], [id_stock], [quantite_impute], [date_imputee])


SELECT e1.id_employee, s1.id_stock, 3, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s1 ON s1.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Beta')
WHERE e1.nom = 'Adams' AND e1.prenom = 'Nora' AND e2.prenom = 'Pandora'
AND s1.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Cable Matters Cat 6a')

UNION ALL


SELECT e1.id_employee, s2.id_stock, 5, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s2 ON s2.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Beta')
WHERE e1.nom = 'Adams' AND e1.prenom = 'Nora' AND e2.prenom = 'Pandora'
AND s2.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Axis Q6115-E PTZ Camera')

UNION ALL


SELECT e2.id_employee, s3.id_stock, 11, GETDATE()
FROM tbl_employee e1
INNER JOIN tbl_employee e2 ON e1.nom = e2.nom AND e1.id_employee <> e2.id_employee
INNER JOIN tbl_stock s3 ON s3.id_projet = (select tbl_projet.id_projet from tbl_projet where nom = 'Projet Beta')
WHERE e1.nom = 'Adams' AND e1.prenom = 'Nora' AND e2.prenom = 'Pandora'
AND s3.id_piece = (select tbl_piece.id_piece from tbl_piece where description = 'Cable Matters Cat 6a')

go


/* 4. un select des tables pour prouver les bons ajouts */

select* from tbl_impute 

select* from tbl_stock



/* 5.	Faites une instruction SQL qui vous affiche, pour chaque pi�ce, le nombre d�imputations r�alis� en tout dans le magasin, 
		la quantit� totale de pi�ces imput�es, 
		et le nombre de projets dont elle fait partie. (Select avanc�).
*/
/* 6. tests de contrainte  */
/* contrainte CHECK sur email */	

/* contrainte CHECK sur quantitePrevu */	

/* contrainte CHECK sur quantiteStock */
	
/* contrainte CHECK sur quantitePieceImpute */

/* contrainte sur dateImputation */
	
/* m'assure qu'il n'y a pas 2 pi�ces pareils pour un projet */
	
/* La description d�un projet ne pourra pas �tre identique � un autre projet*/

/* le nom de compagnie ne peut pas �tre identique � une autre compagnie */

/* les num�ros d�une pi�ce de l�industrie doivent �tre tous diff�rents*/





