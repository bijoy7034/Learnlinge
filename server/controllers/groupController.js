const jwt = require("jsonwebtoken");
const studyGroupSchema = require("../models/groupModel");
const userModel = require('../models/userModel');
const { default: mongoose } = require("mongoose");

//create study group
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

//get study one group 

const getStudyGroup = async(req, res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;
            const { id } = req.params
           const groups = await studyGroupSchema.find({_id : id})
           if(!groups) return res.status(400).json({msgg : "Error"})

           return res.status(200).json(groups)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}


//get all study group 
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
           const groups = await studyGroupSchema.find({})
           if(!groups) return res.status(400).json({msgg : "Error"})

           return res.status(200).json(groups)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}


//get all study group created by the creator
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

//update the study group
const updateGroup = async(req,res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;
            const { id } = req.params
            if (!mongoose.Types.ObjectId.isValid(id)) {
                return res.status(400).json({ error: "No such workout" });
              }
            const group = await studyGroupSchema.findOneAndUpdate(
                {_id : id},
                {...req.body}
            )

            if(!group) return res.status(400).json({mssg:"Not uodated"})

            res.status(200).json(group)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}

//join group

const joinGroup = async(req,res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;
            const { id } = req.params
            if (!mongoose.Types.ObjectId.isValid(id)) {
                return res.status(400).json({ error: "No such workout" });
              }
            const group = await studyGroupSchema.findOneAndUpdate(
                { _id: id },
                { $push: { members: req.user.id } },
                { new: true }
            )
            if(!group) return res.status(400).json({mssg:"Not uodated"})
            const userUpdate = await userModel.findOneAndUpdate(
                { _id : req.user.id },
                {$push : {studyGroups : id}}
            )
            res.status(200).json(group)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}

//leave a study group 

const leaveStudyGroup = async(req,res)=>{
    try{
        const token = req.headers.authorization.split(" ")[1];
        if(!token){
            return res.status(401).json({mssg : "Not authenticated"})
        }

        jwt.verify(token, 'secret_key', async(err, user)=>{
            if (err) return res.status(403).json({mssg :"Token not valid"});
            req.user = user;
            const { id } = req.params
            if (!mongoose.Types.ObjectId.isValid(id)) {
                return res.status(400).json({ error: "No such workout" });
              }
            const group = await studyGroupSchema.findOneAndUpdate(
                { _id: id },
                { $pull: { members: req.user.id } },
                { new: true }
            )
            if(!group) return res.status(400).json({mssg:"Not uodated"})
            const userUpdate = await userModel.findOneAndUpdate(
                { _id : req.user.id },
                {$pull : {studyGroups : id}}
            )
            res.status(200).json(group)
        })
    }catch(err){
        res.status(400).json({error : err.messaage})
    }
}



module.exports = {
    creategroup,
    getAll,
    getByCreated,
    getStudyGroup,
    updateGroup,
    joinGroup,
    leaveStudyGroup
}