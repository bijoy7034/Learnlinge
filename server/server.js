const express = require("express")
const dotenv = require("dotenv")
const { default: mongoose } = require("mongoose")
const userRouter = require("./routes/userRoutes")
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const groupRoutes = require("./routes/groupRoutes");
const {createServer, Server} = require('http')
const {server, Socket} = require('socket.io')
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


const httpServer = createServer(app)
const io = new Server(httpServer)

io.on('connection', (socket)=>{
    console.log('kjwbckwbjdklknjcwojvownjln')
})



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

