from selenium import webdriver
from selenium.webdriver.common.keys import Keys

browser = webdriver.Chrome(executable_path="C:/Git/Repos/GitHub/selenium/chromedriver/chromedriver.exe")
browser.get("https://youtube.com")
print(browser.title)
print(browser.current_url)
print(browser.name)

browser.close()