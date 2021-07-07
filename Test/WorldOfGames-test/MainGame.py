from Live import load_game, welcome
from Utils import Pause_cmd, run_flask
import Utils

print(welcome("Guys"))
load_game()
# Pause_cmd()
run_flask()  # Rise web server to show game scores

