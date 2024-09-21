import {Router} from 'express'
import pool from '../database.js'

const router = Router();

//login
router.get('/sign_in', async(req,res)=>{
    try{
        const [result] = await pool.query('SELECT * FROM usuarios WHERE user = ?', [user])
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
    }
    catch(err){
        console.error('Error en la consulta:', error.message);
        res.status(500).send('Error en el servidor');
    }
});

//result list
router.get('/list', async(req, res)=>{
    try{
        const [result] = await pool.query('SELECT url, title FROM pages where title like %?% ', [dato]);
        res.render('personas/list', {personas: result});
    }
    catch(err){
        res.status(500).json({message:err.message});
    }
});

export default router; 