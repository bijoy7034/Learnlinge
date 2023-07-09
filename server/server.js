const express = require("express")
const dotenv = require("dotenv")
const { default: mongoose } = require("mongoose")
const userRouter = require("./routes/userRoutes")
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const groupRoutes = require("./routes/groupRoutes");

dotenv.config()
const app = express()

port = process.env.PORT || 4000
mongo_url = process.env.MONGO_URL

//middleware
app.use(cookieParser());
app.use(bodyParser.json());
app.use((req, res, next) => {
    console.log(req.path, req.method);
    next();
  });

//Routes
app.use('/api/users', userRouter)
app.use('/api/groups', groupRoutes)

//server
mongoose.connect(mongo_url)
.then(()=>{
    app.listen(port, ()=>{
        console.log(`Server is running ${port} and connected to mongo`)
    })
})
.catch((err)=>{
    console.log(`Error : ${err}`)
})

