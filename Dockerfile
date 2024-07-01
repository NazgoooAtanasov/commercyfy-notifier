FROM elixir:1.17.1-otp-27-alpine
COPY . /app
WORKDIR /app
RUN mix deps.get
CMD mix run --no-halt
