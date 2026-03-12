const product = require('../models/Product')   
exports.createProduct = async(req, res)=>{
   const { name, description, price, category } = req.body
   try {
    if(!name || !description || !price || !category){
        return res.status(400).json({message:"All fields are required"})
    }
    if( typeof name !=='string' || typeof description !=='string' || typeof price !=='number' || typeof category !=='string'){
        return res.status(400).json({message:"Invalid data types"})
    }

    const newProduct = await product.create({ name, description, price, category })
    res.status(201).json(newProduct);
}  
catch(error){   
        res.status(500).json({message:"Server error"})
    }   
}

exports.getProducts = async(req, res)=>{
    try {
        const products = await product.find()
        res.status(200).json(products)
    } catch (error) {
        res.status(500).json({message:"Server error"})
    }      
}

exports.getProductById = async(req, res)=>{
    const { id } = req.params
    try {
        const productById = await product.findById(id)
        if(!productById){
            return res.status(404).json({message:"Product not found"})
        }
        res.status(200).json(productById)
    } catch (error) {
        res.status(500).json({message:"Server error"})
    }
}

exports.updateProduct = async(req, res)=>{
    const { id } = req.params
    const { name, description, price, category } = req.body;
    try {
        const updatedProduct = await product.findByIdAndUpdate(id, { name, description, price, category }, { new:true})
        if(!updatedProduct){
            return res.status(404).json({message:"Product not found"})
        }
        res.status(200).json(updatedProduct)
    } catch (error) {
        res.status(500).json({message:"Server error"})
    }
}

exports.deleteProduct = async (req, res) => {

  const { id } = req.params

  try {

    const productUpdated = await product.findByIdAndUpdate(
      id,
      { isActive: false },
      { new: true }
    )

    if(!productUpdated){
      return res.status(404).json({message:"Product not found"})
    }

    res.status(200).json({message:"Product deactivated"})

  } catch (error) {
    res.status(500).json({message:"Server error"})
  }
}

