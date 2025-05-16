# 7 - Recursive Queries

## PostgreSQL Syntax

- Basic
  syntax ([https://www.postgresqltutorial.com/postgresql-recursive-query/](https://www.postgresqltutorial.com/postgresql-recursive-query/)):

```sql
WITH RECURSIVE cte_name AS (CTE_query_definition -- non-recursive term
                            UNION [ ALL ] 
                            CTE_query_definition -- recursive term )
SELECT *
FROM cte_name;
```

- CTE: *common table expression*
- Since recursive queries are (of course) recursive, we need a *base case*, called here a *non-recursive term*
- Then, we need one or more recursive terms
- `with recursive` works, at the beginning, a bit like `with` queries (without `recursive`)
- It will first evaluate the non-recursive term to initialize the result set
- Then, it will start evaluating the recursive term multiple times, in a loop, until no new rows are added to the
  results
- each time it evaluates the recursive term, it will try to add new rows to the result set
- the recursive term is correlated to the `cte_name`

## Example on the Blog Database

![Blogpostt to find all replies to a given comment recursively

- we don't just want direct replies, but also all replies to replies
- First attempt to retrieve only direct replies:

```sql
set
search_path to blog3;
select comment_id, contents, reply_to_id, user_id
from comment
where blogpost_id = 1
  and reply_to_id is null;
```

- To get replies to replies, we need to use the `with recursive` syntax described above:

```sql
with recursive replies as (select comment_id, contents, reply_to_id, user_id
                           from comment
                           where reply_to_id = 1
                           union
                           select comment.comment_id,
                                  comment.contents,
                                  comment.reply_to_id,
                                  comment.user_id
                           from comment
                                    inner join replies
                                               on replies.comment_id = comment.reply_to_id)
select *
from replies;
```

- If we need to include the original comment we're starting with in the result, we need a slightly different
  non-recursive term
- use `comment_id = 1` instead of `reply_to_id = 1`
- If we need to include comments starting from a blog post, we need a slightly different non-recursive term...
- use `blogpost_id = 1` instead of `reply_to_id = 1`

```sql
with recursive replies as (select comment_id, contents, reply_to_id, user_id
                           from comment
                           where blogpost_id = 1
                           union
                           select comment.comment_id,
                                  comment.contents,
                                  comment.reply_to_id,
                                  comment.user_id
                           from comment
                                    inner join replies
                                               on replies.comment_id = comment.reply_to_id)
select *
from replies;
```

