// server.js
const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const Database = require('./database');
const app = express();
const port = 3000;

const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'mini_browser'
};

const db = new Database(dbConfig);

// Middleware para parsear el cuerpo de las solicitudes
app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
    secret: 'holis', // Cambia esto por un secreto más seguro
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// Configura EJS como motor de plantillas
app.set('view engine', 'ejs');
app.set('views', __dirname + 'public/views'); // Ruta a la carpeta de vistas

const verifyAuth = (req, res, next) => {
    if (!req.session.userId) {
        return res.status(401).send('Acceso denegado. Inicia sesión primero.');
    }
    next();
};

// Ruta para manejar el inicio de sesión
app.post('/log_in', async (req, res) => {
    const { user, password } = req.body;

    try {
        const users = await db.query('SELECT * FROM usuarios WHERE user = ?', [user]);

        if (users.length > 0) {
            const user = users[0];
            const match = await bcrypt.compare(password, user.password);
            if (match) {
                req.session.userId = user.id;
                res.redirect('/dashboard');
            } else {
                res.status(401).send('Contraseña incorrecta');
            }
        } else {
            res.status(404).send('Usuario no encontrado');
        }
    } catch (error) {
        console.error('Error en la consulta:', error.message);
        res.status(500).send('Error en el servidor');
    }
});

// Ruta para la página de éxito (dashboard)
app.get('/dashboard', verifyAuth, (req, res) => {
    res.render('dashboard'); // Renderiza la plantilla dashboard.ejs
});

// Ruta para la página de inicio de sesión
app.get('/log_in', (req, res) => {
    res.render('log_in'); // Renderiza la plantilla log_in.ejs
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});
