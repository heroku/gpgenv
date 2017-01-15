# Gpgenv

## Wat?
Gpgenv is similar to [envdir](http://cr.yp.to/daemontools/envdir.html) and [dotenv](https://github.com/bkeepers/dotenv), but it lets you use gpg-encrypted files. This is useful if you want to store sensitive credentials on your machine, but you want to 
keep them encrypted. 

## Why?
As an admin, I am guilty of occasionally storing sensitive credentials on disk. Personal experience leads me to believe that this is
extremely common. Your .netrc file probably contains all sorts of sensitive data, and even if you use a gpg-encrypted .netrc file, many tools simply don't understand gpg. Storing this stuff in plaintext is dangerous, but you do it anyway because the alternatives are just too painful.

I love [pass](http://www.passwordstore.org/), because it makes it easy to store passwords encrypted. But it doesn't make it easy to *use* 
them in any capacity other than copy-and-pasting them. I wrote `gpgenv` to bridge that gap: Easily edit gpg-encrypted files, easily
export them as environment variables, and never store sensitive information in plaintext on your machine. 
I hope that you find `gpgenv` useful, and you use it to avoid security sins.

## Installation
`gem install gpgenv`

## Usage

### Setup
```bash
# Add this to your profile:
export GPGENV_KEY_ID=<key-id-to-use-to-encrypt-stuff>
```

### Create or update files in a .gpgenv directory

Gpgenv can create a .gpgenv directory without you ever needing to store plaintext 
files permanently on disk. Use `gpgenv edit` to edit a `yaml` file using `$EDITOR`.
When you are done editing the file, it will be parsed and saved to your `.gpgenv` directory.

You can also use `gpgenv import` to convert a `.env` file in the current directory to a `.gpgenv`
directory.

### Run a process
Gpgenv can spawn a child process that inherits environment variables like so:
```bash
gpgenv exec <command>  arg1 arg2 ...
```

### Export environment variables
Gpgenv can export environment variables in your current shell session, like so:

```bash
cd /dir/that/contains/.gpgenv
eval `gpgshell`
```

### Profiles

Gpgenv supports profiles. Create a ~/.gpgenvrc file like this:

```yaml
---
profile1:
  - /home/YOU/.gpgenv/dir1
  - /home/YOU/.gpgenv/extra_stuff
profile2:
  - /home/YOU/.gpgenv/dir1
```

You can then pass a `-p` parameter to `gpenv exec` or `gpgenv shell` specifying
which profile to use, rather than using the `.gpgenv` directory relative to the current path.
All of the directories specified in the profile will be loaded sequentially.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gpgenv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
