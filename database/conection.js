// database.js
const mysql = require('mysql2/promise');

class Database {
    constructor(config) {
        this.connection = mysql.createPool(config);
    }

    async insert(sql, params) {
        try {
            const [result] = await this.connection.query(sql, params);
            return result.insertId;
        } catch (error) {
            console.error('Error al insertar:', error.message);
            throw error;
        }
    }

    async query(sql, params) {
        try {
            const [rows] = await this.connection.query(sql, params);
            return rows;
        } catch (error) {
            console.error('Error en la consulta:', error.message);
            throw error;
        }
    }

    async update(sql, params) {
        try {
            const [result] = await this.connection.query(sql, params);
            return result.affectedRows;
        } catch (error) {
            console.error('Error al actualizar:', error.message);
            throw error;
        }
    }

    async delete(sql, params) {
        try {
            const [result] = await this.connection.query(sql, params);
            return result.affectedRows;
        } catch (error) {
            console.error('Error al eliminar:', error.message);
            throw error;
        }
    }

    async close() {
        try {
            await this.connection.end();
        } catch (error) {
            console.error('Error al cerrar la conexión:', error.message);
            throw error;
        }
    }
}

module.exports = Database;
