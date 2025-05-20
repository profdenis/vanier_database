# 2. Livres

Créez un diagramme EA pour une base de données de livres, basé sur les informations données ci-dessous.

## Partie 1

1. Un livre a un titre, une date de publication et un numéro ISBN, et est écrit par un ou plusieurs auteurs.
2. Un auteur a un nom, un numéro de téléphone et une adresse e-mail.
3. Un livre peut être auto-publié ou publié par un éditeur.
4. Un éditeur a un nom, un numéro de téléphone, une adresse e-mail et une adresse postale.

## Partie 2

Ajoutez les éléments suivants au diagramme EA que vous avez obtenu dans la partie précédente.

1. Un livre peut avoir plusieurs chapitres. Chaque chapitre a un numéro et un titre.
2. Des étiquettes peuvent être appliquées aux livres, telles que *fiction* ou *non-fiction*, *informatique*,
   *statistiques*, *langue*, ...

## Partie 3

Ajoutez les éléments suivants au diagramme EA que vous avez obtenu dans la partie précédente.

1. Une librairie veut vendre des livres aux clients. Les livres doivent avoir un prix de vente au détail et un prix de
   vente.
2. Les clients doivent avoir un nom et une adresse e-mail.
3. Un client peut commander plusieurs livres dans la même commande. La commande doit enregistrer le prix de chaque livre
   commandé, au cas où les prix des livres changeraient au fil du temps.
4. Chaque commande doit avoir le prix total (avant taxes et frais d'expédition), les frais d'expédition et le total
   général avec les frais d'expédition et les taxes.
