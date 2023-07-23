const express = require('express');
const { creategroup, getAll, getByCreated, getStudyGroup, updateGroup, joinGroup, leaveStudyGroup, getUserStudyGroup } = require('../controllers/groupController');

const groupRoutes = express.Router()

groupRoutes.post('/create', creategroup)
groupRoutes.get('/', getAll)
groupRoutes.get('/created', getByCreated)
groupRoutes.get('/group/:id', getStudyGroup)
groupRoutes.get('/groupsJoin', getUserStudyGroup)
groupRoutes.patch('/editGroup/:id', updateGroup)
groupRoutes.patch('/join/:id', joinGroup)
groupRoutes.patch('/leave/:id', leaveStudyGroup)


module.exports = groupRoutes