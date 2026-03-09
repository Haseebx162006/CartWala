const jwt = require('jsonwebtoken')

const generate_token = async function (id) {
    try {
        await jwt.sign({id},process.env.SECRET_KEY)
    } catch (error) {
        console.log('failed to gen token', error)
    }

}

module.exports= generate_token