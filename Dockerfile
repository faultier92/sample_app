# syntax=docker/dockerfile:1
FROM ruby:3.1
RUN apt-get update -qq && \
    apt-get install -y curl postgresql-client && \
    apt-get install -y gcc g++ make imagemagick && \
    apt-get update 

WORKDIR /sample_app
COPY Gemfile /sample_app/Gemfile
COPY Gemfile.lock /sample_app/Gemfile.lock
RUN bundle install
COPY . /sample_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
