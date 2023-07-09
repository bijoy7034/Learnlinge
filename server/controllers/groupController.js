const jwt = require("jsonwebtoken");
const studyGroupSchema = require("../models/groupModel")

const creategroup = async (req,res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;

            const name = req.body.name
            const subject = req.body.subject
            const description = req.body.description
            const creator = req.user.id

            const group = await studyGroupSchema.create({name,subject,description,creator})
            
            if (!group) return res.status(400).json({mssg : "Not created"})
            
            return res.status(200).json(group)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}

const getAll = async (req, res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;

            id = req.user.id
           const groups = await studyGroupSchema.find({creator : id})
           if(!groups) return res.status(400).json({msgg : "Error"})

           return res.status(200).json(groups)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}
const getByCreated = async (req, res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;

            id = req.user.id
           const groups = await studyGroupSchema.find({creator : id})
           if(!groups) return res.status(400).json({msgg : "Error"})

           return res.status(200).json(groups)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}



module.exports = {
    creategroup,
    getAll,
    getByCreated
}