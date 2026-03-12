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
        unique: true,
        sparse: true,
        default: undefined
    },
    role:{
        type: String,
        enum:['admin','buyer','seller'],
        default: 'buyer'
    },
    firebaseUid:{
        type: String,
        unique: true,
        sparse: true
    },
    jazzcashNumber:{
        type: String,
        default: ''
    },
    created_at:{
        type:Date,
        default: Date.now
    },
    updated_at:{
        type:Date,
        default: Date.now
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