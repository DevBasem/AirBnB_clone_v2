#!/usr/bin/python3
"""
Starts a Flask web application.
"""

from flask import Flask, render_template
from models import storage
from models.state import State

app = Flask(__name__)


@app.route('/states', strict_slashes=False)
def states():
    """Displays a HTML page showing all states."""
    states = storage.all(State).values()
    states = sorted(states, key=lambda state: state.name)

    return render_template('9-states.html', states=states)


@app.route('/states/<state_id>', strict_slashes=False)
def state_cities(state_id):
    """Displays a HTML page showing cities of a state."""
    state = storage.get(State, state_id)

    if state:
        cities = sorted(state.cities, key=lambda city: city.name)
        return render_template('9-states.html', state=state, cities=cities)
    else:
        return render_template('9-states.html', not_found=True)


@app.teardown_appcontext
def teardown_db(exception):
    """Closes the current SQLAlchemy session."""
    storage.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
