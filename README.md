# Gpgenv

## Wat?
Gpgenv is similar to [envdir](http://cr.yp.to/daemontools/envdir.html), but it lets you use gpg-encrypted 
files. This is very useful if you want to store sensitive credentials on your machine, but you want to 
keep them encrypted. 

Please note that this is *not meant to run services*, despite its similarity to 
envdir: When you use it, you will be required to enter the passphrase to decrypt the gpg files. Robots and
automated processes should not have this passphrase (otherwise, why encrypt at all?). The primary use case for this is to stop *you, personally*,
from storing unencrypted, sensitive credentials on disk (like in your .netrc file, your ~/.aws/credentials file, etc), but to still make it
easy for you to actually use these sensitive credentials.

Also note that gpgenv will ask you to decrypt files *repeatedly* unless you have `gpg-agent` configured, which will make it borderline unusable.

Gpgenv plays very nicely with [pass](http://www.passwordstore.org/). For example:

```bash
# Set up a shortcut to your passwordstore home directory
export GPGENV_HOME=$HOME/.password-store

# Insert your oauth token into your password store:
pass insert myservice/OAUTH_TOKEN

# Use gpgenv to spawn a bash session:
gpgenv $GPGENV_HOME/myservice bash

# From the new bash session, use your oauth token to hit the service:
curl https://$user:$OAUTH_TOKEN@myservice.com/get_some_data
```

## Why?
As an admin, I am personally guilty of occasionally storing sensitive credentials on disk. Personal experience leads me to believe that this is
extremely common. Your .netrc file probably contains all sorts of sensitive data, and even if you use a gpg-encrypted .netrc file, many tools
simply don't understand gpg. Storing this stuff in plaintext is dangerous - but you do it anyway because the alternatives are just too painful.

I love [pass](http://www.passwordstore.org/), because it makes it easy to store passwords encrypted. But it doesn't make it easy to *use* them
(tbh, that isn't its job). I wrote `gpgenv` to bridge that gap, and make it easy for me to never store sensitive information in an unencrypted format 
on my own machine. I hope that you find it useful as well, and you use it to stop yourself from committing security sins.

## Installation
```gem install gpgenv```

## Usage

### Spawn a child process
Gpgenv can spawn a child process that inherits environment variables like so:
```bash
gpgenv /some/dir /some/other/dir "process_to_run argument1 argument2"
```

### Export environment variables
Gpgenv can export environment variables in your current shell session, like so:
```bash
eval `gpgshell /some/dir /some/other/dir`
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gpgenv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
