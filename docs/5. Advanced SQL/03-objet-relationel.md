# Modèle objet-relationel

_ORDBMS_ : Object-Relational DBMS

## Contacts normalisés

### `contacts1` Schéma relationnel

```sql
DROP SCHEMA IF EXISTS contacts1 CASCADE;
CREATE SCHEMA contacts1;
SET search_path TO contacts1;

CREATE TABLE users
(
    uid               INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username          VARCHAR(15) NOT NULL,
    email             TEXT        NOT NULL,
    firstname         TEXT,
    lastname          TEXT,
    emergency_contact TEXT
);
```

```sql
INSERT INTO users (username, email, emergency_contact)
VALUES ('denis', 'denis.rinfret@example.com', 'help@example.com'),
       ('minh', 'minh@example.com', 'contact@example.com');
```

```sql
SELECT *
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
        <th>emergency_contact</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>help@example.com</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>contact@example.com</td>
    </tr>
</table>

### Que devons-nous faire pour permettre à un utilisateur d'avoir plus d'un contact ?

1. Si le nombre de contacts est fixe, disons `n` contacts, alors nous pourrions
   avoir `n` colonnes de contacts, tant que `n` est petit.
2. Mais si `n` n'est pas petit ou si `n` est inconnu, alors nous devons avoir
   une autre table, une table contacts, pour préserver la première forme
   normale.
3. La première forme normale stipule que chaque valeur de colonne doit être
   atomique.

### `contacts2` Schéma relationnel

```sql
DROP SCHEMA IF EXISTS contacts2 CASCADE;
CREATE SCHEMA contacts2;
SET search_path TO contacts2;

CREATE TABLE users
(
    uid       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username  VARCHAR(15) NOT NULL,
    email     TEXT        NOT NULL,
    firstname TEXT,
    lastname  TEXT
);

CREATE TABLE contacts
(
    cid   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL,
    uid   INTEGER REFERENCES users (uid)
)
```

```sql
 INSERT INTO users (username, email)
 VALUES ('denis', 'denis.rinfret@example.com'),
        ('minh', 'minh@example.com');

INSERT INTO contacts (email, uid)
VALUES ('help@example.com', 1),
       ('minh@example.com', 1),
       ('contact@example.com', 2),
       ('ha@example.com', 2);

```

```sql
SELECT *
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
    </tr>
</table>

```sql
SELECT *
FROM contacts;
```

<table>
    <tr>
        <th>cid</th>
        <th>email</th>
        <th>uid</th>
    </tr>
    <tr>
        <td>1</td>
        <td>help@example.com</td>
        <td>1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh@example.com</td>
        <td>1</td>
    </tr>
    <tr>
        <td>3</td>
        <td>contact@example.com</td>
        <td>2</td>
    </tr>
    <tr>
        <td>4</td>
        <td>ha@example.com</td>
        <td>2</td>
    </tr>
</table>

### Jointure nécessaire pour obtenir toutes les données

```sql
SELECT *
FROM users u
         INNER JOIN contacts c ON u.uid = c.uid;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
        <th>cid</th>
        <th>email_1</th>
        <th>uid_1</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>1</td>
        <td>help@example.com</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>2</td>
        <td>minh@example.com</td>
        <td>1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>3</td>
        <td>contact@example.com</td>
        <td>2</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>4</td>
        <td>ha@example.com</td>
        <td>2</td>
    </tr>
</table>

1. Les jointures peuvent être lentes.
2. Mais sans normalisation, les données peuvent être redondantes et des
   anomalies peuvent apparaître.
3. Une SGDB `object-relationalle` (SGBDOR, ou ORDBMS) peut aider.

## Contacts dénormalisés

### `contacts3` Schéma objet-relationnel

```sql
DROP SCHEMA IF EXISTS contacts3 CASCADE;
CREATE SCHEMA contacts3;
SET search_path TO contacts3;

CREATE TABLE users
(
    uid                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username           VARCHAR(15) NOT NULL,
    email              TEXT        NOT NULL,
    firstname          TEXT,
    lastname           TEXT,
    emergency_contacts TEXT[]
);
```

```sql
INSERT INTO users (username, email, emergency_contacts)
VALUES ('denis', 'denis.rinfret@example.com',
        ARRAY ['help@example.com', 'minh@example.com']),
       ('minh', 'minh@example.com',
        ARRAY ['contact@example.com', 'ha@example.com']);
```

```sql
SELECT uid, emergency_contacts
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>emergency_contacts</th>
    </tr>
    <tr>
        <td>1</td>
        <td>["help@example.com", "minh@example.com"]</td>
    </tr>
    <tr>
        <td>2</td>
        <td>["contact@example.com", "ha@example.com"]</td>
    </tr>
</table>

```sql
SELECT uid,
       username,
       email,
       firstname,
       lastname,
       unnest(emergency_contacts)
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
        <th>unnest</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>help@example.com</td>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>minh@example.com</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>contact@example.com</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>ha@example.com</td>
    </tr>
</table>

### Trouver les utilisateurs avec un courriel spécifique comme premier contact d'urgence

```sql
SELECT uid, username, email
FROM users
WHERE emergency_contacts[1] = 'help@example.com';
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
    </tr>
</table>

### Trouver un utilisateur avec un courriel spécifique comme contact d'urgence (n'importe quelle position)

```sql

SELECT uid, username, email
FROM users
WHERE 'ha@example.com' = ANY (emergency_contacts);
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

### Trouver les utilisateurs qui sont listés comme contact d'urgence d'autres utilisateurs

```sql
SELECT uid, username, email
FROM users
WHERE email IN (SELECT unnest(emergency_contacts)
                FROM users);
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

```sql 
SELECT distinct uid, username, email
FROM users
         INNER JOIN
     (SELECT unnest(emergency_contacts) AS emergency_email
      FROM users) AS all_contacts
     ON email = emergency_email;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

### Sans `unnest` ni sous-requêtes

```sql 
SELECT u1.uid, u1.username, u1.email
FROM users u1
         INNER JOIN users u2
                    ON u1.email = ANY (u2.emergency_contacts);
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

## Types définis par les utilisateurs

User-Defined Types (UDT)

### `contacts4` Schéma objet-relationnel

```sql
DROP SCHEMA IF EXISTS contacts4 CASCADE;
CREATE SCHEMA contacts4;
SET search_path TO contacts4;

CREATE TYPE contact_type AS ENUM ('emergency', 'friend',
    'family', 'colleague');

CREATE TYPE contact AS
(
    email TEXT,
    type  contact_type
);
```

```sql 
CREATE TABLE users
(
    uid       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username  VARCHAR(15) NOT NULL,
    email     TEXT        NOT NULL,
    firstname TEXT,
    lastname  TEXT,
    contacts  contact[]
);
```

```sql
INSERT INTO users (username, email, contacts)
VALUES ('denis', 'denis.rinfret@example.com',
        ARRAY [('help@example.com', 'emergency')::contact,
            ('minh@example.com', 'friend')::contact]),
       ('minh', 'minh@example.com',
        ARRAY [('contact@example.com', 'family')::contact,
            ('ha@example.com', 'colleague')::contact]);
```

```sql
SELECT uid, contacts
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>contacts</th>
    </tr>
    <tr>
        <td>1</td>
        <td>{&quot;(help@example.com,emergency)&quot;,&quot;(minh@example.com,friend)&quot;}</td>
    </tr>
    <tr>
        <td>2</td>
        <td>{&quot;(contact@example.com,family)&quot;,&quot;(ha@example.com,colleague)&quot;}</td>
    </tr>
</table>

```sql 
SELECT uid,
       username,
       email,
       (unnest(contacts)::contact).*
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>email_1</th>
        <th>type</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>help@example.com</td>
        <td>emergency</td>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>minh@example.com</td>
        <td>friend</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>contact@example.com</td>
        <td>family</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>ha@example.com</td>
        <td>colleague</td>
    </tr>
</table>

```sql 
SELECT uid,
       username,
       email,
       (unnest(contacts)::contact).email AS contact_email,
       (unnest(contacts)::contact).type  AS contact_type
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>contact_email</th>
        <th>contact_type</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>help@example.com</td>
        <td>emergency</td>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>minh@example.com</td>
        <td>friend</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>contact@example.com</td>
        <td>family</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>ha@example.com</td>
        <td>colleague</td>
    </tr>
</table>

### Trouver tous les contacts d'urgence d'un utilisateur

```sql 
SELECT *
FROM (SELECT uid,
             username,
             email,
             (unnest(contacts)::contact).email AS contact_email,
             (unnest(contacts)::contact).type  AS contact_type
      FROM users) AS temp
WHERE contact_type = 'emergency';
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>contact_email</th>
        <th>contact_type</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>help@example.com</td>
        <td>emergency</td>
    </tr>
</table>

### Trouver les utilisateurs sans contacts d'urgence

```sql 
SELECT uid, username, email
FROM users
WHERE 'emergency' NOT IN (SELECT (unnest(contacts)::contact).type);
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

```sql 
SELECT uid, username, email
FROM users
WHERE 'emergency' != ALL (SELECT (unnest(contacts)::contact).type);
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

## JSONB à la place de tableaux

### `contacts5` Schéma objet-relationnel

```sql
DROP SCHEMA IF EXISTS contacts5 CASCADE;
CREATE SCHEMA contacts5;
SET search_path TO contacts5;

CREATE TABLE users
(
    uid       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username  VARCHAR(15) NOT NULL,
    email     TEXT        NOT NULL,
    firstname TEXT,
    lastname  TEXT,
    contacts  jsonb
);
```

```sql
INSERT INTO users (username, email, contacts)
VALUES ('denis', 'denis.rinfret@example.com',
        '{"emergency": "help@example.com", "friend": "minh@example.com"}'),
       ('minh', 'minh@example.com',
        '{"family": "contact@example.com", "colleague": "ha@example.com"}');
```

```sql
SELECT uid, contacts
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>contacts</th>
    </tr>
    <tr>
        <td>1</td>
        <td>{"friend": "minh@example.com", "emergency": "help@example.com"}</td>
    </tr>
    <tr>
        <td>2</td>
        <td>{"family": "contact@example.com", "colleague": "ha@example.com"}</td>
    </tr>
</table>

### Trouver les utilisateurs avec au moins un contact d'urgence

```sql 
SELECT uid, username, email
FROM users
WHERE 'emergency' IN (SELECT jsonb_object_keys(contacts));
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
    </tr>
</table>

```sql 
SELECT uid, username, email
FROM users
WHERE contacts ? 'emergency';
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
    </tr>
</table>

```sql 
SELECT uid, username, email, contacts -> 'emergency' AS emergency
FROM users
WHERE contacts ? 'emergency';
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>emergency</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>help@example.com</td>
    </tr>
</table>

### Trouver les utilisateurs sans contacts d'urgence

```sql 
SELECT uid, username, email
FROM users
WHERE NOT (contacts ? 'emergency');
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

## Schéma relationnel avec les types de contact

### `contacts6` Relational Schema

```sql
DROP SCHEMA IF EXISTS contacts6 CASCADE;
CREATE SCHEMA contacts6;
SET search_path TO contacts6;

CREATE TABLE users
(
    uid       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username  VARCHAR(15) NOT NULL,
    email     TEXT        NOT NULL,
    firstname TEXT,
    lastname  TEXT
);
```

```sql
CREATE TYPE contact_type AS ENUM ('emergency', 'friend',
    'family', 'colleague');

CREATE TABLE contacts
(
    cid   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT         NOT NULL,
    type  contact_type NOT NULL,
    uid   INTEGER REFERENCES users (uid)
);
```

```sql
INSERT INTO users (username, email)
VALUES ('denis', 'denis.rinfret@example.com'),
       ('minh', 'minh@example.com');

INSERT INTO contacts (email, type, uid)
VALUES ('help@example.com', 'emergency', 1),
       ('minh@example.com', 'friend', 1),
       ('contact@example.com', 'colleague', 2),
       ('ha@example.com', 'family', 2);
```

```sql
SELECT *
FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
    </tr>
</table>

```sql
SELECT *
FROM contacts;
```

<table>
    <tr>
        <th>cid</th>
        <th>email</th>
        <th>type</th>
        <th>uid</th>
    </tr>
    <tr>
        <td>1</td>
        <td>help@example.com</td>
        <td>emergency</td>
        <td>1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh@example.com</td>
        <td>friend</td>
        <td>1</td>
    </tr>
    <tr>
        <td>3</td>
        <td>contact@example.com</td>
        <td>colleague</td>
        <td>2</td>
    </tr>
    <tr>
        <td>4</td>
        <td>ha@example.com</td>
        <td>family</td>
        <td>2</td>
    </tr>
</table>

```sql
SELECT *
FROM users u
         INNER JOIN contacts c ON u.uid = c.uid;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
        <th>firstname</th>
        <th>lastname</th>
        <th>cid</th>
        <th>email_1</th>
        <th>type</th>
        <th>uid_1</th>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>1</td>
        <td>help@example.com</td>
        <td>emergency</td>
        <td>1</td>
    </tr>
    <tr>
        <td>1</td>
        <td>denis</td>
        <td>denis.rinfret@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>2</td>
        <td>minh@example.com</td>
        <td>friend</td>
        <td>1</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>3</td>
        <td>contact@example.com</td>
        <td>colleague</td>
        <td>2</td>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
        <td>None</td>
        <td>None</td>
        <td>4</td>
        <td>ha@example.com</td>
        <td>family</td>
        <td>2</td>
    </tr>
</table>

### Trouver les utilisateurs sans contacts d'urgence 

```sql 
SELECT uid, username, email
FROM users
WHERE uid NOT IN (SELECT uid
                  FROM contacts
                  WHERE type = 'emergency');
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

```sql 
SELECT users.uid, username, email
FROM users
         LEFT JOIN (SELECT uid
                    FROM contacts
                    WHERE type = 'emergency') AS temp
                   ON users.uid = temp.uid
WHERE temp.uid IS NULL;
```

<table>
    <tr>
        <th>uid</th>
        <th>username</th>
        <th>email</th>
    </tr>
    <tr>
        <td>2</td>
        <td>minh</td>
        <td>minh@example.com</td>
    </tr>
</table>

## Comment traitons-nous les relations plusieurs à plusieurs ?

- Dans une base de données relationnelle, nous avons besoin d'une table
  supplémentaire entre les 2 tables.
    - Par exemple, nous avons besoin d'une table entre "Users" et "Contacts",
      contenant des clés étrangères pour les ID d'utilisateur et les ID de
      contact.
- Comment récupérons-nous toutes les données ?
    - Avec 2 jointures.
- Qu'en est-il des autres modèles de données ?
    - Avec des tableaux ?
    - Avec JSONB ?

**Il n'y a pas de solutions miracles pour les relations plusieurs à plusieurs**

