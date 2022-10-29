from bs4 import BeautifulSoup
from urllib import request
 
def read_url(url):
  gfg = BeautifulSoup(request.urlopen(url).read(),features="html.parser")
  res = gfg.get_text()
  file_object = open('antismash.txt', 'a',encoding="utf-8")
  file_object.truncate(0)
  file_object.write(str(res))
  file_object.close()

