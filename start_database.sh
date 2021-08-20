#!/bin/bash

docker run --name postgres_lean_coffee \
  -e POSTGRES_DB=lean_coffee_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres
