from selenium import webdriver

browser = webdriver.Chrome(executable_path="C:/Git/Repos/GitHub/selenium/chromedriver/chromedriver.exe")
browser.get("file:C:/Git/Repos/GitHub/web/tip_calc/index.html")
print(browser.title)



#browser.close()