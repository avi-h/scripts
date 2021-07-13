import webbrowser
from selenium import webdriver
import time
from datetime import date
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.keys import Keys

browser = webdriver.Chrome(executable_path="C:/Git/Repos/GitHub/selenium/chromedriver/chromedriver.exe")
browser.get("https://walla.co.il")
# browser.find_element_by_xpath('//*[@id="billamt"]').send_keys('150')
# ele01 = browser.find_element_by_id('serviceQual')


#browser.back()
#browser.forward()
#browser.refresh()

print(browser.title)
print(browser.current_url)
print(browser.name)

time.sleep(5)

browser.quit()