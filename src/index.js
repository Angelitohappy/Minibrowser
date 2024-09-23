import express from 'express'
import morgan from 'morgan';
import { engine } from 'express-handlebars';
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'
import pool from './database.js'
import session from 'express-session';

//Intialization
const app = express();
const __dirname = dirname(fileURLToPath(import.meta.url));


//Settings
app.set('port', process.env.PORT || 3000);
app.set('views', join(__dirname, 'views'));
app.engine('.hbs', engine({
    defaultLayout: 'main',
    layoutsDir: join(app.get('views'), 'layouts'),
    partialsDir: join(app.get('views'), 'partials'),
    extname: '.hbs'
}));
app.set('view engine', '.hbs');

//Middlewares
app.use(morgan('dev'));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(session({
    secret: 'tu_secreto_aqui',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

//Routes
app.get('/', (req, res) => {
    res.render('index')
});

app.post('/dashboard', (req, res) => {
    res.render('/src/dashboard')
});

app.get('/logout', (req, res) => {
    res.render('index')
});

//sign in
app.get('/login', (req, res) => {
    res.render('users/log_in'); // Asegúrate de que esta ruta es correcta
});

//sign in
app.get('/logup', (req, res) => {
    res.render('users/log_up'); // Asegúrate de que esta ruta es correcta
});

app.post('/sign_in', async (req, res) => {
    const { user, password } = req.body; // Obtener los datos del formulario
    try {
        const [rows] = await pool.query('SELECT * FROM usuarios WHERE nombre = ?', [user]);
        console.log('Resultado de la consulta:', rows); // Verifica el resultado de la consulta

        if (rows.length > 0) {
            const usuario = rows[0];
            console.log('Usuario encontrado:', usuario);
            console.log('Contraseña ingresada:', password);
            console.log('Contraseña almacenada:', usuario['contraseña']); // Acceso correcto

            if (usuario['contraseña'].trim() === password.trim()) {
                const userName = user; // Este valor debería venir de tu base de datos
                req.session.userName = userName;
                console.log('Sesión antes de establecer userId:', req.session); // Verifica la sesión
                req.session.userId = usuario.id_usuario; // Guardar el ID del usuario en la sesión
                const userInitial = req.session.userName ? req.session.userName.charAt(0) : '';
                res.render('users/dashboard', { userInitial }); // Redirigir a la página del dashboard
            } else {
                res.status(401).send('Incorrect password');
            }
        } else {
            res.status(404).send('User not found');
        }
    } catch (error) {
        console.error('query error:', error.message);
        res.status(500).send('server error');
    }
});



app.post('/register', async (req, res) => {
    const { fullName, email, password, confirmPassword } = req.body;

    if (password !== confirmPassword) {
        return res.status(400).send('Passwords do not match');
    }

    try {
        // Check if the email is already registered
        const [existingUser] = await pool.query('SELECT * FROM usuarios WHERE email = ?', [email]);
        if (existingUser.length > 0) {
            return res.status(400).send('Email already registered');
        }

        // Insert the new user into the database
        await pool.query(
            'INSERT INTO usuarios (nombre, email, contraseña, fecha_registro) VALUES (?, ?, ?, NOW())',
            [fullName, email, password]
        );
        res.render('users/log_in');

    } catch (error) {
        console.error('Error registering user:', error.message);
        res.status(500).send('Server error');
    }
});

app.get('/results', async (req, res) => {
    const query = req.query.query;
    try {
        const [results] = await pool.query('SELECT * FROM pages WHERE title LIKE CONCAT("%", ?, "%")', [query]);
        res.render('search/results_table2', { query, results });
    } catch (error) {
        console.error('Error searching for results:', error.message);
        res.status(500).send('server error');
    }
});

app.get('/results2', async (req, res) => {
    const query = req.query.query;
    try {
        const [results] = await pool.query('SELECT * FROM pages WHERE title LIKE CONCAT("%", ?, "%")', [query]);
        res.render('search/results_table', { query, results });
    } catch (error) {
        console.error('Error searching for results:', error.message);
        res.status(500).send('Error server');
    }
});


//Public files
app.use(express.static(join(__dirname, 'public')));

//Run Server
app.listen(app.get('port'), () =>
    console.log('Server listening on port', app.get('port')));