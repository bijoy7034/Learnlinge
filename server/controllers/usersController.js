const userModel = require('../models/userModel');
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

const createAccount = async(req,res)=>{
  const salt = bcrypt.genSaltSync(10);
  const hash = bcrypt.hashSync(req.body.password, salt);
  const email = req.body.email;
  const password = hash;
  const name = req.body.name;

  try {
    const user = await userModel.create({ name,email, password });
    if (!user) {
      return res.status(400).json({ mssg: "Not Created" });
    }
    res.status(200).json(user);
  } catch (err) {
    return res.status(400).json({ error: err.message });
  }
}
const login = async(req,res)=>{
  try {
    const user = await userModel.findOne({ email: req.body.email });
    if (!user) return res.status(402).json({ mssg: "User Not Found" });

    const isPasswordCorrect = await bcrypt.compare(
      req.body.password,
      user.password
    );
    if (!isPasswordCorrect) {
      return res.status(401).json({ mssg: "Wrong password" });
    }

    //token
    const token = jwt.sign({ id: user._id }, "secret_key");
    const { password, role, ...otherDetails } = user._doc;
    res
      .cookie("access_token", token, {
        httpOnly: true,
      })
      .status(200)
      .json({ details: { ...otherDetails }, access_token: token, role });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
}

const fetchUser = async(req,res)=>{
  try{
    const token = req.headers.authorization.split(" ")[1];
    if(!token){
        return res.status(401).json({mssg : "Not authenticated"})
    }
    jwt.verify(token, 'secret_key', async(err, user)=>{
        if (err) return res.status(403).json({mssg :"Token not valid"});
        req.user = user;

       const userInfo = await userModel.findOne({_id : user.id})
       if(!userInfo) return res.status(400).json({mssg:"Not Found"})

       res.status(200).json(userInfo)
    })
}catch(err){
    res.status(400).json({error : err.messaage})
}
}

module.exports= {
    createAccount,
    login,
    fetchUser
}