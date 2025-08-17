FROM ruby:3.4-alpine

WORKDIR /client_search/

COPY . /client_search/

RUN rake test
RUN gem build client_search.gemspec
RUN gem install ./client_search-0.0.1.gem
