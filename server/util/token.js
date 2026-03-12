const jwt = require('jsonwebtoken')

const generate_token = async function (id) {
    try {
       return await jwt.sign({id},process.env.SECRET_KEY,{
        expiresIn:'7d'
       })
    } catch (error) {
        console.log('failed to gen token', error)
    }

}

module.exports= generate_token