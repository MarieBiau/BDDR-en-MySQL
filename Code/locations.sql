/*Les variables globales utilisées sont un numéro d'identifiant ainsi que la date, semaine et année actuelle.*/
SET @new_id = 11;
SET @date_actuelle = '2016-05-22';
SET @semaine_actuelle = 20;
SET @annee_actuelle = 2016;


/*L'inscription et la connexion.*/

/*Le client fait une demande d'inscription, le serveur de traitement lui demande de remplir l'ensemble des champs suivants : nom, adresse, numéro de téléphone et mot de passe. Le serveur de traitement appelle ensuite la procédure inscription pour que la base de données mette à jour la table client. La base de données retourne ensuite l'ensemble des informations, y compris l'identifiant assigné au client. Le serveur de traitement envoie un message de confirmation d'inscription ainsi que les informations enregistrées.*/
CALL inscription("AZERTY0","John Diggle","2 Rue de la Liberté 24000 Périgueux",0553084523);

/*Le client se déconnecte puis essaye de se reconnecter.*/
/*Le client se trompe dans la saisie de son identifiant.*/
CALL connexion(10,AZERTY0);
/*Le client se trompe dans la saisie de son mot de passe.*/
CALL connexion(11,AZRTY0);
/*L'identifiant et le mot de passe rentrés par le client sont corrects, le client est connecté au serveur de traitement.*/
CALL connexion(11,AZERTY0);

/*Le client souhaite modifier ses informations personnelles, il clique sur le lien permettant de le faire puis saisit ses nouvelles informations.
Le serveur de traitement envoie ces informations à la base de données qui s'occupe d'effectuer la mise à jour. L'ensemble des informations est ensuite envoyé au serveur de traitement qui les communique au client*/
CALL modification_informations(11,"AZERTY01","3 Rue de la Liberté 24000 Périgueux",0648152378);

/*Cette commande sert à vérifier l'état de la table client (et donc que les requêtes précédentes ont bien fonctionné). Elle ne fait pas partie de la simulation d'interaction entre le client, le serveur de traitement et la base de données.*/
SELECT * FROM client;


/*Les demandes de réservation.*/

/*C'est le début de la semaine, le serveur de traitement demande à la base de vérifier si des locations sont terminées. C'est le cas pour une des locations, la base supprime alors le n-uplet correspondant.*/
CALL location_terminee();

/*Le client remplit les champs de la demande, indiquant le site désiré, la catégorie d'appartement voulue ainsi que la période désirée. Le serveur de traitement envoie ces données à la base qui vérifie si la demande peut être satisfaite. Quand c'est le cas, elle renvoie l'ensemble des appartements correspondant à la demande. Le serveur de traitement affiche alors la liste des appartements disponibles et propose au client de choisir celui qu'il désire. Une fois ce choix fait, le serveur de traitement demande à la base d'enregistrer la réservation dans la table reserver. La base renvoie l'ensemble des informations de la réservation au serveur de traitement qui les communique au client.*/
/*La demande est entièrement satisfaite.*/
CALL demande_reservation ('T1','Valthoriaz 1600',02,2017);
CALL choix_reservation (11,"Appartement n°1 Bâtiment des marmottes",02,2017);
/*La demande ne peut pas être satisfaite.*/
CALL demande_reservation ('T4','Valthoriaz 1600',40,2016);
/*La demande ne peut pas être satisfaite mais une solution de remplacement est trouvée (la première solution).*/
CALL demande_reservation ('T4','Valthoriaz 1800',05,2017);
CALL choix_reservation (11,"Appartement n°8 Bâtiment des bûcherons",05,2017);
/*La demande ne peut pas être satisfaite mais une solution de remplacement est trouvée (la deuxième solution).*/
CALL demande_reservation ('T3','Valthoriaz 1600',40,2016);
CALL choix_reservation (11,"Appartement n°2 Bâtiment des flocons",40,2016);

/*Le client effectue une autre demande. La demande est envoyée du serveur de traitement à la base. Cette dernière retourne le résultat (la demande peut être satisfaite), le client choisit alors l'appartement qu'il souhaite réserver. Le serveur de traitement envoie cette information à la base, qui renvoie un message d'erreur car le client possède déjà trois réservations non valides.*/
CALL demande_reservation ('T1','Valthoriaz 1600',08,2017);
CALL choix_reservation (11,"Appartement n°1 Bâtiment des marmottes",08,2017);
/*Le client demande au serveur de traitement d'afficher ses réservations. Le serveur de traitement envoie la requête à la base qui retourne la liste des réservations. Le serveur de traitement les communique ensuite au client.*/
CALL consultation_reservations(11);
/*Le client choisit une de ses réservations et demande au serveur de traitement de la supprimer. Ce dernier envoie la requête à la base qui effectue la suppression.*/ 
CALL suppression_reservation("Appartement n°1 Bâtiment des marmottes",02,2017);
/*Le client visualise de nouveau ses réservations pour vérifier que la suppresson a bien été éffectuée.*/
CALL consultation_reservations(11);
/*Le client réalise de nouveau la demande de réservation. Les interactions se déroulent de la même façon que précedemment sauf que cette fois ci, la base accepte l'insertion.*/
CALL demande_reservation ('T1','Valthoriaz 1600',08,2017);
CALL choix_reservation (11,"Appartement n°1 Bâtiment des marmottes",08,2017);

/*Cette commande sert à vérifier l'état de la table reserver (et donc que les requêtes précédentes ont bien fonctionné). Elle ne fait pas partie de la simulation d'interaction entre le client, le serveur de traitement et la base de données.*/
SELECT * FROM reserver;


/*Le paiement des arrhes.*/

/*Le client souhaite effectuer le paiement des arrhes d'une de ses réservations. Il affiche l'ensemble de ses réservations et choisit celle qu'il souhaite modifier. Le serveur de traitement communique l'adresse de l'appartement ainsi que la période à la base de données. Cette dernière calcule le prix de la réservation et celui des arrhes à payer et communique ces chiffres au serveur de traitement (qui le communique à son tour au client). Le client saisit son numéro de carte bancaire dans le champ prévu, puis le serveur de traitement envoie la requête de mise à jour de la reservation à la base, après avoir vérifié que le paiement a bien été effectué. Après la mise à jour de l'attribut arrhes, la base renvoie les informations liées à cette réservation au serveur de traitement, qui les communique au client.*/
SELECT calcul_prix("Appartement n°1 Bâtiment des marmottes",08,2017);
SELECT calcul_prix_arrhes("Appartement n°1 Bâtiment des marmottes",08,2017);
CALL arrhes_paiement("Appartement n°1 Bâtiment des marmottes",08,2017);

/*Quinze jours se sont écoulés et le client n'a toujours pas reglé les arrhes de deux de ses réservations. Le serveur de traitement demande à la base de vérifier si des réservations non validées doivent être supprimées. Ce n'est pas le cas, il lui reste encore la fin de la journée pour effectuer le paiement, il n'y a donc pas de suppression.*/
SET @date_actuelle = '2016-06-06';
SET @semaine_actuelle = 23;
SET @annee_actuelle = 2016;
CALL arrhes_impayees ();

/*Cette commande sert juste à vérifier l'état de la table reserver (et donc que les requêtes précédentes ont bien fonctionné). Elle ne fait pas partie de la simulation d'interaction entre le client, le serveur de traitement et la base de données.*/
SELECT * FROM reserver;

/*Un jour de plus passe, il y a de nouveau une vérification du paiement des arrhes (la vérification est faite quotidiennement). Cette fois-ci, les deux réservations non validées du client sont supprimées car le délai de quinze jours est passé.*/
SET @date_actuelle = '2016-06-07';
CALL arrhes_impayees ();

/*Cette commande sert à vérifier l'état de la table reserver (et donc que les requêtes précédentes ont bien fonctionné). Elle ne fait pas partie de la simulation d'interaction entre le client, le serveur de traitement et la base de données.*/
SELECT * FROM reserver;



