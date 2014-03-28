# dvd_ripper

A command line tool that will make it easy to rip and tag your dvd collection. It ties together many great tools to get the job done. -- HandBrake, AtomicParsley, exiftool, imdb and tmdb.

It takes a bit on configuration, but once it is setup, ripping your DVD collection will be a breeze.

Enjoy!

## Installation

Install Handbrake: [downloads](https://handbrake.fr/downloads.php)
Install HandBrakeCLI: [downloads](https://handbrake.fr/downloads2.php)

    $ brew install AtomicParsley

    $ brew install exiftool

    $ brew install tag

    $ brew install libdvdcss

    $ gem install dvd_ripper

## Usage

    $ dvd_ripper

## Troubleshooting

### nokogiri fails to install
    $ xcode-select --install

    $ gem install nokogiri -- --use-system-libraries

    $ bundle config build.nokogiri --use-system-libraries

### HandBrake Errors

* Make sure that you have the same version of HandBrake and HandBrakeCLI
* Make sure that you have installed libdvdcss


## Notes

http://manpages.ubuntu.com/manpages/hardy/man1/AtomicParsley.1.html
https://github.com/cparratto/atomic-parsley-ruby

http://www.sno.phy.queensu.ca/~phil/exiftool/
http://miniexiftool.rubyforge.org

https://github.com/jdberry/tag

https://github.com/ahmetabdi/themoviedb
https://github.com/ariejan/imdb


## To Do

* Add ability to set HandBrake encoding options
* Add better support for TV show ripping
