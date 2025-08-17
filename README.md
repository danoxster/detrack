# detrack
Interview assignment for Detrack by Dan Simmonds

## Description

You are tasked with building a command-line application using Ruby. Given a JSON dataset
with clients (aBached), the application will need to offer two commands:
* Search through all clients and return those with names partially matching a given
search query
* Find out if there are any clients with the same email in the dataset, and show those
duplicates if any are found.

## Running Locally

### Install the applicaiton

Requirements:
* ruby installation (this was written with ruby 3.4)
* git installed

Clone the github repository, cd to the repo directory and run:

```
gem build client_search.gemspec
gem install ./client_search-0.0.1.gem
```

This will install the application.

### Run the application

Usage is:

```
client_search <search_term> [filename] (or pipe JSON via stdin)
```

To test this with a the provided clients.json file use:

```
client_search jane test/fixtures/clients.json
```

This will return the following output to STDIN:

```
Search results:
Jane Smith (2) <jane.smith@yahoo.com>
Another Jane Smith (15) <jane.smith@yahoo.com>
```

Alternatively you can send the file to STDIN with:

```
client_search jane < test/fixtures/clients.json
```

## Running in Docker

if you do not have a local ruby runtime you can use docker to build and run the application.

After cloning the repository run:

```
docker build -t client_search .
```

Then you can use docker to run the application:

```
docker run -i --rm client_search client_search jane test/fixtures/clients.json
```

Note: that this will use the client.json file in the docker container. To use a local file you need to send the contents via STDIN like:

```
docker run -i --rm client_search client_search jane < test/fixtures/clients.json
```

