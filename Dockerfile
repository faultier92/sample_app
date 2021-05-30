# syntax=docker/dockerfile:1
FROM ruby:3.0
RUN apt-get update -qq && \
    apt-get install -y curl postgresql-client && \
    # Install nodejs
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    # Install yarn
    apt-get update -qq && \
    apt-get install -y npm && \
    npm install -g yarn

WORKDIR /enigma
COPY Gemfile /enigma/Gemfile
COPY Gemfile.lock /enigma/Gemfile.lock
RUN bundle install
COPY . /enigma

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]

