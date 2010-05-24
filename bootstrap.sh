which gem | grep -q rvm
if [ $? -eq 0 ]; then
  gem uninstall cider
  gem install   cider --no-rdoc --no-ri
else
  sudo gem uninstall cider
  sudo gem install   cider --no-rdoc --no-ri
fi
hash -r
cider
source ~/.cider.profile
