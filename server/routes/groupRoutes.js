const express = require('express');
const { creategroup, getAll, getByCreated } = require('../controllers/groupController');

const groupRoutes = express.Router()

groupRoutes.post('/create', creategroup)
groupRoutes.get('/', getAll)
groupRoutes.get('/created', getByCreated)

module.exports = groupRoutes