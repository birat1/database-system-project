const express = require('express');
const ejs = require('ejs');
const mysql = require('mysql');
const util = require('util');
const bodyParser = require('body-parser');

const PORT = 8000;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_NAME = 'coursework';
const DB_PASSWORD = '';
const DB_PORT = 3306;

var connection = mysql.createConnection({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
    port: DB_PORT,
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect(function (err) {
    if (err) {
        console.error('error connecting to the database: ' + err.stack);
        return;
    }
    console.log('Connected!');
});

const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {
    const clubsCount = await connection.query('SELECT COUNT(*) as count FROM Club');
    const coursesCount = await connection.query('SELECT COUNT(*) as count FROM Course');
    const hobbiesCount = await connection.query('SELECT COUNT(*) as count FROM Hobby');
    const studentsCount = await connection.query('SELECT COUNT(*) as count FROM Student');

    res.render('index', {
        clubsCount: clubsCount[0].count,
        coursesCount: coursesCount[0].count,
        hobbiesCount: hobbiesCount[0].count,
        studentsCount: studentsCount[0].count,
    });
});

// displaying students and the ability to search for them
app.post('/students/search', async (req, res) => {
    const searchTerm = req.body.searchTerm;

    const searchResults = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code WHERE Stu_FName LIKE ?",
    [`${searchTerm}%`]);

    res.render('students', { students: searchResults, searchTerm: searchTerm });
});
app.route('/students')
    .get(async (req, res) => {
        const students = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code");

        res.render('students', { students: students, searchTerm: '' });
    })
    .post(async (req, res) => {
        const searchTerm = req.body.searchTerm;
        const searchResults = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code WHERE Stu_FName LIKE ?",
        [`${searchTerm}%`]);

        res.render('students', { students: searchResults, searchTerm: searchTerm });
    });


// displaying a specific student and the ability to edit them
app.get('/students/:urn', async (req, res) => {
    const student = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code WHERE URN = ?", 
    [req.params.urn]);

    res.render('view_one', { student: student[0] });
});
app.get('/students/:urn/edit', async (req, res) => {
    const student = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Stu_Course, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code WHERE URN = ?",
    [req.params.urn]);

    const courses = await connection.query("SELECT * FROM Course");

    res.render('edit_one', { student: student[0], courses: courses, message: '' });
});
app.post('/students/:urn/edit', async (req, res) => {
    const updatedStudent = req.body;

    const student = await connection.query("SELECT URN, Stu_FName, Stu_LName, DATE_FORMAT(Stu_DOB, '%d/%m/%Y') as Stu_DOB, Stu_Phone, Crs_Title, Stu_Email, Stu_Type FROM Student JOIN Course ON Student.Stu_Course = Course.Crs_Code WHERE URN = ?",
    [req.params.urn]);
    const courses = await connection.query("SELECT * FROM Course");

    if (isNaN(updatedStudent.Stu_Phone) || updatedStudent.Stu_Phone.length != 11) {
        message = 'Please enter a valid phone number with 11 digits!';
    } else {
        await connection.query("UPDATE Student SET ? WHERE URN = ?", [req.body, req.params.urn]);
        message = 'Student updated';
    }

    res.render('edit_one', { student: student[0], courses: courses, message: message });

});

// displaying information about courses, clubs, and hobbies
app.get('/courses', async (req, res) => {
    const courses = await connection.query("SELECT * FROM Course");

    res.render('courses', { courses: courses });
})
app.get('/clubs', async (req, res) => {
    const clubs = await connection.query("SELECT * FROM Club");

    res.render('clubs', { clubs: clubs });
});
app.get('/hobbies', async (req, res) => {
    const hobbies = await connection.query("SELECT * FROM Hobby");

    res.render('hobbies', { hobbies: hobbies });
});

app.listen(PORT, () => {
    console.log(`App is listening at http://localhost:${PORT}`);
});