# Vues

- Les vues sont essentiellement des tables virtuelles
- Elles sont une couche au-dessus d'autres tables
- Avec le contrôle d'accès, elles peuvent être utilisées pour assurer différents
  niveaux de confidentialité et de sécurité
- Par exemple, le département des ressources humaines a généralement besoin de
  connaître les numéros d'assurance sociale (NAS) de leurs employés pour les
  déclarer aux différents gouvernements pour les impôts, etc.
- Mais les services informatiques (sauf peut-être les DBA de haut niveau), le
  marketing, etc. ne devraient pas avoir accès aux NAS
- L'accès à la table de base des employés, avec les NAS, peut être accordé à
  certains employés (ou à certains rôles si l'on utilise le contrôle d'accès
  basé sur les rôles)
- Une vue au-dessus de la table des employés peut être créée sans les NAS, et
  l'accès à d'autres employés peut être accordé sur la vue

```sql
drop schema if exists company cascade;
create schema company;
set search_path to company;
create table employee_priv
(
    eid   integer generated always as identity primary key,
    sin   CHAR(9) not null unique,
    name  text    not null,
    phone text
);
insert into employee_priv(sin, name, phone)
values ('123456789', 'Denis', '123-456-7890'),
       ('987654321', 'Jane', '987-654-3210');
select *
from employee_priv;
```

```sql
create or replace view employee AS
select eid, name, phone
from employee_priv;
select *
from employee;
```

```sql
--drop role hr;
--drop role itsupport;
create role hr;
create role itsupport;
grant select, insert, update, delete on employee_priv to hr;
grant select on employee to itsupport;
```

- La création d'utilisateurs et de rôles n'est pas complètement standardisée
  dans tous les SGBDR
- Chaque SGBDR devrait avoir les commandes SQL `grant` et `revoke`
- [PostgreSQL - create user](https://www.postgresql.org/docs/current/sql-createuser.html)
- [PostgreSQL - alter user](https://www.postgresql.org/docs/current/sql-alteruser.html)
- [PostgreSQL - grant](https://www.postgresql.org/docs/current/sql-grant.html)
- Les vues peuvent être créées sur des requêtes couramment utilisées, souvent
  incluant des jointures, pour simplifier l'écriture d'autres requêtes

```sql
set search_path to university;
create or replace view studentcourse as
select s.sid,
       s.name as student_name,
       c.code,
       c.name as course_name,
       o.semester,
       o.year
from student s
         left join enrollment e on s.sid = e.sid
         inner join offering o on e.oid = o.oid
         inner join course c on o.cid = c.cid;
select *
from studentcourse;
```

- Nous pouvons restreindre les lignes de la vue à un étudiant spécifique, pour
  un semestre et une année spécifiques
- cela pourrait être utile lors de la création d'horaires

```sql
select *
from studentcourse
where sid = 3
  and semester = 'W'
  and year = 2020;
```

## Indépendance logique des données

- Les vues peuvent également être utilisées pour minimiser l'impact des
  changements de schéma dans la base de données
- Supposons qu'un schéma de table doive être modifié, éventuellement parce
  qu'une table doit être décomposée pour réduire la redondance en raison d'une
  dépendance fonctionnelle précédemment inconnue
- Ensuite, toutes les requêtes utilisant cette table doivent être mises à jour,
  ce qui pourrait être difficile à faire
- Une vue avec le même nom et les mêmes colonnes peut être créée pour remplacer
  l'ancienne table
- cette vue serait définie sur les nouvelles tables remplaçant l'ancienne table

## Les vues sont-elles modifiables ?

- La meilleure réponse est *peut-être, mais probablement pas* (du moins pas en
  général)
- Si nous voulons mettre à jour le numéro de téléphone d'un employé, nous
  pourrions probablement le faire via la vue, car la vue a une correspondance
  directe avec exactement 1 table, moins la colonne NAS
- la mise à jour peut être redirigée vers la table `employee_priv`
- Mais nous ne pouvons pas insérer une nouvelle ligne dans la vue des employés
  car la table `employee_priv` a la colonne NAS, qui ne peut pas être `null`
- de plus, comme elle a la contrainte `unique`, nous ne pouvons pas la définir
  sur une valeur par défaut
- en fait, nous pourrions la définir sur une valeur par défaut pour au plus 1
  employé
- De même, essayer de mettre à jour la vue `studentcourse` pourrait être
  compliqué car elle provient de la jointure de 4 tables
- mettre à jour 1 ligne dans `studentcourse` pourrait signifier que nous devons
  modifier plusieurs lignes dans 1 ou plusieurs tables sous-jacentes
- si nous essayons de changer l'inscription d'un étudiant à une offre de cours
  via la vue, nous devrons mettre à jour la table d'inscription, qui n'apparaît
  pas directement dans la vue (ses colonnes ne sont pas sélectionnées par la
  requête de la vue)
- même genre de problème pour l'insertion de lignes
- cela pourrait être possible dans certains cas, mais il n'y a pas de moyen
  universel de le faire
- Il y a des problèmes similaires avec la suppression de lignes via une vue
- c'est possible dans certains cas, mais pas tous

