const User = require('../models/User')
const genToken=require('../util/token')
exports.signUp= async(req,res)=>{

    const {name,email,password,phone} = req.body
    try{
        if(!name || !email || !password || !phone){
            return res.status(400).json({message:"All fields are required"})
        }

        // Name validation
        if(typeof name !== 'string' || name.trim().length < 3){
            return res.status(400).json({message:"Name must be at least 3 characters long"})
        }

        if(typeof email !== 'string' || !email.includes('@')){
            return res.status(400).json({message:"Invalid email format"})
        }

        if(typeof password !== 'string' || password.length < 6){    
            return res.status(400).json({message:"Password must be at least 6 characters long"})

        }

        if(typeof phone !== 'string'){    
            return res.status(400).json({message:"Enter a valid Phone number"})
            
        }

        const existingUser = await User.findOne({email});

        if(existingUser){
            return res.status(400).json({message:"User Already Exists Bhai"})
        }


        
        const user = await User.create({
            name:name,
            email:email,
            password:password,
            phone:phone
        })

        const token= genToken(user._id)
        return res.status(201).json({
            success: true,
            result: token
        })

        
    }catch(error){
        res.status(500).json({message:"Server error"})
    }
}

exports.login = async( req, res)=>{
    const { email , password} = req.body

    try {
        
    if(!email || !password){
        return res.status(400).json({
            msg:"All fields are required"
        })
    }

       if(typeof email !== 'string' || !email.includes('@')){
            return res.status(400).json({message:"Invalid email format"})
        }

        if(typeof password !== 'string' || password.length < 6){    
            return res.status(400).json({message:"Password must be at least 6 characters long"})
        }

    const existingUser =  User.findOne({email})
    if(!existingUser){
        return res.status(404).json({
            msg:"User does not exist . Signup karo"
        }
        )
    }

    const match = existingUser.matchPassword(password);

    if(!match){
        return res.status(401).json({
            msg:"Invalid credentials"
        })      
    }

    const token = genToken(existingUser._id)
    return res.status(200).json({
        success: true,
        result: token
    })
    } catch (error) {
        console.log("Erro in login")
    }

}