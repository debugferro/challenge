# Utrust Challenge

Utrust Challenge project for the role of Software Developer.

## 🚀 How to run it?

1. Clone the project `git clone git@bitbucket.org:gabriel1999/utrust_challenge.git`
2. Get into the project folder
   You can run the project's phoenix server with docker or without docker.

##### 🤖 Without docker:

Run the following:

- `mix deps.get && mix ecto.setup` and
- `mix phx.server` to start the server.

You can access the server at `http://localhost:4000`

##### 🐳 With docker:

Run the following:

- `docker-compose build` and
- `docker-compose up` to start it all.

Now you can access the server at `http://localhost:4000`
Remember to run `docker-compose down` after using it.

## ❓ How to use it?

In order to conduct a transaction, you must first create an account and then insert your tx hash and currency, on the new transaction page. 
The main page shows all of your transactions and you can check the status of every transaction in real-time.

Transactions that are open in the user browser are updated every 2 minutes.

## 💾 Database diagram

<p align="center">
   <img src="https://i.imgur.com/4iIU7hb.png">
</p>

**Subscription:** is the record that tells that the user is subscribed to a certain transaction, enabling the user to check the progress of it.

**Transaction:** is the record that has the transaction data. Many users can see a single transaction, depending if they are subscribed to it or not.
