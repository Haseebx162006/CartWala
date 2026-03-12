const mongoose = require('mongoose')

const ProductSchema = mongoose.Schema({
    name:{
        type:String,
        required:true},
    description:{
        type:String,
        required:true}, 
    price:{
        type:Number,
        required:true},
    category:{
        type:String,
        required:true},
    imageUrl:{
        type:String,
        default:''},
    storeId:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'store',
        default: null},
    sellerFirebaseUid:{
        type: String,
        default: ''},
    created_at:{
        type:Date,
        default: Date.now},
    updated_at:{
        type:Date,
        default: Date.now},

    isActive: {
    type: Boolean,
    default: true
  },
  stock: {
    type: Number,
    required: true,
    min: 0
  } 
        

})

module.exports = mongoose.model("product",ProductSchema)