import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

# 1 (a+b)
driver_chrome = webdriver.Chrome(executable_path="C:/Git/Repos/GitHub/selenium/chromedriver/chromedriver.exe")
driver_chrome.get('https://www.walla.co.il')
print(driver_chrome.title())

"""
#
driver_fox = webdriver.Firefox(executable_path="C:/Git/Repos/GitHub/selenium/firefoxdriver/geckodriver.exe")
driver_fox.get('https://www.ynet.co.il/')
driver_fox.quit()
# 
"""

#2.


