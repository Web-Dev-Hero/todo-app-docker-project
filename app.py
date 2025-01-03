from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL Configuration
app.config['MYSQL_HOST'] = 'mysql.default.svc.cluster.local'
app.config['MYSQL_PORT'] = 3306
app.config['MYSQL_USER'] = 'admin'
app.config['MYSQL_PASSWORD'] = 'admin'
app.config['MYSQL_DB'] = 'todo_app'

mysql = MySQL(app)

# Route to display tasks
@app.route('/')
def index():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM tasks")
    tasks = cur.fetchall()
    cur.close()
    return render_template('index.html', tasks=tasks)

# Route to add a new task
@app.route('/add', methods=['POST'])
def add_task():
    if request.method == 'POST':
        title = request.form['title']
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO tasks (title) VALUES (%s)", [title])
        mysql.connection.commit()
        cur.close()
    return redirect(url_for('index'))

# Route to delete a task
@app.route('/delete/<int:task_id>')
def delete_task(task_id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM tasks WHERE id = %s", [task_id])
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('index'))

# Route to mark task as complete
@app.route('/complete/<int:task_id>')
def complete_task(task_id):
    cur = mysql.connection.cursor()
    cur.execute("UPDATE tasks SET status = TRUE WHERE id = %s", [task_id])
    mysql.connection.commit()
    cur.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

