echo "Ensuring we have the latest version of cinderella installed"
echo "A first time install takes about 45 minutes on a modern machine"

mkdir -p ~/.cinderella
echo "Run started `date`" >> ~/.cinderella/bootstrap.log 2>&1
which ruby >> ~/.cinderella/bootstrap.log 2>&1
which gem  >> ~/.cinderella/bootstrap.log 2>&1

if [ `gem --version` != "1.7.2" ]; then
  echo "You need to upgrade rubygems to 1.7.2"
fi

which gem | grep -q rvm
if [ $? -eq 0 ]; then
  gem uninstall cinderella -aIx                   >> ~/.cinderella/bootstrap.log 2>&1
  gem install   cinderella --no-rdoc --no-ri      >> ~/.cinderella/bootstrap.log 2>&1
else
  sudo gem uninstall cinderella -aIx              >> ~/.cinderella/bootstrap.log 2>&1
  sudo gem install   cinderella --no-rdoc --no-ri >> ~/.cinderella/bootstrap.log 2>&1
  sudo gem update                                 >> ~/.cinderella/bootstrap.log 2>&1
fi

echo "Cinderella installed successfully"

/usr/bin/cinderella

if [ "$?" -eq "0" ]; then
  exit 0
else
  cat ~/.cinderella/bootstrap.log
  echo ""
  echo "Something went wrong with the install. :("
  echo "Dump this log into a gist and link to me to it"
  echo "http://github.com/atmos/cinderella/issues"
  echo "Sorry it failed. :("
fi

