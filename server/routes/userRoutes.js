const express = require('express');
const { login, createAccount } = require('../controllers/usersController');

const userRouter  = express.Router()

userRouter.post('/login', login)
userRouter.post('/create', createAccount)


module.exports= userRouter