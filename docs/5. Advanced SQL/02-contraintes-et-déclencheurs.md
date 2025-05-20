# Contraintes et Déclencheurs

- Les contraintes peuvent être définies dans les instructions `create table`
- Ou ajoutées aux tables existantes avec les instructions `alter table`
- Différents types de contraintes
    - `null` ou `not null`
    - Clé primaire
    - Unique
    - Clé étrangère
    - Check
    - Domaine
    - Assertion

## Contraintes `null` ou `not null`

- Une colonne peut permettre des valeurs `null`
- Ou les interdire avec `not null`
- Par défaut : permettre des valeurs `null`

## Contraintes de clé primaire

- Une colonne ou un groupe de colonnes peut être désigné comme `primary key` (
  clé primaire)
- Les colonnes de clé primaire ne peuvent pas être `null`
- implicite `not null` pour chaque colonne de clé primaire
- Nous pouvons utiliser une contrainte de colonne si la clé primaire n'a qu'une
  seule colonne
    - `sid integer primary key`
- Si la clé primaire a plus d'une colonne, nous devons utiliser une contrainte
  de table
    - spécifiée après toutes les colonnes dans l'instruction `create table`
    - `primary key(eid, sid)`

## Contraintes uniques

- Comme les clés primaires, mais pour les clés candidates (secondaires)
- Définies de la même manière, mais avec `unique` au lieu de `primary key`
- *Exemple* :
    - ajout d'une contrainte `unique` à la colonne `code` de la table `course`

```sql
set search_path to university;
-- alter table course drop constraint course_code_key;
alter table course
    add unique (code);
```

```sql
insert into course(name, code, credits)
values ('Data Structures', 'DS', 3);
-- delete from course where code = 'DS';
```

## Contraintes de clé étrangère

- Références à d'autres tables
- Se réfère généralement aux clés primaires dans d'autres tables
- Généralement créées pour représenter des relations lors de la traduction d'un
  diagramme ER en schéma relationnel
- Une colonne ou un groupe de colonnes peut être des références à une colonne ou
  un groupe de colonnes dans une autre table
- Nous pouvons utiliser une contrainte de colonne si la clé étrangère n'a qu'une
  seule colonne
    - `sid integer references student(sid)`
- Si la clé étrangère a plus d'une colonne, nous devons utiliser une contrainte
  de table
    - spécifiée après toutes les colonnes dans l'instruction `create table`
    - `foreign key(eid, sid) references enrollment(eid, sid)`

## Politique des contraintes de clé étrangère

- Lorsque nous insérons une nouvelle ligne dans une table avec une clé
  étrangère, la valeur que nous spécifions pour la ou les colonnes de clé
  étrangère doit exister dans l'autre table à laquelle nous nous référons
    - cela est souvent appelé une **contrainte d'intégrité référentielle**
    - cela correspond généralement à une relation *many-exactly-one* (
      plusieurs-exactement-un)
    - exception : si nous permettons des valeurs `null` pour la ou les colonnes
      de clé étrangère, alors les valeurs `null` n'ont pas besoin d'exister dans
      l'autre table
    - et les valeurs `null` n'existeront généralement pas car la ou les colonnes
      auxquelles la clé étrangère se réfère seront généralement des colonnes de
      clé primaire
    - cela correspond généralement à une relation *many-at-most-one* (
      plusieurs-au-plus-un)
- Mais que se passe-t-il lorsque nous supprimons ou mettons à jour une ligne
  dans la table à laquelle la clé étrangère se réfère ?
    - Si la valeur à laquelle la ou les colonnes de clé étrangère se réfèrent
      n'existe plus, que faisons-nous ?
    - Dans les standards SQL, les actions valides sont
        - `RESTRICT`, `CASCADE`, `SET NULL`, `NO ACTION` et `SET DEFAULT`
        - Toutes les actions valides ne sont pas implémentées dans tous les
          SGBDR
    - La politique par défaut des clés étrangères est `RESTRICT`
        - si l'exécution de la mise à jour ou de la suppression laisserait des
          lignes "orphelines" (lignes qui se réfèrent à des valeurs
          inexistantes), alors bloquer la mise à jour ou la suppression et
          renvoyer un message d'erreur
        - `NO ACTION` est un synonyme de `RESTRICT`
    - Si la politique `CASCADE` est définie
        - alors les changements sont propagés aux lignes dépendant de la ligne
          originale
        - si la ligne est supprimée, alors les lignes dépendant d'elle seront
          également supprimées (**très dangereux**)
        - si la ligne est mise à jour, alors les lignes dépendant d'elle seront
          également mises à jour
    - Si la politique est définie sur `SET NULL` ou `SET DEFAULT`, elle
      remplacera les valeurs de la ou des colonnes de clé étrangère par la
      valeur `null` ou par la valeur par défaut, si possible

## Contraintes `check`

- Vérifie une expression avant d'effectuer une insertion ou une mise à jour
    - si l'expression est fausse, alors l'insertion ou la mise à jour échouera
    - sinon, elle réussira
    - attention : si l'expression évalue à `null`, alors l'insertion ou la mise
      à jour réussira
- Si les contraintes `check` se réfèrent à une seule colonne, elles peuvent être
  spécifiées comme une contrainte de colonne
    - `score integer check(score >= 0 and score <= 100)`
- Si les contraintes `check` se réfèrent à 2 colonnes ou plus, elles doivent
  être spécifiées comme une contrainte de table
    - `check(end_date >= start_date)`
    - notez que si l'une des dates est `null`, l'expression sera `null` et la
      vérification passera

## Contraintes de domaine

- Un domaine est utilisé pour restreindre les valeurs possibles pour un type de
  données
- Un domaine
    - peut avoir une valeur par défaut
    - peut être défini avec une contrainte `null` ou `not null`
    - peut avoir une ou plusieurs contraintes `check`
- Un domaine peut être utilisé pour éviter de répéter trop de contraintes, en
  particulier les contraintes `check`
    - `create domain score as integer check(score >= 0 and score <= 100)`

## Assertions

- Contraintes générales qui peuvent s'appliquer à plus d'une ligne d'une table
  ou à des colonnes de plus d'une table
- Comme des contraintes `check` plus générales qui ne sont pas limitées à une
  seule ligne
- La plupart des SGBDR n'ont pas de support complet pour les assertions, voire
  aucun support pour les assertions

## Déclencheurs (_Triggers_)

[trigger_examples.sql](../src/trigger_examples.sql)

- Les déclencheurs sont utilisés dans les bases de données actives
- Ils sont similaires aux *événements* dans une *architecture orientée
  événements*
- Un déclencheur exécute généralement une fonction sur un événement ou des
  événements spécifiques
- La fonction qu'il exécute est similaire à un gestionnaire d'événements
    - par exemple, dans une page HTML, vous pouvez associer une fonction
      JavaScript à un événement `onclick` sur un bouton
    - `Do something`
- Les déclencheurs suivent la *structure ECA* pour définir des *règles actives*
    - **E**vent : signal (déclencheur) invoquant la règle
    - **C**ondition : test logique, détermine si l'action sera exécutée ou non
    - **A**ction : code ou fonction (en SQL, PL/SQL, ou un autre langage
      supporté) s'exécutant sur la base de données
- Le support des déclencheurs varie selon les SGBDR

### Quand utiliser les déclencheurs

- Les déclencheurs peuvent être utilisés pour imposer des contraintes qui ne
  peuvent pas être imposées autrement
    - si les assertions ne sont pas supportées, alors une fonctionnalité
      similaire peut être obtenue avec des déclencheurs...
    - mais les déclencheurs sont plus puissants que les assertions
- Les déclencheurs peuvent être utilisés pour la journalisation
    - si vous voulez (ou devez) conserver des journaux de modifications, alors
      les déclencheurs peuvent aider
    - normalement, lorsque des insertions, mises à jour et suppressions sont
      exécutées sur la base de données, aucune trace ne sera laissée
    - créer des déclencheurs pour insérer des données dans une table de journal
      ou d'historique (ou des tables)
    - plus de détails : https://en.wikipedia.org/wiki/Log_trigger
- Les déclencheurs peuvent être utilisés pour de nombreuses autres choses
    - pour générer/mettre à jour des valeurs pour d'autres colonnes
    - pour mettre à jour une table de statistiques
    - pour auditer des données sensibles
    - pour envoyer des emails aux DBA lors d'événements critiques
    - pour implémenter d'autres règles métier
- De même que la programmation événementielle en JavaScript ou dans d'autres
  langages de programmation, des fonctions doivent être associées à certains
  événements
    - les événements les plus courants sont : `INSERT`, `UPDATE`, et `DELETE`
    - avec un modificateur (spécifié avant l'événement) : `BEFORE` ou `AFTER`
    - L'événement peut être déclenché pour chaque ligne ou pour l'ensemble de la
      déclaration
        - une seule instruction `INSERT`, `UPDATE`, ou `DELETE` peut s'appliquer
          à une ou plusieurs lignes
        - par défaut, nous obtenons un déclencheur au niveau de la déclaration
        - si nous spécifions *FOR EACH ROW*, alors nous obtenons un déclencheur
          au niveau de la ligne
- Par exemple, après avoir inséré les informations d'un nouvel employé dans une
  table `employee`, nous pourrions vouloir créer automatiquement un compte pour
  permettre au nouvel employé de se connecter au système de l'entreprise
    - la création d'un tel compte nécessiterait probablement l'insertion d'une
      ligne dans une table `account`
    - nous avons donc besoin d'un déclencheur `AFTER INSERT` pour cela
    - notez que parfois, cette fonctionnalité est gérée par l'application
      frontale, et non par la base de données
- Un autre exemple : nous pourrions avoir un déclencheur `BEFORE DELETE` pour
  archiver les données supprimées importantes
    - nous pourrions insérer les données supprimées dans une autre table
    - nous pourrions également enregistrer qui a supprimé les données et quand
      elles ont été supprimées

- Malheureusement, les implémentations de déclencheurs varient selon les SGBD
    - Certains ne supportent que des sous-ensembles de la norme, d'autres y
      apportent de petites modifications
- Dans PostgreSQL, les déclencheurs peuvent être créés avec la syntaxe (
  simplifiée) suivante :

```
CREATE TRIGGER trigger_name 
{BEFORE | AFTER | INSTEAD OF} {event [OR ...]}
   ON table_name
   [FOR [EACH] {ROW | STATEMENT}]
       EXECUTE PROCEDURE trigger_function
```

- où `event` peut être `INSERT`, `UPDATE`, `DELETE` ou `TRUNCATE`
- Référez-vous à ces liens pour plus de détails :
    - [https://www.postgresqltutorial.com/creating-first-trigger-postgresql/](https://www.postgresqltutorial.com/creating-first-trigger-postgresql/)
    - [https://www.postgresql.org/docs/14/sql-createtrigger.html](https://www.postgresql.org/docs/14/sql-createtrigger.html)
    - [https://www.postgresql.org/docs/14/triggers.html](https://www.postgresql.org/docs/14/triggers.html)

- Sur MySQL/MariaDB, la syntaxe de base est :

```
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE| DELETE }
ON table_name FOR EACH ROW
trigger_body;
```

- Référez-vous à ces liens pour plus de détails :
    - [https://www.mysqltutorial.org/create-the-first-trigger-in-mysql.aspx](https://www.mysqltutorial.org/create-the-first-trigger-in-mysql.aspx)
    - [https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html](https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html)
    - [https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html](https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html)

- Sur Oracle, les déclencheurs peuvent être créés en utilisant la syntaxe
  suivante :

```
CREATE [OR REPLACE] TRIGGER trigger_name
{BEFORE | AFTER } triggering_event ON table_name
[FOR EACH ROW]
[FOLLOWS | PRECEDES another_trigger]
[ENABLE / DISABLE ]
[WHEN condition]
DECLARE
    declaration statements
BEGIN
    executable statements
EXCEPTION
    exception_handling statements
END;
```

- [https://www.oracletutorial.com/plsql-tutorial/oracle-trigger/](https://www.oracletutorial.com/plsql-tutorial/oracle-trigger/)

- Pour bien utiliser les déclencheurs, nous devons écrire des fonctions ou des
  procédures dans un certain langage de programmation
    - PL/SQL (langage de programmation pour SQL) est supporté sous une certaine
      forme dans la plupart des bases de données relationnelles
    - ou un autre langage de programmation supporté, tel que C
        - PostgreSQL supporte les *types définis par l'utilisateur (UDT)* et les
          *fonctions définies par l'utilisateur (UDF)*
        - Les UDF peuvent être définies en PL/SQL ou en C
        - Les UDF peuvent être utilisées pour les déclencheurs
    - d'autres langages de programmation supportent les langages de
      programmation de différentes manières


