var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Is My Sensor Up?', stuff: 'Maybe' });
});

module.exports = router;
