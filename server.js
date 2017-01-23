// Déclaration des packages contenus dans le dossier node_modules

var express = require("express");
var fs = require("fs");
var mysql = require("mysql");
var bodyParser = require("body-parser");
var app = express();
var path = require("path");

// Utiliser Bootstrap

app.use('/bootstrap-3.3.7-dist', express.static(path.join(__dirname, '/bootstrap-3.3.7-dist')));

// Accès à la base de données

var db = mysql.createConnection({
  host : 'localhost',
  user : 'root',
  password : '',
  database : 'COLOC',
  multipleStatements: true
});

// Connexion à la base de données, affiche dans le terminal si la base est bien connectée ou non

db.connect(function(err) {
  if (!err) {
    console.log("Database connected");
  } else {
    console.log("Database not connected");
  }
});

app.use(bodyParser.urlencoded({extended: true}));

app.get("/", function(req, res) {
  fs.readFile('sql/consultation/list_coloc.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query(data, function(err, rows_coloc, fields) {
      if (err)
        throw err;
      db.query('select * from PERSONNE', function(err, rows_personne, fields) {
        if (err)
          throw err;
        db.query('select * from COLOCATION', function(err, rows_colocation, fields) {
          if (err)
            throw err;
          db.query('select * from COLOCATAIRE', function(err, rows_colocataire, fields) {
            if (err)
              throw err;
          res.render('home.ejs', {rows_coloc: rows_coloc, rows_personne:rows_personne, rows_colocation: rows_colocation, rows_colocataire: rows_colocataire});
          });
        });
      });
    });
  });
});

app.post("/recreer_base", function(req, res) {
  fs.readFile('sql/administration/dropall.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query(data, function(err, rows, fields) {
      if (err)
        throw err;
      fs.readFile('sql/administration/create.sql', 'utf-8', function(err, data) {
        if (err)
          throw err;
        db.query(data, function(err, rows, fields) {
          if (err)
            throw err;
          res.redirect('/');
        });
      });
    });
  });
});

app.post("/ajouter_donnees", function(req, res) {
  fs.readFile('sql/administration/donnees.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query(data, function(err, rows, fields) {
      if (err)
        throw err;
      res.redirect('/');
    });
  });
});

app.post("/supprimer_donnees", function(req, res) {
  fs.readFile('sql/administration/clean.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query(data, function(err, rows, fields) {
      if (err)
        throw err;
      res.redirect('/');
    });
  });
});

app.post("/ajouter_personne", function(req, res) {
  db.query({
    sql: 'insert into PERSONNE values (null, ?, ?, ?, ?, ?)',
    values: [req.body.nom, req.body.prenom, req.body.mail, req.body.adresse, req.body.telephone]
    }, function(err, rows, fields) {
      if (err)
        throw err;
      res.redirect('/');
    });
});

app.post("/ajouter_colocation", function(req, res) {
  db.query({
    sql: 'insert into COLOCATION values (null, ?, ?, ?)',
    values: [req.body.nom, req.body.adresse, req.body.gestionnaire]
    }, function(err, rows, fields) {
      if (err)
        throw err;
      res.redirect('/');
    });
});

app.post("/ajouter_colocataire", function(req, res) {
  console.log(req.body.personne);
  console.log(req.body.colocation);
  console.log(req.body.date_entree);
  db.query({
    sql: 'insert into COLOCATAIRE values (null, ?, ?, ?, null)',
    values: [req.body.personne, req.body.colocation, req.body.date_entree]
    }, function(err, rows, fields) {
      if (err)
        throw err;
      res.redirect('/');
    });
});

app.post("/terminer_colocataire", function(req, res) {
  fs.readFile('sql/modification/terminer_colocataire', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query({
      sql: data,
      values: [req.body.date_sortie, req.body.personne, req.body.colocation]
      }, function(err, rows, fields) {
        if (err)
          throw err;
        res.redirect('/');
    });
  });
});

app.post("/ajouter_cagnotte", function(req, res) {
  db.query({
    sql: 'insert into CAGNOTTE values (null, ?)',
    values: [req.body.colocation]
    }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post("/ajouter_versement", function(req, res) {
  db.query({
    sql: 'insert into VERSEMENT values (null, ?, ?, ?, ?)',
    values: [req.body.date_versement, req.body.montant, req.body.personne_source, req.body.personne_dest]
    }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post("/modifier_personne", function(req, res) {
  db.query({
    sql: 'select * from PERSONNE where ID_PERSONNE = ? ',
    values: [req.body.personne]
    }, function(err, rows_personne, fields) {
    if (err)
      throw err;
    res.render('modifier_personne.ejs', {personne: req.body.personne, rows_personne: rows_personne});
  });
});

app.post("/modifier_personne_2", function(req, res) {
  db.query({
    sql: 'update PERSONNE set NOM_PERSONNE = ? , PRENOM_PERSONNE = ? , MAIL_PERSONNE = ? , ADRESSE_PERSONNE = ?, TELEPHONE_PERSONNE = ? where ID_PERSONNE = ? ',
    values: [req.body.nom, req.body.prenom, req.body.mail, req.body.adresse, req.body.telephone, req.body.personne]
  }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post("/modifier_colocation", function(req, res) {
  db.query({
    sql: 'select * from PERSONNE'
  }, function(err, rows_personne, fields) {
    if (err)
      throw err;
    db.query({
      sql: 'select * from COLOCATION where ID_COLOCATION = ? ',
      values: [req.body.colocation]
      }, function(err, rows_colocation, fields) {
      if (err)
        throw err;
      res.render('modifier_colocation.ejs', {colocation: req.body.colocation, rows_colocation: rows_colocation, rows_personne: rows_personne});
    });
  });
});

app.post("/supprimer_personne", function(req, res) {
  db.query({
    sql: 'delete from PERSONNE where ID_PERSONNE = ? ',
    values: [req.body.personne]
  }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post("/modifier_colocation_2", function(req, res) {
  db.query({
    sql: 'update COLOCATION set NOM_COLOCATION = ? , ADRESSE_COLOCATION = ?, ID_PERSONNE = ? where ID_COLOCATION = ? ',
    values: [req.body.nom, req.body.adresse, req.body.gestionnaire, req.body.colocation]
  }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post("/modifier_colocataire", function(req, res) {
  db.query({
    sql: 'select * from COLOCATAIRE where ID_COLOCATAIRE = ? ',
    values: [req.body.colocataire]
    }, function(err, rows_colocataire, fields) {
    if (err)
      throw err;
    db.query('select * from PERSONNE', function(err, rows_personne, fields) {
      if (err)
        throw err;
      db.query('select * from COLOCATION', function(err, rows_colocation, fields) {
        if (err)
          throw err;
        res.render('modifier_colocataire.ejs', {colocataire: req.body.colocataire, rows_colocataire: rows_colocataire, rows_personne: rows_personne, rows_colocation: rows_colocation});
      });
    });
  });
});

app.post("/modifier_colocataire_2", function(req, res) {
  db.query({
    sql: 'update COLOCATAIRE set ID_PERSONNE = ? , ID_COLOCATION = ? , DATE_ENTREE_COLOC = ? , DATE_SORTIE_COLOC = ? where ID_COLOCATAIRE = ? ',
    values: [req.body.personne, req.body.colocation, req.body.date_entree, req.body.date_sortie, req.body.colocataire]
  }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});


app.post("/aucun_achat", function(req, res) {
  fs.readFile('sql/consultation/list_aucun_achat.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query(data, function(err, rows, fields) {
      if (err)
        throw err;
      res.render('aucun_achat.ejs', {rows: rows, length: rows.length});
    });
  });
});

app.post("/nombre_coloc", function(req, res) {
  fs.readFile('sql/statistiques/coloc_nbr_members.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query({
      sql: data,
      values: [req.body.date]
      }, function(err, rows, fields) {
      if (err)
        throw err;
      res.render('nombre_coloc.ejs', {rows: rows});
    });
  });
});

app.get("/:colocation/", function(req, res) {
  fs.readFile('sql/consultation/members_coloc.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query({
      sql: data,
      values: [req.params.colocation]
      }, function(err, rows_personne, fields) {
      if (err)
        throw err;
      fs.readFile('sql/statistiques/members_solde.sql', 'utf-8', function(err, data) {
        if (err)
          throw err;
        db.query({
          sql: data,
          values: [req.params.colocation]
        }, function(err, rows_solde, fields) {
          if (err)
            throw err;
          db.query(
            {sql: 'SELECT * from COLOCATION where NOM_COLOCATION = ?',
            values: req.params.colocation
            }, function(err, rows_coloc, fields) {
            if (err)
              throw err;
            db.query(
              {sql: 'SELECT * from CAGNOTTE, COLOCATION where NOM_COLOCATION = ? and CAGNOTTE.ID_COLOCATION = COLOCATION.ID_COLOCATION',
              values: req.params.colocation
              }, function(err, rows_cagnotte, fields) {
              if (err)
                throw err;
              db.query(
                {sql: 'SELECT * from ACHAT, COLOCATION where COLOCATION.NOM_COLOCATION = ? and ACHAT.ID_COLOCATION = COLOCATION.ID_COLOCATION',
                values: [req.params.colocation]
                }, function(err, rows_achat, fields) {
                if (err)
                  throw err;
                res.render('colocation.ejs', {colocation: req.params.colocation, rows_solde: rows_solde, rows_personne: rows_personne, rows_coloc: rows_coloc, rows_cagnotte: rows_cagnotte, rows_achat: rows_achat});
              });
            });
          });
        });
      });
    });
  });
});

app.get("/:colocation/mois/:mois", function(req, res) {
  fs.readFile('sql/consultation/list_achat.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query({
      sql: data,
      values: [req.params.mois, req.params.colocation]
      }, function(err, rows_achat, fields) {
      if (err)
        throw err;
      fs.readFile('sql/statistiques/achat_list_pers.sql', 'utf-8', function(err, data) {
        if (err)
          throw err;
        db.query({
          sql: data,
          values: [rows_achat.ID_ACHAT]
          }, function(err, rows_pers, fields) {
            if (err)
              throw err;
            res.render('achats_par_mois.ejs', {mois: req.params.mois, colocation: req.params.colocation, rows_achat: rows_achat, rows_pers: rows_pers});
        });
      });
    });
  });
});

app.get("/:colocation/colocataire/:id_colocataire", function(req, res) {
  fs.readFile('sql/statistiques/list_credit.sql', 'utf-8', function(err, data) {
    if (err)
      throw err;
    db.query({
      sql: data,
      values: [req.params.id_colocataire, req.params.id_colocataire, req.params.id_colocataire]
      }, function(err, rows_credit, fields) {
      if (err)
        throw err;
      fs.readFile('sql/statistiques/list_debit.sql', 'utf-8', function(err, data) {
        if (err)
          throw err;
        db.query({
          sql: data,
          values: [req.params.id_colocataire, req.params.id_colocataire]
        }, function(err, rows_debit, fields) {
          if (err)
            throw err;
          db.query({
            sql: 'select CAGNOTTE.ID_CAGNOTTE, COLOCATION.NOM_COLOCATION from CAGNOTTE, COLOCATION where NOM_COLOCATION = ? and CAGNOTTE.ID_COLOCATION = COLOCATION.ID_COLOCATION',
            values: [req.params.colocation]
            }, function(err, rows_cagnotte, fields) {
            if (err)
              throw err;
            res.render('liste_debit_credit.ejs', {colocation: req.params.colocation, id_colocataire: req.params.id_colocataire, rows_credit: rows_credit, rows_debit: rows_debit, rows_cagnotte: rows_cagnotte});
          });
        });
      });
    });
  });
});

app.post('/:colocation/voir_liste_pers', function(req, res) {
  var personne = req.body.personne;
  db.query({
    sql: 'select * from PERSONNE where ID_PERSONNE = ?',
    values: [req.body.personne]
    }, function(err, rows_personne, fields) {
    if (err)
      throw err;
    fs.readFile('sql/statistiques/credit.sql', 'utf-8', function(err, data) {
      if (err)
        throw err;
      db.query({
        sql: data,
        values: [req.body.personne]
      }, function(err, rows_credit, fields) {
        if (err)
          throw err;
        fs.readFile('sql/statistiques/debit.sql', 'utf-8', function(err, data) {
          if (err)
            throw err;
          db.query({
            sql: data,
            values: [req.body.personne]
          }, function(err, rows_debit, fields) {
            if (err)
              throw err;
            fs.readFile('sql/statistiques/debit_credit.sql', 'utf-8', function(err, data) {
              if (err)
                throw err;
              db.query({
                sql: data,
                values: [req.body.personne]
              }, function(err, rows_both, fields) {
                if (err)
                  throw err;
                console.log(JSON.stringify(rows_credit));
                console.log(JSON.stringify(rows_debit));
                res.render('liste_debit_credit2.ejs', {colocation: req.params.colocation, rows_both: rows_both, personne: personne, rows_credit: rows_credit, rows_debit: rows_debit, rows_personne: rows_personne});
              });
            });
          });
        });
      });
    });
  });
});

app.post('/:colocation/colocataire/:id_colocataire/ajouter_participation', function(req, res) {
  db.query({
    sql: 'insert into PARTICIPATION values (null, ?, ?, ?, ?)',
    values: [req.params.id_colocataire, req.body.cagnotte, req.body.date_participation, req.body.montant]
    }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post('/:colocation/ajouter_achat', function(req, res) {
  db.query({
    sql: 'insert into ACHAT values (null, ?, ?, ?, ?, ?)',
    values: [req.body.intitule, req.body.date_achat, req.body.montant, req.body.colocation, req.body.personne]
    }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.post('/:colocation/ajouter_concerne', function(req, res) {
  db.query({
    sql: 'insert into CONCERNE values (?, ?)',
    values: [req.body.achat, req.body.personne]
    }, function(err, rows, fields) {
    if (err)
      throw err;
    res.redirect('/');
  });
});

app.listen(8080);