
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

import fake_useragent as ua

import time

proxies={
    'http': 'http://127.0.0.1:3129',
    'https': 'https://127.0.0.1:3129'
}


def parse_html():
    u=ua.UserAgent().random
    options = Options()
    # options.add_argument('--headless')
    # options.add_argument('--disable-gpu')
    #options.add_argument('--proxy-server=' + proxies['http'])
    options.add_argument(f'user-agent={u}')
    driver = webdriver.Chrome(options=options)
    items=[]
    time.sleep(1)
    for i in range(2,30):
        driver.get(f"https://apteka.ru/category/vitamin-mineral/bad/?page={i}")
        elements=driver.find_elements(By.CSS_SELECTOR,'a[class="catalog-card__link"]')
        for element in elements:
            items.append(element.get_attribute('href'))
        time.sleep(1)

    return items


links=parse_html()
with open('links4.txt', 'w') as f:
    for link in links:
        f.write(link + '\n')
