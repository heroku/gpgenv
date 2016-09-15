# Gpgenv

## Wat?
Gpgenv is similar to [envdir](http://cr.yp.to/daemontools/envdir.html), but it lets you use gpg-encrypted 
files. This is very useful if you want to store sensitive credentials on your machine, but you want to 
keep them encrypted. 

## Why?
As an admin, I am guilty of occasionally storing sensitive credentials on disk. Personal experience leads me to believe that this is
extremely common. Your .netrc file probably contains all sorts of sensitive data, and even if you use a gpg-encrypted .netrc file, many tools
simply don't understand gpg. Storing this stuff in plaintext is dangerous - but you do it anyway because the alternatives are just too painful.

I love [pass](http://www.passwordstore.org/), because it makes it easy to store passwords encrypted. But it doesn't make it easy to *use* them in any capacity other than copy-and-pasting them. I wrote `gpgenv` to bridge that gap, and make it easy for me to never store sensitive information in an unencrypted format 
on my own machine. I hope that you find it useful as well, and you use it to stop yourself from committing security sins.

## Installation
```gem install gpgenv```

## Usage

### Setup
```bash
# You might want to add this to your profile.
export GPGENV_KEY_ID=<key-id-to-use-to-encrypt-stuff>
```

### Create or update files in a .gpgenv directory

Gpgenv can create a .gpgenv directory without you ever needing to store plaintext 
files permanently on disk. Simply run `gpgedit` to create a new .gpgenv 
directory or edit the keys and values in an existing one.

Alternatively, if you have a .env file and you'd like to switch to gpgenv, run
`dotenv2gpg`. You can switch back by running `gpg2dotenv`, if you choose.

### Run a process
Gpgenv can spawn a child process that inherits environment variables like so:
```bash
gpgenv "process_to_run argument1 argument2"
```

### Export environment variables
Gpgenv can export environment variables in your current shell session, like so:
```bash
cd /dir/that/contains/.gpgenv
eval `gpgshell`
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gpgenv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
