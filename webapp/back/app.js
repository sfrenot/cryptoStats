const express = require('express');
const shell = require('shelljs');
const _ = require('lodash');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use((req, res, next) => {
   res.setHeader('Access-Control-Allow-Origin', '*');
   res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
   next();
 });

// api liste script
app.use('/api/ls', (req, res, next) => {
   commande = shell.exec('./ls.sh');
   res.status(200).json({ message: commande });
   next();
});

// api execution script
app.get('/api/lancescript', (req, res, next) => {
   leScript = req.query.script;
   extension = leScript.split('.')[1];
   var commande;


   if (extension == 'coffee'){
      if (leScript == 'addNewCryptosFromFreshData.coffee'){
         commande = shell.exec('pwd');
         last1 = shell.exec('ls -Art ../../files/ | grep cryptos | tail -n 1');
         last2 = last1.split('-')[1];
         theLast = last2.split('.')[0];
         commande = shell.exec('coffee ../../crawlers/' + leScript + ' ' + theLast);
      }
      else{
         commande = shell.exec('coffee ../../crawlers/' + leScript);
      }
   }
   else{
      commande = shell.exec('bash ../../crawlers/' + leScript);
   }


   if (commande.stdout != ''){
      res.status(200).json({ message: commande.stdout });
   }
   else{
      res.status(200).json({ message: commande.stderr });
   }
   next();
});

// api affiche code source script
app.get('/api/affichescript', (req, res, next) => {
   leScript = req.query.script;
   commande = shell.exec('cat ../../crawlers/' + leScript);

   if (commande.stdout != ''){
      res.status(200).json({ message: commande.stdout });
   }
   else{
      res.status(200).json({ message: commande.stderr });
   }
   next();
});

// api enregistre script
app.post('/api/savescript', (req, res, next) => {
   fichier = req.body.fichier;
   code = req.body.code;
   commande = 'echo "' + code + '" > ../../crawlers/' + fichier;
   shell.exec(commande);
   res.status(201).json({
      retour : req.body
   });
   next();
});

app.use('/', (req, res) => {
   res.status(404);
});


module.exports = app;
