const express = require('express');
const { login, createAccount, fetchUser } = require('../controllers/usersController');

const userRouter  = express.Router()

userRouter.post('/login', login)
userRouter.post('/create', createAccount)
userRouter.get('/userProfile', fetchUser)


module.exports= userRouter