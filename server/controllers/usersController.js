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
    if (!user) return res.status(404).json({ mssg: "User Not Found" });

    const isPasswordCorrect = await bcrypt.compare(
      req.body.password,
      user.password
    );
    if (!isPasswordCorrect) {
      return res.status(404).json({ mssg: "Wrong password" });
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

module.exports= {
    createAccount,
    login
}