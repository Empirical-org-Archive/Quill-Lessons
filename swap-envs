
if [ -f .rbenv-vars-local ]
then
  mv .rbenv-vars .rbenv-vars-remote
  mv .rbenv-vars-local .rbenv-vars
  echo switched to local
else
  mv .rbenv-vars .rbenv-vars-local
  mv .rbenv-vars-remote .rbenv-vars
  echo switched to remote
fi
