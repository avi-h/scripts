from flask import Flask
import Utils

app = Flask(__name__)

error_html_template = '<html>' \
            '<head>' \
                '<title>Scores Game</title>' \
            '</head>' \
            '<body>' \
                '<h1>' \
                    '<div id="score" style="color:red">{ERROR}</div>' \
                '</h1>' \
            '</body>' \
      '</html>'

no_error_html_template = '<html>' \
            '<head>' \
                '<title>Scores Game</title>' \
            '</head>' \
            '<body>' \
                '<h1>' \
                    'The score is <div id="score">{SCORE}</div>' \
                '</h1>' \
            '</body>' \
      '</html>'


# This function will serve the score. It will read the score from the scores file
# and will rbe shown on scores site
@app.route("/")
def score_server():
    try:   # try to open file with scores. If succeeded, define BAD_RETURN_CODE = 0
        with open(Utils.SCORES_FILE_NAME, "r") as file:
            current_score = file.read()
            Utils.define_BAD_RETURN_CODE(0)
    except: # If not succeeded, define BAD_RETURN_CODE = 1
        print('Could not open Scores.txt.')
        Utils.define_BAD_RETURN_CODE(1)

    if Utils.BAD_RETURN_CODE == 0:
        html_text = no_error_html_template.format(SCORE = current_score)
    else:
        html_text = error_html_template.format(ERROR = "Read-Write Error")
    return html_text


if __name__ == "__main__":
    app.run(debug=True)