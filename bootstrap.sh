which gem | grep -q rvm
if [ $? -eq 0 ]; then
  gem uninstall cider
  gem install   cider
else
  sudo gem uninstall cider
  sudo gem install   cider
fi
hash -r
cider
source ~/.cider.profile
