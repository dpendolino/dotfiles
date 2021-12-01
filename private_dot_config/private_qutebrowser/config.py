# https://qutebrowser.org/doc/help/configuring.html
import dracula.draw
config.load_autoconfig()
config.bind("\\p", "spawn --userscript qute-lastpass")
config.bind("\\v", "spawn --userscript view_in_mpv")
config.bind("\\s", "spawn --userscript qutepocket")
config.source('nord-qutebrowser.py')
# dracula.draw.blood(c, {
#     'spacing': {
#         'vertical': 6,
#         'horizontal': 8
#     }
# })
