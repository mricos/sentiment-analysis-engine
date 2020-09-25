export default function (req, res, next) {
    const { authorization } = req.headers;
    const { AUTH_KEY } = process.env
    if (authorization === AUTH_KEY) {
        next();
    } else {
        res.status(401).json({message: "Unauthorized."})
    }
}
