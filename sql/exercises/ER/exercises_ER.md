# Exercises - Entity-Relationship Modeling

## Exercise #1: Blog

Create an ER diagram for the database of a Blog application, based on the
information given below.

### Part 1

1. A blog post should be written by a user.
2. A blog post should have an ID, a title, contents, and a posted date.
3. A user should have a nick name (unique among all the users) and an email
   address.
4. Blog posts should be organized into topics. There can be many topics per blog
   post.
5. A topic should have an ID, a name, and a description.

### Part 2

Add the following to the ER diagram you got in the previous part.

1. Users can leave comments on blog posts, and reply to other comments.
2. A comment must be posted by a user (no anonymous comments allowed), and must
   be associated to a blog post or another comment (the parent comment).
3. A comment must have an ID, contents (the comment's text), and a date.

## Exercise #2: Books

Create an ER diagram for a Books database, based on the information given below.

### Part 1

1. A book has a title, a publication date and an ISBN number, and is written by
   one or more authors.
2. An author as a name, a phone number, and an email address.
3. A book can be self-published, or published by a publisher.
4. A publisher has a name, a phone number, an email address and a mailing
   address.

### Part 2

Add the following to the ER diagram you got in the previous part.

1. A book can have many chapters. Each chapter has a number and a title.
2. Tags can be applied to books, such as *fiction* or *non-fiction*,
   *computer science*, *statistics*, *language*, ...

### Part 3

Add the following to the ER diagram you got in the previous part.

1. A bookstore wants to sell books to customers. The books should have a retail
   price, and a sale price.
2. Customers should have a name and an email address.
3. A customer can order many books in the same order. The order should 
   record the price of each book ordered, in case the book prices change 
   over time.
4. Each order should have the total price (before tax and shipping), the 
   shipping cost, and the grand total with shipping and taxes.