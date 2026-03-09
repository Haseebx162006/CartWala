const mongoose= require('mongoose')
const bcrypt= require('bcrypt')

const userSchema = mongoose.Schema({
    name:{
        type:String,
        required:true
    },
    email:{
        type:String,
        unique:true,
        require:true,
    
    },
    password:{
        type:String,
        required:true
    },
    phone:{
        type:String,
        unique: true
    },
    role:{
        type: String,
        enum:['Admin',"User"],
        default: 'User'
    },
    created_at:{
        type:Date,
        default: Date.now()
    },
    updated_at:{
        type:Date,
        default: Date.now()
    }
})
userSchema.pre("save", async function() {
    if(!this.isModified("password"))
        return

    const salt= await bcrypt.genSalt(10)
    this.password=await bcrypt.hash(this.password,salt)
    
})


userSchema.methods.matchPassword = async function (enteredPassword) {
    return bcrypt.compare(enteredPassword,this.password)
}
module.exports= mongoose.model("user",userSchema)