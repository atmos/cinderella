echo "Ensuring we have the latest version of cider installed"
echo "Run started `date`" >> ~/.cider.bootstrap.log 2>&1
which ruby >> ~/.cider.bootstrap.log 2>&1
which gem  >> ~/.cider.bootstrap.log 2>&1

which gem | grep -q rvm
if [ $? -eq 0 ]; then
  gem uninstall cider -aIx              >> ~/.cider.bootstrap.log 2>&1
  gem install   cider --no-rdoc --no-ri >> ~/.cider.bootstrap.log 2>&1
else
  sudo gem uninstall cider -aIx              >> ~/.cider.bootstrap.log 2>&1
  sudo gem install   cider --no-rdoc --no-ri >> ~/.cider.bootstrap.log 2>&1
fi

echo "Cider installed successfully"

hash -r
cider
if [ "$?" -eq "0" ]; then
  if [ -d ~/.cider ]; then
    mv ~/.cider.bootstrap.log ~/.cider
  fi
  source ~/.cider.profile
  hash -r
else
  cat ~/.cider.bootstrap.log
  echo ""
  echo "Something went wonky with the install. :("
fi
