Object-Relational DBMS
======================

Normalized Contacts
-------------------

### `contacts1` Relational Schema

```postgresql
DROP SCHEMA IF EXISTS contacts1 CASCADE;
CREATE SCHEMA contacts1;
SET search_path TO contacts1;

CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT,
    emergency_contact TEXT
);
```


```postgresql
INSERT INTO users (username, email, emergency_contact)
    VALUES ('denis', 'denis.rinfret@example.com', 'help@example.com'),
            ('minh', 'minh@example.com', 'contact@example.com');
```

```postgresql
SELECT * FROM users;
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

### What do we need to do to allow more than 1 contact per user?

1.  If the number of contacts is fixed, say `n` contacts, then we could
    have `n` contacts columns, as long as `n` is small.
2.  But if `n` is not small or if `n` is unknown, then we must have
    another table, a `contacts` table, to preserve the *first normal
    form*.
3.  The first normal form says that each column value must be *atomic*.

### `contacts2` Relational Schema

```postgresql
DROP SCHEMA IF EXISTS contacts2 CASCADE;
CREATE SCHEMA contacts2;
SET search_path TO contacts2;

CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT
);

CREATE TABLE contacts (
    cid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL,
    uid INTEGER REFERENCES users(uid)
)
```


```postgresql
 INSERT INTO users (username, email)
    VALUES ('denis', 'denis.rinfret@example.com'),
            ('minh', 'minh@example.com');

INSERT INTO contacts (email, uid) 
    VALUES ('help@example.com', 1), ('minh@example.com', 1), 
        ('contact@example.com', 2) , ('ha@example.com', 2);
    
```


```postgresql
SELECT * FROM users;
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


```postgresql
SELECT * FROM contacts;
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

### Join necessary to get all data

```postgresql
SELECT * FROM users u INNER JOIN contacts c ON u.uid = c.uid;
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

1.  Joins can be slow.
2.  But without normalization, we have redundant data and anomalies can
    occur.
3.  An `Object-Relational` DBMS (ORDBMS) can help.

De-normalized Contacts
----------------------

### `contacts3` Object-Relational Schema

```postgresql
DROP SCHEMA IF EXISTS contacts3 CASCADE;
CREATE SCHEMA contacts3;
SET search_path TO contacts3;

CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT,
    emergency_contacts TEXT[]
);
```


```postgresql
INSERT INTO users (username, email, emergency_contacts)
VALUES ('denis', 'denis.rinfret@example.com',
        ARRAY ['help@example.com', 'minh@example.com']),
       ('minh', 'minh@example.com',
        ARRAY ['contact@example.com', 'ha@example.com']);
```


```postgresql
SELECT uid, emergency_contacts FROM users;
```


<table>
    <tr>
        <th>uid</th>
        <th>emergency_contacts</th>
    </tr>
    <tr>
        <td>1</td>
        <td>[&#x27;help@example.com&#x27;, &#x27;minh@example.com&#x27;]</td>
    </tr>
    <tr>
        <td>2</td>
        <td>[&#x27;contact@example.com&#x27;, &#x27;ha@example.com&#x27;]</td>
    </tr>
</table>

```postgresql
SELECT uid, username, email, firstname, lastname, 
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

### Find users with a specific email as first emergency contact

```postgresql
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

### Find users with a specific email as any emergency contact

```postgresql
 
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

### Find users who are listed as emergency contacts of other users

```postgresql
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

```postgresql 
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

### Without `unnest` and subqueries

```postgresql 
SELECT u1.uid, u1.username, u1.email
FROM users u1 INNER JOIN users u2 
     ON u1.email =ANY (u2.emergency_contacts);
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

### EXPLAIN ANALYZE on previous queries

```postgresql
EXPLAIN ANALYZE 
SELECT * FROM contacts2.users u INNER JOIN contacts2.contacts c ON u.uid = c.uid;
```

<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Hash Join  (cost=20.35..45.53 rows=1200 width=188) (actual time=0.040..0.043 rows=4 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Hash Cond: (c.uid = u.uid)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;-&gt;  Seq Scan on contacts c  (cost=0.00..22.00 rows=1200 width=40) (actual time=0.018..0.018 rows=4 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;-&gt;  Hash  (cost=14.60..14.60 rows=460 width=148) (actual time=0.013..0.013 rows=2 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Buckets: 1024  Batches: 1  Memory Usage: 9kB</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  Seq Scan on users u  (cost=0.00..14.60 rows=460 width=148) (actual time=0.007..0.008 rows=2 loops=1)</td>
    </tr>
    <tr>
        <td>Planning Time: 0.168 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.072 ms</td>
    </tr>
</table>

```postgresql
EXPLAIN ANALYZE SELECT * FROM contacts3.users;
```


<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Seq Scan on users  (cost=0.00..13.90 rows=390 width=180) (actual time=0.015..0.015 rows=2 loops=1)</td>
    </tr>
    <tr>
        <td>Planning Time: 0.070 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.029 ms</td>
    </tr>
</table>

```postgresql
EXPLAIN ANALYZE 
SELECT uid, username, email, firstname, lastname, 
        unnest(emergency_contacts) 
FROM contacts3.users;
```


<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>ProjectSet  (cost=0.00..36.33 rows=3900 width=180) (actual time=0.020..0.023 rows=4 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;-&gt;  Seq Scan on users  (cost=0.00..13.90 rows=390 width=180) (actual time=0.014..0.015 rows=2 loops=1)</td>
    </tr>
    <tr>
        <td>Planning Time: 0.084 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.045 ms</td>
    </tr>
</table>

User-Defined Types
------------------

### `contacts4` Object-relational schema

```postgresql
DROP SCHEMA IF EXISTS contacts4 CASCADE;
CREATE SCHEMA contacts4;
SET search_path TO contacts4;

CREATE TYPE contact_type AS ENUM ('emergency', 'friend', 
                                  'family', 'colleague');

CREATE TYPE contact AS (
    email TEXT,
    type contact_type
);
```


```postgresql 
CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT, 
    contacts contact[]
);
```


```postgresql
INSERT INTO users (username, email, contacts)
    VALUES ('denis', 'denis.rinfret@example.com', 
            ARRAY[('help@example.com', 'emergency')::contact, 
                  ('minh@example.com', 'friend')::contact]),
            ('minh', 'minh@example.com', 
             ARRAY[('contact@example.com', 'family')::contact, 
                   ('ha@example.com', 'colleague')::contact]);
```


```postgresql
SELECT uid, contacts FROM users;
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

```postgresql 
SELECT uid, username, email, 
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

```postgresql 
SELECT uid, username, email, 
        (unnest(contacts)::contact).email AS contact_email, 
        (unnest(contacts)::contact).type AS contact_type 
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

### Find the emergency contacts of users

```postgresql 
SELECT *
FROM (SELECT uid, username, email, 
        (unnest(contacts)::contact).email AS contact_email, 
        (unnest(contacts)::contact).type AS contact_type 
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

### Find users without emergency contacts

```postgresql 
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

```postgresql 
SELECT uid, username, email
FROM users
WHERE 'emergency' !=ALL (SELECT (unnest(contacts)::contact).type);
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


JSONB instead of arrays
-----------------------

### `contacts5` Object-Relational Schema

```postgresql
DROP SCHEMA IF EXISTS contacts5 CASCADE;
CREATE SCHEMA contacts5;
SET search_path TO contacts5;

CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT, 
    contacts jsonb
);
```


```postgresql
INSERT INTO users (username, email, contacts)
    VALUES ('denis', 'denis.rinfret@example.com', 
            '{"emergency": "help@example.com", "friend": "minh@example.com"}'),
            ('minh', 'minh@example.com', 
            '{"family": "contact@example.com", "colleague": "ha@example.com"}');
```


```postgresql
SELECT uid, contacts FROM users;
```

<table>
    <tr>
        <th>uid</th>
        <th>contacts</th>
    </tr>
    <tr>
        <td>1</td>
        <td>{&#x27;friend&#x27;: &#x27;minh@example.com&#x27;, &#x27;emergency&#x27;: &#x27;help@example.com&#x27;}</td>
    </tr>
    <tr>
        <td>2</td>
        <td>{&#x27;family&#x27;: &#x27;contact@example.com&#x27;, &#x27;colleague&#x27;: &#x27;ha@example.com&#x27;}</td>
    </tr>
</table>


### Users with an emergency contact

```postgresql 
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

```postgresql 
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

```postgresql 
SELECT uid, username, email, contacts->'emergency' AS emergency
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


### Users without emergency contacts

```postgresql 
SELECT uid, username, email
FROM users
WHERE NOT(contacts ? 'emergency');
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


Relational Schema with contact types
------------------------------------

### `contacts6` Relational Schema


```postgresql
DROP SCHEMA IF EXISTS contacts6 CASCADE;
CREATE SCHEMA contacts6;
SET search_path TO contacts6;

CREATE TABLE users (
    uid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(15) NOT NULL,
    email TEXT NOT NULL,
    firstname TEXT,
    lastname TEXT
);
```


```postgresql
CREATE TYPE contact_type AS ENUM ('emergency', 'friend', 
                                  'family', 'colleague');

CREATE TABLE contacts (
    cid INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL,
    type contact_type NOT NULL,
    uid INTEGER REFERENCES users(uid)
);
```

```postgresql
INSERT INTO users (username, email)
    VALUES ('denis', 'denis.rinfret@example.com'),
            ('minh', 'minh@example.com');

INSERT INTO contacts (email, type, uid) 
    VALUES ('help@example.com', 'emergency', 1), ('minh@example.com', 'friend', 1), 
        ('contact@example.com', 'colleague', 2) , ('ha@example.com', 'family', 2);
```


```postgresql
SELECT * FROM users;
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


```postgresql
SELECT * FROM contacts;
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


```postgresql
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


### Users without emergency contacts

```postgresql 
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


```postgresql 
SELECT users.uid, username, email
FROM users LEFT JOIN (SELECT uid 
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

### EXPLAIN ANALYZE for users with emergency contacts

#### Users table with array of contact types

```postgresql
EXPLAIN ANALYZE
SELECT uid, username, email
FROM contacts4.users
WHERE 'emergency' !=ALL (SELECT (unnest(contacts)::contacts4.contact).type);
```

<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Seq Scan on users  (cost=0.00..57.29 rows=195 width=84) (actual time=0.040..0.041 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Filter: (SubPlan 1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Rows Removed by Filter: 1</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;SubPlan 1</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  Result  (cost=0.00..0.19 rows=10 width=4) (actual time=0.005..0.006 rows=2 loops=2)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  ProjectSet  (cost=0.00..0.07 rows=10 width=32) (actual time=0.003..0.004 rows=2 loops=2)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  Result  (cost=0.00..0.01 rows=1 width=0) (actual time=0.000..0.000 rows=1 loops=2)</td>
    </tr>
    <tr>
        <td>Planning Time: 0.151 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.079 ms</td>
    </tr>
</table>

#### Users table with JSONB contacts

```postgresql
EXPLAIN ANALYZE
SELECT uid, username, email
FROM contacts5.users
WHERE NOT(contacts ? 'emergency');
```

<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Seq Scan on users  (cost=0.00..14.88 rows=390 width=84) (actual time=0.018..0.019 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Filter: (NOT (contacts ? &#x27;emergency&#x27;::text))</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Rows Removed by Filter: 1</td>
    </tr>
    <tr>
        <td>Planning Time: 0.080 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.036 ms</td>
    </tr>
</table>

#### Users table with another table for contacts

```postgresql
EXPLAIN ANALYZE
SELECT uid, username, email
FROM contacts6.users
WHERE uid NOT IN (SELECT uid 
                 FROM contacts6.contacts
                 WHERE type = 'emergency');
```

<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Seq Scan on users  (cost=24.14..39.89 rows=230 width=84) (actual time=0.037..0.037 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Filter: (NOT (hashed SubPlan 1))</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Rows Removed by Filter: 1</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;SubPlan 1</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  Seq Scan on contacts  (cost=0.00..24.13 rows=6 width=4) (actual time=0.009..0.010 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter: (type = &#x27;emergency&#x27;::contact_type)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rows Removed by Filter: 3</td>
    </tr>
    <tr>
        <td>Planning Time: 0.134 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.067 ms</td>
    </tr>
</table>

```postgresql
EXPLAIN ANALYZE
SELECT users.uid, username, email
FROM users LEFT JOIN (SELECT uid 
                     FROM contacts
                     WHERE type = 'emergency') AS temp
    ON users.uid = temp.uid
WHERE temp.uid IS NULL;
```

<table>
    <tr>
        <th>QUERY PLAN</th>
    </tr>
    <tr>
        <td>Hash Anti Join  (cost=24.20..44.55 rows=454 width=84) (actual time=0.052..0.053 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;Hash Cond: (users.uid = contacts.uid)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;-&gt;  Seq Scan on users  (cost=0.00..14.60 rows=460 width=84) (actual time=0.020..0.021 rows=2 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;-&gt;  Hash  (cost=24.13..24.13 rows=6 width=4) (actual time=0.017..0.018 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Buckets: 1024  Batches: 1  Memory Usage: 9kB</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt;  Seq Scan on contacts  (cost=0.00..24.13 rows=6 width=4) (actual time=0.012..0.013 rows=1 loops=1)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Filter: (type = &#x27;emergency&#x27;::contact_type)</td>
    </tr>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rows Removed by Filter: 3</td>
    </tr>
    <tr>
        <td>Planning Time: 0.201 ms</td>
    </tr>
    <tr>
        <td>Execution Time: 0.087 ms</td>
    </tr>
</table>


What do we deal with many-many relationships?
-------------------------------------------
  
- In a relational DB, we need an extra table in between the 2 tables
    -   For example, we need a table in between Users and Contacts,
        containing foreign keys to user IDs and contact IDs
-   How do we get all the data?
    -   With 2 joins
-   How about the other data models?
    -   With arrays?
    -   With JSONB?

**No miracle solutions for many-many relationships**

