echo "Ensuring we have the latest version of cinderella installed"
echo "Run started `date`" >> ~/.cinderella.bootstrap.log 2>&1
which ruby >> ~/.cinderella.bootstrap.log 2>&1
which gem  >> ~/.cinderella.bootstrap.log 2>&1

which gem | grep -q rvm
if [ $? -eq 0 ]; then
  gem uninstall cinderella -aIx              >> ~/.cinderella.bootstrap.log 2>&1
  gem install   cinderella --no-rdoc --no-ri >> ~/.cinderella.bootstrap.log 2>&1
else
  sudo gem uninstall cinderella -aIx              >> ~/.cinderella.bootstrap.log 2>&1
  sudo gem install   cinderella --no-rdoc --no-ri >> ~/.cinderella.bootstrap.log 2>&1
fi

echo "Cinderella installed successfully"

hash -r
cinderella
if [ "$?" -eq "0" ]; then
  if [ -d ~/.cinderella ]; then
    mv ~/.cinderella.bootstrap.log ~/.cinderella
  fi
  source ~/.cinderella.profile
  hash -r
else
  echo "Something went wonky, retrying"
  cinderella
  if [ "$?" -eq "0" ]; then
    source ~/.cinderella.profile
    hash -r
  else
    echo "Something went wonky again, retrying once more"
    cinderella
    if [ "$?" -eq "0" ]; then
      source ~/.cinderella.profile
      hash -r
    else
      cat ~/.cinderella.bootstrap.log
      echo ""
      echo "Something went wonky with the install. :("
    fi
  fi
fi
