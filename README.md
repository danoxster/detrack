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
> client_search --help
client_search --name <search_term> [filename] (or pipe JSON via stdin)
client_search --duplicates [filename] (or pipe JSON via stdin)
client_search --help
  -n, --name SEARCH_TERM           Search for clients by partial name match
  -d, --duplicates                 Find clients with duplicate email addresses
  -h, --help                       Show this help message
```

To test this with a the provided clients.json file use:

```
client_search --name jane test/fixtures/clients.json
client_search --duplicates test/fixtures/clients.json
```

This will return the following output to STDIN:

```
Name search results for 'jane':
Jane Smith (2) <jane.smith@yahoo.com>
Another Jane Smith (15) <jane.smith@yahoo.com>

Duplicate email search results:

Duplicate email: jane.smith@yahoo.com
  Jane Smith (2) <jane.smith@yahoo.com>
  Another Jane Smith (15) <jane.smith@yahoo.com>
```

Alternatively you can send the file to STDIN with:

```
client_search --name jane < test/fixtures/clients.json
```

## Running in Docker

if you do not have a local ruby runtime you can use docker to build and run the application.

### Build the image

After cloning the repository run:

```
docker build -t client_search .
```

### Run in docker

To run the application use:

```
docker run -i --rm client_search --name jane test/fixtures/clients.json
docker run -i --rm client_search --duplicates test/fixtures/clients.json
```

Note: that this will use the client.json file in the docker container. To use a local file you need to send the client list via STDIN like:

```
docker run -i --rm client_search --name jane < test/fixtures/clients.json
docker run -i --rm client_search --duplicates < test/fixtures/clients.json
```

## Assumptions and decisions

* I have assumed that the input file will be generally well formed. There is error checking around the JSON parsing, but I haven't done any validation on the format of the data. This could be done fairly easily with json schema, or even just verifying that each client object has the expected fields. If fields are missing then the client objects will have nil values. A better solution would be to filter out clients that fail validation.
* I also haven't done error checking around the id type. The Client object will finesse this into an int, but if it fails then we'll end up with nil ids. This could be better.
* I have added the docker option mostly because I wanted to use a newer version of ruby than the one on my computer and didn't want to insall a new version. You will need to have docker installed in order for that to work.
* The actual code that performs the searches is quite simple. Most of the work here has gone into testing and environment. I've done my best to make this as runnable as possible in any sort of environment. I have stuck to standard ruby libraries, no dependencies, no need to install `bundler`. This should all run on vanilla ruby.
* I have made the assumption that the size of data here will be around the size of the data provided. This should still work with thousands of client entries, but may struggle with tens of thousands. I made this decision as it was explicitly stated that scale will be addressed in the follow up interview.
* I timed-boxed this to just what I could get done on a Sunday evening. With more time I would have added some linting to this project to reduce the cognitive load around code style.

## Wishlist

With more time I would make a few improvements like:
* Fuzzy searching on names. Instead of just looking for exact substring matches, we could calculate the distance between a search term and each name, then return a limited number of entries by the word distance. This would return results in order of relevance and reduce mistakes made by typos in search terms or not knowing the exact spelling of a name.
* Better output formatting. The current format is a very simple `to_s` method on the Client object. And improvement would be to return results in a table format which would be easier on the eyes. In addition we could provide formatting options such as JSON or CSV for clients that want to perform further processing on the filtered data.
