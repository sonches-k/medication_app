from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

import fake_useragent as ua
import json
import random
import tempfile

proxies=[
{
    'http': 'http://127.0.0.1:3129',
    'https': 'https://127.0.0.1:3129',
},
{
    'http': 'http://127.0.0.1:3128',
    'https': 'https://127.0.0.1:3128',
},
{
    'http': 'http://127.0.0.1:3127',
    'https': 'https://127.0.0.1:3127',
},
{
    'http': 'http://127.0.0.1:3126',
    'https': 'https://127.0.0.1:3126',
},
{
    'http': 'http://127.0.0.1:3125',
    'https': 'https://127.0.0.1:3125',
},
{
    'http': 'http://127.0.0.1:3124',
    'https': 'https://127.0.0.1:3124',
},
{
    'http': 'http://127.0.0.1:3123',
    'https': 'https://127.0.0.1:3123',
},
{
    'http': 'http://127.0.0.1:3122',
    'https': 'https://127.0.0.1:3122',
},
]


def parse_html(link:str):
    temp_dir = tempfile.mkdtemp()

    options = Options()
    options.add_argument(f'--user-data-dir={temp_dir}')
    u=ua.UserAgent().random

    #options.add_argument('--headless')
    #options.add_argument('--disable-gpu')
    options.add_argument('--proxy-server=' + proxies[random.randint(0,7)]['http'])
    options.add_argument(f'user-agent={u}')
    driver = webdriver.Chrome(options=options)
    driver.get(link)

    name=driver.find_element(By.CSS_SELECTOR,'h1[class="ViewProductPage__title"]')
    name=name.text
    exp=driver.find_element(By.CLASS_NAME,'ProductExpiration').find_element(By.CSS_SELECTOR,'span').text

    count = driver.find_element(
        By.XPATH, "//dt[normalize-space(text())='В упаковке']/following-sibling::dd[1]//a"
    ).text

    print(name)
    print(exp)
    print(count)
    ans={
    "name":name,
    "exp":exp,
    "count":count,
    }

    return ans


ans={}
i=1
with open('links.txt', 'r', encoding='utf-8') as file:
    links = [line.strip() for line in file if line.strip()]
try:
    for k in range(0,len(links)):
        if k%10==0:
            with open("data.txt",'w',encoding="utf-8") as f:
                f.write(json.dumps(ans,ensure_ascii=False))
        try:
            ans[links[k]]=parse_html(links[k])
            print(i)
            i+=1
        except Exception as e:
            print(f"Error occurred while processing link {links[k]}: {e}")
            continue
except KeyboardInterrupt:
    with open("data.json",'w',encoding="utf-8") as f:
        f.write(json.dumps(ans,ensure_ascii=False))